const {db, logger} = require("../common");
const {auth} = require("firebase-functions/v1");
const admin = require("firebase-admin");

if (!admin.apps.length) {
  admin.initializeApp();
}

// 신규 유저
exports.createUserDocument = auth.user().onCreate(async (user) => {
  const userRef = db.collection("users").doc(user.uid);

  logger.log(`Creating user document for: ${user.uid}, email: ${user.email}`);

  try {
    await userRef.set({
      email: user.email || null,
      displayName: user.displayName || "신규 유저",
      userLP: 0,
      wakeUpTime: null,
      teamIds: [],
      leaderOf: [],
      lastChallengeStatus: "pending",
      weeklySuccessCount: 0,
      fcmToken: null,
      currentMissionId: null,
      totalSuccessCount: 0,
      totalFailCount: 0,
      createAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    logger.log(`Successfully created user document for: ${user.uid}`);
    return;
  } catch (error) {
    logger.error(`Error creating user document for ${user.uid}:`, error);
    return;
  }
});

// 유저 탈퇴
exports.deleteUserDocument = auth.user().onDelete(async (user) => {
  const userRef = db.collection("users").doc(user.uid);

  logger.log(`Deleting user document for: ${user.uid}`);

  try {
    await userRef.delete();
    logger.log(`Successfully deleted user document for: ${user.uid}`);
    return;
  } catch (error) {
    logger.error(`Error deleting user document for ${user.uid}:`, error);
    return;
  }
});
