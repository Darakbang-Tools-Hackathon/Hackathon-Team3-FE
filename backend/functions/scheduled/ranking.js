const {db, logger, onSchedule} = require("../common");
const admin = require("firebase-admin");

/**
 * [scheduler]
 * 매주 월요일 KST 00:00에 실행되어 주간 랭킹을 계산하고,
 * 주간 업적을 처리합니다.
 */
exports.processWeeklyRanking = onSchedule(
  {
    schedule: "0 0 * * 1",
    timeZone: "Asia/Seoul",
  },
  async (_context) => {
    logger.log("--- 주간 랭킹 및 업적 처리 스케줄러 시작 (매주 월요일 00:00 KST) ---");

      try {
        const teamsSnapshot = await db.collection("teams").get();

        if (teamsSnapshot.empty) {
          logger.log("처리할 팀이 없습니다.");
          return null;
        }

        // 랭킹 계산
        const teamRankings = [];
        teamsSnapshot.forEach((doc) => {
          const teamData = doc.data();

          let weeklyScore = 0;
          const members = teamData.members || {};

          // 주간 점수 합산
          Object.keys(members).forEach((userId) => {
            weeklyScore += members[userId].weeklySuccessCount || 0;
          });

          teamRankings.push({
            teamId: doc.id,
            weeklyScore: weeklyScore,
            members: members,
            weeklyFailDays: teamData.weeklyFailDays || {},
            consecutiveGoalWeeks: teamData.consecutiveGoalWeeks || 0,
            weeklyGoalLP: teamData.weeklyGoalLP || 5000,
            achievements: teamData.achievements || {},
          });
        });

        // 점수 기준 정렬
        teamRankings.sort((a, b) => b.weeklyScore - a.weeklyScore);


        // 보상 지급
        const BATCH_SIZE = 500;
        let rankingBatch = db.batch();
        let batchCount = 0;

        const ACHIEV_RANKING_ID = "perfectMorning";
        const ACHIEV_RANKING_REWARD_LP = 1000;
        const RANK_TARGET = 3;

        const ACHIEV_GAP_ID = "dominantVictory";
        const ACHIEV_GAP_REWARD_LP = 1500;
        const GAP_TARGET = 2000;

        const ACHIEV_CRISIS_ID = "escapedCrisis";
        const ACHIEV_CRISIS_REWARD_LP = 200;
        const FAIL_DAY_LIMIT = 3;

        const ACHIEV_VANGUARD_ID = "dawnVanguard";
        const ACHIEV_VANGUARD_REWARD_TEAM_LP = 300;
        const ACHIEV_VANGUARD_REWARD_INDIVIDUAL_LP = 500;
        const VANGUARD_SUCCESS_TARGET = 4;

        const ACHIEV_TEAMWORK_ID = "teamworkExpert";
        const ACHIEV_TEAMWORK_REWARD_LP = 2000;
        const TEAMWORK_TARGET_WEEKS = 4;

        if (teamRankings.length >= 2) {
          const firstPlace = teamRankings[0];
          const secondPlace = teamRankings[1];
          const scoreDifference = firstPlace.weeklyScore - secondPlace.weeklyScore;

          if (scoreDifference >= GAP_TARGET && firstPlace.weeklyScore > 0) {
            const ACHIEV_REWARD = ACHIEV_GAP_REWARD_LP;
            const teamRef = db.collection("teams").doc(firstPlace.teamId);

            rankingBatch.update(teamRef, {
              teamLP: admin.firestore.FieldValue.increment(ACHIEV_REWARD),
              [`weeklyRanking.achievements.${ACHIEV_GAP_ID}`]:
                admin.firestore.FieldValue.serverTimestamp(),
            });
            batchCount++;

            for (const memberId of Object.keys(firstPlace.members)) {
              const userRef = db.collection("users").doc(memberId);
              rankingBatch.update(userRef, {
                userLP: admin.firestore.FieldValue.increment(ACHIEV_REWARD),
              });
              batchCount++;
            }
            logger.log(`[${ACHIEV_GAP_ID}] 팀 ${firstPlace.teamId} 업적 달성!`);
          }
        }


        // 개별 팀 업적
        for (let i = 0; i < teamRankings.length; i++) {
          const rank = i + 1;
          const team = teamRankings[i];
          const teamRef = db.collection("teams").doc(team.teamId);
          const teamUpdates = {};

          // 지난 주 랭킹 기록 update
          teamUpdates["weeklyRanking.lastRank"] = rank;
          teamUpdates["weeklyRanking.lastScore"] = team.weeklyScore;


          // 팀워크 전문가
          const isGoalAchieved = team.weeklyScore >= team.weeklyGoalLP;
          const currentConsecutiveWeeks = team.consecutiveGoalWeeks;
          let newConsecutiveWeeks;

          if (isGoalAchieved) {
            newConsecutiveWeeks = currentConsecutiveWeeks + 1;

            if (
              newConsecutiveWeeks >= TEAMWORK_TARGET_WEEKS &&
              !team.achievements[ACHIEV_TEAMWORK_ID]
            ) {
              const ACHIEV_REWARD = ACHIEV_TEAMWORK_REWARD_LP;

              // 팀 LP +
              teamUpdates.teamLP =
                admin.firestore.FieldValue.increment(ACHIEV_REWARD);

              // 업적 달성 기록
              teamUpdates[`achievements.${ACHIEV_TEAMWORK_ID}`] =
                admin.firestore.FieldValue.serverTimestamp();

              // 개인 LP +
              for (const memberId of Object.keys(team.members)) {
                const userRef = db.collection("users").doc(memberId);
                rankingBatch.update(userRef, {
                  userLP: admin.firestore.FieldValue.increment(ACHIEV_REWARD),
                });
                batchCount++;
              }
              logger.log(`[${ACHIEV_TEAMWORK_ID}] 팀 ${team.teamId} 업적 달성!`);
            }
          } else {
            // 실패 시 연속 기록 초기화
            newConsecutiveWeeks = 0;
          }

          teamUpdates.consecutiveGoalWeeks = newConsecutiveWeeks;


          // 퍼펙트 모닝
          if (rank <= RANK_TARGET && team.weeklyScore > 0) {
            const ACHIEV_REWARD = ACHIEV_RANKING_REWARD_LP;
            teamUpdates.teamLP =
              admin.firestore.FieldValue.increment(ACHIEV_REWARD);
            teamUpdates[`weeklyRanking.achievements.${ACHIEV_RANKING_ID}`] =
              admin.firestore.FieldValue.serverTimestamp();

            for (const memberId of Object.keys(team.members)) {
              const userRef = db.collection("users").doc(memberId);
              rankingBatch.update(userRef, {
                userLP: admin.firestore.FieldValue.increment(ACHIEV_REWARD),
              });
              batchCount++;
            }
            logger.log(`[${ACHIEV_RANKING_ID}] 팀 ${team.teamId} 업적 달성.`);
          }

          // 위기 탈출 No.1
          const weeklyFailDaysCount = Object.keys(team.weeklyFailDays).length;

          if (
            weeklyFailDaysCount < FAIL_DAY_LIMIT &&
            Object.keys(team.members).length > 0
          ) {
            const ACHIEV_REWARD = ACHIEV_CRISIS_REWARD_LP;

            teamUpdates.teamLP =
              admin.firestore.FieldValue.increment(ACHIEV_REWARD);
            teamUpdates[`weeklyRanking.achievements.${ACHIEV_CRISIS_ID}`] =
              admin.firestore.FieldValue.serverTimestamp();

            for (const memberId of Object.keys(team.members)) {
              const userRef = db.collection("users").doc(memberId);
              rankingBatch.update(userRef, {
                userLP: admin.firestore.FieldValue.increment(ACHIEV_REWARD),
              });
              batchCount++;
            }
            logger.log(`[${ACHIEV_CRISIS_ID}] 팀 ${team.teamId} 업적 달성. 주간 실패일 ${weeklyFailDaysCount}일.`);
          }

          // 새벽의 선봉대
          let maxSuccessCount = 0;
          let topPerformers = [];

          for (const memberId of Object.keys(team.members)) {
            const count = team.members[memberId].weeklySuccessCount || 0;

            if (count > maxSuccessCount) {
              maxSuccessCount = count;
              topPerformers = [memberId];
            } else if (count === maxSuccessCount && count > 0) {
              topPerformers.push(memberId);
            }
          }

          if (maxSuccessCount >= VANGUARD_SUCCESS_TARGET) {
            const ACHIEV_REWARD_TEAM = ACHIEV_VANGUARD_REWARD_TEAM_LP;
            const ACHIEV_REWARD_INDIVIDUAL = ACHIEV_VANGUARD_REWARD_INDIVIDUAL_LP;

            teamUpdates.teamLP =
              admin.firestore.FieldValue.increment(ACHIEV_REWARD_TEAM);
            teamUpdates[`weeklyRanking.achievements.${ACHIEV_VANGUARD_ID}`] =
              admin.firestore.FieldValue.serverTimestamp();

            // 팀 LP +
            for (const memberId of Object.keys(team.members)) {
              const userRef = db.collection("users").doc(memberId);
              rankingBatch.update(userRef, {
                userLP:
                    admin.firestore.FieldValue.increment(ACHIEV_REWARD_TEAM),
              });
              batchCount++;
            }

            // 개인 LP +
            for (const memberId of topPerformers) {
              const userRef = db.collection("users").doc(memberId);
              rankingBatch.update(userRef, {
                userLP:
                  admin.firestore.FieldValue.increment(ACHIEV_REWARD_INDIVIDUAL),
              });
              batchCount++;
            }
            logger.log(`[${ACHIEV_VANGUARD_ID}] 팀 ${team.teamId} 업적 달성. Max Success: ${maxSuccessCount}일.`);
          }

          rankingBatch.update(teamRef, teamUpdates);
          batchCount++;

          if (batchCount >= BATCH_SIZE) {
            await rankingBatch.commit();
            rankingBatch = db.batch();
            batchCount = 0;
          }
        }

        await rankingBatch.commit();


        // 주간 통계 & 주간 업적 기록 reset
        const resetBatch = db.batch();
        teamsSnapshot.forEach((teamDoc) => {
          const teamRef = teamDoc.ref;
          const members = teamDoc.data().members || {};

          const teamMemberUpdates = {};
          for (const memberId of Object.keys(members)) {
            teamMemberUpdates[`members.${memberId}.weeklySuccessCount`] = 0;

            const userRef = db.collection("users").doc(memberId);
            resetBatch.update(userRef, {weeklySuccessCount: 0});
          }

          if (Object.keys(teamMemberUpdates).length > 0) {
            resetBatch.update(teamRef, teamMemberUpdates);
          }
          
          resetBatch.update(teamRef, {
            "weeklyRanking.achievements.perfectMorning":
              admin.firestore.FieldValue.delete(),
            "weeklyRanking.achievements.dominantVictory":
              admin.firestore.FieldValue.delete(),
            "weeklyRanking.achievements.escapedCrisis":
              admin.firestore.FieldValue.delete(),
            "weeklyRanking.achievements.dawnVanguard":
              admin.firestore.FieldValue.delete(),
            "weeklyFailDays": {},
          });
        });
        await resetBatch.commit();

        logger.log("주간 랭킹 및 통계 초기화 완료.");
        return null;
      } catch (error) {
        logger.error("주간 랭킹 및 업적 처리 중 심각한 에러:", error);
        return null;
      }
    });
