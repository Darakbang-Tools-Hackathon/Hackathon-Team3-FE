const {db, logger, onSchedule} = require("../common");
const admin = require("firebase-admin");

/**
 * [스케줄러]
 * 1분마다 실행되며, 현재 KST 시간에 알람이 설정된 유저에게
 * 푸시 알림(FCM)을 발송합니다.
 */
exports.sendWakeUpNotifications = onSchedule(
    {
      schedule: "every 1 minutes", // 1분마다 실행
      timeZone: "Asia/Seoul", // KST 기준
    },
    async (_context) => {
    // 현재 KST 시간 (format: "HH:mm")
      const now = new Date();
      const hours = now.getHours().toString().padStart(2, "0");
      const minutes = now.getMinutes().toString().padStart(2, "0");
      const currentTimeKST = `${hours}:${minutes}`; // 예: "07:15"

      logger.log(`[${currentTimeKST} KST] scheduler 실행.`);

      try {
      // /users에서 currentTimeKST = wakeUpTime 조회
        const usersRef = db.collection("users");
        const snapshot = await usersRef
            .where("wakeUpTime", "==", currentTimeKST)
            .get();

        if (snapshot.empty) {
          logger.log("알림 보낼 유저가 없습니다.");
          return null;
        }

        const tokenDataList = []; // { userId, token }의 배열
        snapshot.forEach((doc) => {
          const user = doc.data();
          if (user.fcmToken) {
            tokenDataList.push({userId: doc.id, token: user.fcmToken});
          }
        });

        if (tokenDataList.length === 0) {
          logger.log("유저들은 있지만, fcmToken이 등록된 유저가 없습니다.");
          return null;
        }

        // FCM 페이로드(알림 내용)
        const tokens = tokenDataList.map((data) => data.token);
        const message = {
          notification: {
            title: "일어날 시간이에요! ☀️",
            body: "오늘의 기상 포즈에 도전할 시간입니다! (5분 제한)",
          },
          data: {
            type: "WAKE_UP_CHALLENGE",
          },
          tokens: tokens,
        };

        const response = await admin.messaging().sendEachForMulticast(message);
        logger.log(`[${currentTimeKST}]`);
        logger.log(`${response.successCount}/${tokens.length} success.`);

        const userRefsToUpdate = [];

        response.results.forEach((result, index) => {
          const error = result.error;
          if (error) {
            const failedTokenData = tokenDataList[index]; // { userId, token }
            logger.error(
                "알림 발송 실패 토큰:",
                failedTokenData.token,
                error.code,
            );

            // 유효하지 않은 토큰
            if (
              error.code === "messaging/invalid-argument" ||
            error.code === "messaging/registration-token-not-registered"
            ) {
              const userId = failedTokenData.userId;
              const userRef = db.collection("users").doc(userId);
              userRefsToUpdate.push(userRef);
            }
          }
        });

        if (userRefsToUpdate.length > 0) {
          logger.log(`${userRefsToUpdate.length}개의 유효하지 않은 토큰을 삭제합니다.`);
          const batch = db.batch();
          userRefsToUpdate.forEach((userRef) => {
            batch.update(userRef, {
              fcmToken: admin.firestore.FieldValue.delete(), // fcmToken 필드 삭제
            });
          });
          await batch.commit();
        }

        return null;
      } catch (error) {
        logger.error("error:", error);
        return null;
      }
    },
);
