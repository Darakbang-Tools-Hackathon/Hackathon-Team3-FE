const {db, onCall, HttpsError, logger} = require("../common");
const {getFirestore} = require("firebase-admin/firestore");
const admin = require("firebase-admin");

/**
 * @return {string} 4자리 랜덤 코드 생성
 */
function generateJoinCode() {
  return Math.random().toString(36).substring(2, 6).toUpperCase();
}

// create team
exports.createTeam = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const {teamName, accessType = "public"} = data;
  if (!teamName || typeof teamName !== "string" || teamName.length < 2) {
    throw new HttpsError("invalid-argument", "팀 이름은 2글자 이상이어야 합니다.");
  }
  if (!["public", "private"].includes(accessType)) {
    throw new HttpsError(
        "invalid-argument",
        "accessType은 'public' 또는 'private'이어야 합니다.",
    );
  }

  try {
    const userId = context.auth.uid;
    const displayName = context.auth.token.name || "user";
    const joinCode = generateJoinCode();

    const newTeam = {
      teamName: teamName,
      teamLP: 0,
      joinCode: joinCode,
      accessType: accessType,
      leaderId: userId,
      members: {
        [userId]: {
          displayName: displayName,
          weeklySuccessCount: 0,
        },
      },
      pendingMembers: accessType === "private" ? {} : null,
    };

    const teamRef = await db.collection("teams").add(newTeam);
    const teamId = teamRef.id;

    // 다중 팀 및 팀장 관리: /users/{userId}에 teamIds 및 leaderOf 배열 업데이트
    await db.collection("users").doc(userId).update({
      teamIds: admin.firestore.FieldValue.arrayUnion(teamId), // 멤버십 추가
      leaderOf: admin.firestore.FieldValue.arrayUnion(teamId), // 팀장 목록에 추가
    });

    return {
      status: "success",
      teamId: teamId,
      joinCode: joinCode,
    };
  } catch (error) {
    logger.error("팀 생성 중 오류:", error);
    throw new HttpsError("internal", "팀 생성에 실패했습니다.");
  }
});


// join team
exports.joinTeam = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const joinCode = data.joinCode;
  if (!joinCode || typeof joinCode !== "string") {
    throw new HttpsError("invalid-argument", "참여 코드가 올바르지 않습니다.");
  }

  const userId = context.auth.uid;
  const displayName = context.auth.token.name || "user";
  const teamsRef = db.collection("teams");

  try {
    await getFirestore().runTransaction(async (transaction) => {
      // 팀 코드 검색
      const teamQuery = await transaction.get(
          teamsRef.where("joinCode", "==", joinCode.toUpperCase()),
      );

      if (teamQuery.empty) {
        throw new HttpsError("not-found", "존재하지 않는 참여 코드입니다.");
      }

      const teamDoc = teamQuery.docs[0];
      const teamId = teamDoc.id;
      // const teamData = teamDoc.data();
      const userRef = db.collection("users").doc(userId);
      const userDoc = await transaction.get(userRef);
      const userData = userDoc.data();
      const currentTeamIds = userData.teamIds || [];

      // 이미 팀에 속해있는지
      if (currentTeamIds.includes(teamId)) {
        throw new HttpsError("failed-precondition", "이미 이 팀의 멤버입니다.");
      }

      /*
    // ------ public vs. private team (보류) ------
    if (teamData.accessType === "public") {
      const memberUpdateKey = `members.${userId}`;
      transaction.update(teamDoc.ref, {
        [memberUpdateKey]: {
          displayName: displayName,
          weeklySuccessCount: 0,
        },
      });
      transaction.update(userRef, {
        teamIds: admin.firestore.FieldValue.arrayUnion(teamId),
      });
      return {status: "success", message: "팀에 성공적으로 참가했습니다."};
    } else {
      if (teamData.pendingMembers && teamData.pendingMembers[userId]) {
        throw new HttpsError("already-exists", "이미 가입 요청을 보냈습니다.");
      }

      const pendingMemberUpdateKey = `pendingMembers.${userId}`;
      transaction.update(teamDoc.ref, {
        [pendingMemberUpdateKey]: {
          displayName: displayName,
          requestedAt: new Date().toISOString(),
        },
      });
      return {status: "pending", message: "팀장 승인을 기다리는 중입니다."};
    }
    */

      const memberUpdateKey = `members.${userId}`;
      transaction.update(teamDoc.ref, {
        [memberUpdateKey]: {
          displayName: displayName,
          weeklySuccessCount: 0,
        },
      });
      transaction.update(userRef, {
        teamIds: admin.firestore.FieldValue.arrayUnion(teamId),
      });
      return {
        status: "success",
        message: "팀에 성공적으로 참가했습니다.",
      };
    });

    return {status: "success", message: "처리 완료"};
  } catch (error) {
    logger.error("팀 참가 중 에러:", error);
    if (error.code) throw error;
    throw new HttpsError("internal", "팀 참가에 실패했습니다.");
  }
});

// 팀장 권한: 팀원 강퇴
exports.kickMember = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const leaderId = context.auth.uid;
  const {teamId, memberIdToKick} = data;

  if (!teamId || !memberIdToKick) {
    throw new HttpsError("invalid-argument", "팀 ID 또는 강퇴할 멤버 ID가 필요합니다.");
  }

  if (leaderId === memberIdToKick) {
    throw new HttpsError(
        "failed-precondition",
        "팀장은 자신을 강퇴할 수 없습니다. 팀 탈퇴 기능을 사용하세요.",
    );
  }

  try {
    await getFirestore().runTransaction(async (transaction) => {
      const teamRef = db.collection("teams").doc(teamId);
      const userRef = db.collection("users").doc(memberIdToKick);
      const teamDoc = await transaction.get(teamRef);
      const userDoc = await transaction.get(userRef);

      if (!teamDoc.exists) {
        throw new HttpsError(
            "not-found",
            "팀이 존재하지 않습니다.",
        );
      }

      if (!userDoc.exists) {
        throw new HttpsError(
            "not-found",
            "강퇴할 유저를 찾을 수 없습니다.",
        );
      }

      const teamData = teamDoc.data();
      const userData = userDoc.data();

      // 팀장 권한 확인
      if (teamData.leaderId !== leaderId) {
        throw new HttpsError("permission-denied", "팀장만 팀원을 강퇴할 수 있습니다.");
      }

      // 멤버 확인
      if (!teamData.members || !teamData.members[memberIdToKick]) {
        throw new HttpsError("not-found", "해당 멤버는 팀에 속해 있지 않습니다.");
      }

      // 멤버 삭제
      const newMembers = {...teamData.members};
      delete newMembers[memberIdToKick];

      transaction.update(teamRef, {
        members: newMembers,
      });

      // 강퇴된 유저의 /users/{memberIdToKick}에서 teamIds 및 leaderOf 초기화
      const memberIsLeader = (userData.leaderOf || []).includes(teamId);

      const userUpdateData = {
        teamIds: admin.firestore.FieldValue.arrayRemove(teamId), // 멤버십 제거
      };
      if (memberIsLeader) {
        userUpdateData.leaderOf =
          admin.firestore.FieldValue.arrayRemove(teamId);
      }


      transaction.update(userRef, userUpdateData);
    });

    return {status: "success", message: "팀원을 성공적으로 강퇴했습니다."};
  } catch (error) {
    logger.error("팀원 강퇴 중 오류:", error);
    if (error.code) {
      throw error;
    }
    throw new HttpsError("internal", "팀원 강퇴에 실패했습니다.");
  }
});


// 팀장 위임
exports.delegateLeader = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const currentLeaderId = context.auth.uid;
  const {teamId, newLeaderId} = data;

  if (!teamId || !newLeaderId) {
    throw new HttpsError("invalid-argument", "팀 ID와 새 팀장 ID가 필요합니다.");
  }
  if (currentLeaderId === newLeaderId) {
    throw new HttpsError("failed-precondition", "자기 자신에게 위임할 수 없습니다.");
  }

  try {
    await getFirestore().runTransaction(async (transaction) => {
      const teamRef = db.collection("teams").doc(teamId);
      const newLeaderUserRef = db.collection("users").doc(newLeaderId);
      const currentLeaderUserRef = db.collection("users").doc(currentLeaderId);

      const teamDoc = await transaction.get(teamRef);
      const newLeaderUserDoc = await transaction.get(newLeaderUserRef);

      if (!teamDoc.exists) {
        throw new HttpsError(
            "not-found",
            "팀이 존재하지 않습니다.",
        );
      }

      if (!newLeaderUserDoc.exists) {
        throw new HttpsError(
            "not-found",
            "새 팀장을 찾을 수 없습니다.",
        );
      }


      const teamData = teamDoc.data();

      // 팀장 확인
      if (teamData.leaderId !== currentLeaderId) {
        throw new HttpsError("permission-denied", "현재 팀장만 권한을 위임할 수 있습니다.");
      }

      // 새 리더가 팀 멤버인지 확인
      if (!teamData.members || !teamData.members[newLeaderId]) {
        throw new HttpsError("not-found", "위임할 멤버가 팀에 속해 있지 않습니다.");
      }

      // leaderId update
      transaction.update(teamRef, {
        leaderId: newLeaderId,
      });

      // 현재 팀장의 leaderOf에서 teamId 제거
      transaction.update(currentLeaderUserRef, {
        leaderOf: admin.firestore.FieldValue.arrayRemove(teamId),
      });

      // 새 팀장의 leaderOf에서 teamId 추가
      transaction.update(newLeaderUserRef, {
        leaderOf: admin.firestore.FieldValue.arrayUnion(teamId),
      });
    });

    return {status: "success", message: "팀장 권한을 성공적으로 위임했습니다."};
  } catch (error) {
    logger.error("팀장 위임 중 오류:", error);
    if (error.code) {
      throw error;
    }
    throw new HttpsError("internal", "팀장 위임에 실패했습니다.");
  }
});


// 팀 탈퇴
exports.leaveTeam = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const userId = context.auth.uid;
  const {teamId} = data;
  const userRef = db.collection("users").doc(userId);

  if (!teamId) {
    // teamId가 없으면 /users에서만 teamIds와 leaderOf를 정리하고 종료
    await userRef.update({
      teamIds: admin.firestore.FieldValue.arrayRemove(null),
      leaderOf: admin.firestore.FieldValue.arrayRemove(null),
    });
    return {status: "success", message: "유저 문서 정리 완료."};
  }

  try {
    await getFirestore().runTransaction(async (transaction) => {
      const teamRef = db.collection("teams").doc(teamId);
      const teamDoc = await transaction.get(teamRef);

      if (!teamDoc.exists) {
        // 팀이 삭제되었을 경우, 유저 문서에서만 팀 ID 정리
        transaction.update(userRef, {
          teamIds: admin.firestore.FieldValue.arrayRemove(teamId),
          leaderOf: admin.firestore.FieldValue.arrayRemove(teamId),
        });
        return;
      }
      const teamData = teamDoc.data();
      const isLeaderOfThisTeam = teamData.leaderId === userId;

      if (teamData.members && teamData.members[userId]) {
        const newMembers = {...teamData.members};
        delete newMembers[userId];

        transaction.update(teamRef, {
          members: newMembers,
        });

        // 팀장 탈퇴
        if (isLeaderOfThisTeam) {
          const remainingMembers = Object.keys(newMembers);
          if (remainingMembers.length > 0) {
            // 남은 멤버가 있으면 첫 번째 멤버에게 위임
            transaction.update(teamRef, {leaderId: remainingMembers[0]});
          } else {
            // 남은 멤버가 없으면 팀 삭제
            transaction.delete(teamRef);
          }
        }
      }

      // teamIds, leaderOf에서 teamId 제거
      transaction.update(userRef, {
        teamIds: admin.firestore.FieldValue.arrayRemove(teamId),
        leaderOf: admin.firestore.FieldValue.arrayRemove(teamId),
      });
    });

    return {status: "success", message: "팀에서 성공적으로 탈퇴했습니다."};
  } catch (error) {
    logger.error("팀 탈퇴 중 오류:", error);
    if (error.code) {
      throw error;
    }
    throw new HttpsError("internal", "팀 탈퇴에 실패했습니다.");
  }
});

/* ------ 가입 요청 (보류) ------

// 가입 요청 승인
exports.acceptJoinRequest = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const leaderId = context.auth.uid;
  const {teamId, pendingMemberId} = data;

  if (!teamId || !pendingMemberId) {
    throw new HttpsError("invalid-argument", "팀 ID와 승인할 멤버 ID가 필요합니다.");
  }

  try {
    await getFirestore().runTransaction(async (transaction) => {
      const teamRef = db.collection("teams").doc(teamId);
      const userRef = db.collection("users").doc(pendingMemberId);
      const teamDoc = await transaction.get(teamRef);
      const userDoc = await transaction.get(userRef);

      if (!teamDoc.exists) {
        throw new HttpsError("not-found", "팀이 존재하지 않습니다.");
      }
      if (!userDoc.exists) {
        throw new HttpsError("not-found", "유저를 찾을 수 없습니다.");
      }

      const teamData = teamDoc.data();
      const userData = userDoc.data();

      // 팀장 권한 확인
      if (teamData.leaderId !== leaderId) {
        throw new HttpsError("permission-denied", "팀장만 가입 요청을 승인할 수 있습니다.");
      }

      if (!teamData.pendingMembers ||
        !teamData.pendingMembers[pendingMemberId]) {
        throw new HttpsError("failed-precondition", "대기 중인 요청이 없습니다.");
      }

      if ((userData.teamIds || []).includes(teamId)) {
        throw new HttpsError("already-exists", "유저가 이미 팀 멤버입니다.");
      }

      const memberUpdateKey = `members.${pendingMemberId}`;
      const pendingRemoveKey = `pendingMembers.${pendingMemberId}`;

      transaction.update(teamDoc.ref, {
        [memberUpdateKey]: {
          displayName: userData.displayName || "user",
          weeklySuccessCount: 0,
        },
        [pendingRemoveKey]: admin.firestore.FieldValue.delete(),
      });

      transaction.update(userRef, {
        teamIds: admin.firestore.FieldValue.arrayUnion(teamId),
      });
    });

    return {status: "success", message: "가입 요청을 성공적으로 승인했습니다."};
  } catch (error) {
    logger.error("가입 승인 중 오류:", error);
    if (error.code) {
      throw error;
    }
    throw new HttpsError("internal", "가입 승인에 실패했습니다.");
  }
});


// 가입 요청 거절
exports.rejectJoinRequest = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const leaderId = context.auth.uid;
  const {teamId, pendingMemberId} = data;

  if (!teamId || !pendingMemberId) {
    throw new HttpsError("invalid-argument", "팀 ID와 거절할 멤버 ID가 필요합니다.");
  }

  try {
    const teamRef = db.collection("teams").doc(teamId);
    const teamDoc = await teamRef.get();

    if (!teamDoc.exists) {
      throw new HttpsError("not-found", "팀이 존재하지 않습니다.");
    }
    const teamData = teamDoc.data();

    // 팀장 권한 확인
    if (teamData.leaderId !== leaderId) {
      throw new HttpsError("permission-denied", "팀장만 요청을 거절할 수 있습니다.");
    }

    if (!teamData.pendingMembers || !teamData.pendingMembers[pendingMemberId]) {
      throw new HttpsError("failed-precondition", "대기 중인 요청이 없습니다.");
    }

    const pendingRemoveKey = `pendingMembers.${pendingMemberId}`;
    await teamRef.update({
      [pendingRemoveKey]: admin.firestore.FieldValue.delete(),
    });

    return {status: "success", message: "가입 요청을 성공적으로 거절했습니다."};
  } catch (error) {
    logger.error("가입 거절 중 오류:", error);
    if (error.code) {
      throw error;
    }
    throw new HttpsError("internal", "가입 거절에 실패했습니다.");
  }
});


// 가입 요청 목록 조회
exports.getPendingRequests = onCall(async (data, context) => {
  if (!context.auth) {
    throw new HttpsError("unauthenticated", "로그인이 필요한 기능입니다.");
  }

  const leaderId = context.auth.uid;
  const {teamId} = data;

  if (!teamId) {
    throw new HttpsError("invalid-argument", "팀 ID가 필요합니다.");
  }

  try {
    const teamRef = db.collection("teams").doc(teamId);
    const teamDoc = await teamRef.get();

    if (!teamDoc.exists) {
      throw new HttpsError("not-found", "팀이 존재하지 않습니다.");
    }
    const teamData = teamDoc.data();

    // 팀장 권한 확인
    if (teamData.leaderId !== leaderId) {
      throw new HttpsError("permission-denied", "팀장만 요청 목록을 조회할 수 있습니다.");
    }


    const pendingMembers = teamData.pendingMembers || {};

    const requests = Object.keys(pendingMembers).map((userId) => ({
      userId: userId,
      displayName: pendingMembers[userId].displayName,
      requestedAt: pendingMembers[userId].requestedAt,
    }));

    return {status: "success", requests: requests};
  } catch (error) {
    logger.error("가입 요청 목록 조회 중 오류:", error);
    if (error.code) {
      throw error;
    }
    throw new HttpsError("internal", "요청 목록 조회에 실패했습니다.");
  }
});
*/
