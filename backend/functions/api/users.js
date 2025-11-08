const {db, onCall, HttpsError, logger} = require("../common");


exports.setUserAlarm = onCall(async (request) => {
  // 로그인 확인
  if (!request.auth) {
    logger.warn("setUserAlarm: Unauthenticated user.");
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }

  const userId = request.auth.uid;
  const wakeUpTime = request.data.wakeUpTime; // 알람 시간 수신

  if (!wakeUpTime) {
    logger.warn(`setUserAlarm: Missing wakeUpTime for user ${userId}`);
    throw new HttpsError("invalid-argument", "wakeUpTime 값이 없습니다.");
  }

  const userRef = db.collection("users").doc(userId);

  try {
    // /users: wakeUpTime 필드 update
    await userRef.update({
      wakeUpTime: wakeUpTime,
    });

    logger.log(`User ${userId} set alarm to ${wakeUpTime}`);
    return {success: true, wakeUpTime: wakeUpTime};
  } catch (error) {
    logger.error(`Error setting alarm for user ${userId}:`, error);
    throw new HttpsError("internal", "알람 설정 중 오류가 발생했습니다.");
  }
});


/**
 * FCM 기기 토큰 등록

 * @param {object} data - { token: string }
 * @param {object} context
 * @return {Promise<object>} - { status: "success" }
 */

exports.registerDeviceToken = onCall(async (request) => {
  // 로그인 확인
  if (!request.auth) {
    logger.warn("registerDeviceToken: Unauthenticated user.");
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }

  const userId = request.auth.uid;
  const fcmToken = request.data.fcmToken;

  if (!fcmToken) {
    logger.warn(`registerDeviceToken: Missing fcmToken for user ${userId}`);
    throw new HttpsError("invalid-argument", "fcmToken 값이 없습니다.");
  }

  const userRef = db.collection("users").doc(userId);

  try {
    // /users: fcmToken 필드 update
    await userRef.update({
      fcmToken: fcmToken,
    });

    logger.log(`User ${userId} registered FCM token: ${fcmToken}`);
    return {success: true};
  } catch (error) {
    logger.error(`Error registering FCM token for user ${userId}:`, error);
    throw new HttpsError("internal", "토큰 등록 중 오류가 발생했습니다.");
  }
});
