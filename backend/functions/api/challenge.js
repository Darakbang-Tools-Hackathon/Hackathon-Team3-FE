const { db, onCall, HttpsError, logger } = require("../common");
const { getFirestore } = require("firebase-admin/firestore");
const admin = require("firebase-admin");

exports.getTodayMission = onCall(async (request) => {
  if (!request.auth) {
    logger.warn("getTodayMission: Unauthenticated user.");
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }

  const missionRef = db.collection("config").doc("todayMission");

  try {
    const doc = await missionRef.get();
    if (!doc.exists) {
      logger.error("getTodayMission: 'todayMission' document does not exist!");
      throw new HttpsError("not-found", "오늘의 미션 정보를 찾을 수 없습니다.");
    }
    logger.log("Fetched todayMission:", doc.data());
    return doc.data();
  } catch (error) {
    logger.error("Error fetching todayMission:", error);
    throw new HttpsError("internal", "미션 정보 로딩 중 오류가 발생했습니다.");
  }
});

exports.processChallengeResult = onCall(async (request) => {
  if (!request.auth) {
    logger.warn("processChallengeResult: Unauthenticated user.");
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }

  const userId = request.auth.uid;
  const result = request.data.result;
  if (result !== "success" && result !== "fail") {
    logger.warn("processChallengeResult: Invalid result value");
    throw new HttpsError("invalid-argument", "결과값이 유효하지 않습니다.");
  }

  const today = new Date();
  today.setHours(today.getHours() + 9);
  const dateStr = today.toISOString().split("T")[0];

  const userRef = db.collection("users").doc(userId);
  const challengeId = `${dateStr}_${userId}`;
  const challengeRef = db.collection("challenges").doc(challengeId);

  try {
    await getFirestore().runTransaction(async (transaction) => {
      const userDoc = await transaction.get(userRef);
      if (!userDoc.exists) throw new Error("User document not found!");

      const userData = userDoc.data();
      const teamIds = userData.teamIds || [];
      const primaryTeamId = teamIds.length > 0 ? teamIds[0] : null;

      transaction.set(challengeRef, {
        userId,
        date: dateStr,
        status: result,
      });

      const isSuccess = result === "success";
      const lpChange = isSuccess ? 100 : -10;
      const successCountChange = isSuccess ? 1 : 0;

      transaction.update(userRef, {
        userLP: (userData.userLP || 0) + lpChange,
        lastChallengeStatus: result,
        weeklySuccessCount:
          (userData.weeklySuccessCount || 0) + successCountChange,
      });

      if (primaryTeamId) {
        const teamRef = db.collection("teams").doc(primaryTeamId);
        const teamDoc = await transaction.get(teamRef);
        if (!teamDoc.exists) return;

        const teamData = teamDoc.data();
        const updates = {};
        updates.teamLP = (teamData.teamLP || 0) + lpChange;

        if (isSuccess) {
          const memberKey = `members.${userId}.weeklySuccessCount`;
          const prev = teamData.members?.[userId]?.weeklySuccessCount || 0;
          updates[memberKey] = prev + 1;

          const achvId = "proofOfSleep";
          const target = 100;
          const reward = 1000;
          const total = (teamData.totalSuccessCount || 0) + 1;
          updates.totalSuccessCount = total;

          const achieved = teamData.achievements?.[achvId];
          if (total === target && !achieved) {
            updates.teamLP += reward;
            updates[`achievements.${achvId}`] =
              admin.firestore.FieldValue.serverTimestamp();

            const memberIds = Object.keys(teamData.members || {});
            for (const uid of memberIds) {
              const mRef = db.collection("users").doc(uid);
              const mDoc = await transaction.get(mRef);
              if (mDoc.exists) {
                const data = mDoc.data();
                transaction.update(mRef, {
                  userLP: (data.userLP || 0) + reward,
                });
              }
            }
            logger.log(`[${achvId}] achieved by team ${primaryTeamId}`);
          }
        } else {
          const failKey = `weeklyFailDays.${dateStr}`;
          if (!teamData.weeklyFailDays || !teamData.weeklyFailDays[dateStr]) {
            updates[failKey] = true;
          }
        }

        if (Object.keys(updates).length > 0) {
          transaction.update(teamRef, updates);
        }
      }
    });

    logger.log(`Success: challenge result '${result}' for user ${userId}`);
    return { success: true, result };
  } catch (error) {
    logger.error(`Error: challenge result for user ${userId}:`, error);
    throw new HttpsError(
      "internal",
      "챌린지 결과 처리 중 오류가 발생했습니다."
    );
  }
});
