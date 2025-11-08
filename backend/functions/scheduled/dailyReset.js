const admin = require("firebase-admin");
const {db, onSchedule} = require("../common");

if (!admin.apps.length) admin.initializeApp();

const TEAM_REWARD_PER_SUCCESS = 5; // 팀원 1명 성공당 팀 LP 보상

const MISSIONS_POOL = [
  {id: "pose-tree", name: "나무 자세", description: "기상 후 10초간 나무 자세"},
  {id: "pose-t-pose", name: "T 포즈", description: "양팔을 벌리고 10초 유지"},
  {id: "pose-squat", name: "스쿼트", description: "스쿼트 5회"},
  {id: "pose-victory", name: "V 포즈", description: "양팔로 V 만들고 10초"},
];

/**
 * KST 기준 현재가 월요일인지 판정합니다.
 * @return {boolean} 월요일이면 true, 아니면 false
 */
function isKSTMonday() {
  const now = new Date();
  const kst = new Date(now.getTime() + 9 * 60 * 60 * 1000);
  return kst.getUTCDay() === 1;
}

/** 오늘의 미션 갱신 */
async function writeTodayMission() {
  const random = MISSIONS_POOL[Math.floor(
      Math.random() * MISSIONS_POOL.length)];
  await db.doc("missions/today").set({
    ...random,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

/**
 * @param {Array<{
 *   ref: FirebaseFirestore.DocumentReference,
 *   data: Object
 * }>} writes - 업데이트할 문서 참조 & 데이터 배열
 * @return {Promise<void>}
 */
async function commitBatches(writes) {
  const chunks = [];
  for (let i = 0; i < writes.length; i += 450) {
    chunks.push(writes.slice(i, i + 450));
  }

  for (const chunk of chunks) {
    const batch = db.batch();
    chunk.forEach(({ref, data}) => batch.update(ref, data));
    await batch.commit();
  }
}

/**
 * 1️. 오늘의 미션 갱신
 * 2️. 팀 보상 (어제 성공률 기반)
 * 3️. 유저 상태 리셋 (월요일: 주간 카운트 초기화)
 */
exports.dailyResetAndTeamReward = onSchedule(
    {
      schedule: "0 0 * * *", // 매일 자정
      timeZone: "Asia/Seoul",
    },
    async (_context) => {
      await writeTodayMission();

      const usersSnap = await db.collection("users").get();
      const userStatus = new Map();

      usersSnap.forEach((doc) => {
        const data = doc.data() || {};
        userStatus.set(doc.id, data.lastChallengeStatus || "pending");
      });

      // 팀 보상 계산
      const teamSnap = await db.collection("teams").get();
      const teamBatchWrites = [];

      teamSnap.forEach((doc) => {
        const data = doc.data() || {};
        const members = data.members || {};
        const memberIds = Object.keys(members);
        if (memberIds.length === 0) return;

        let successCount = 0;
        memberIds.forEach((uid) => {
          if (userStatus.get(uid) === "success") successCount += 1;
        });

        const reward = successCount * TEAM_REWARD_PER_SUCCESS;
        if (reward > 0) {
          teamBatchWrites.push({
            ref: doc.ref,
            data: {teamLP: admin.firestore.FieldValue.increment(reward)},
          });
        }
      });

      if (teamBatchWrites.length > 0) {
        await commitBatches(teamBatchWrites);
      }

      // 유저 리셋
      const monday = isKSTMonday();
      const userBatchWrites = [];

      usersSnap.forEach((doc) => {
        const data = {lastChallengeStatus: "pending"};
        if (monday) data.weeklySuccessCount = 0;
        userBatchWrites.push({ref: doc.ref, data});
      });

      if (userBatchWrites.length > 0) {
        await commitBatches(userBatchWrites);
      }

      return null;
    },
);
