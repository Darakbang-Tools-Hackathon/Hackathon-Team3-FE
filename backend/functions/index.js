const authTriggers = require("./triggers/auth");
const userApi = require("./api/users");
const challengeApi = require("./api/challenge");
const teamApi = require("./api/teams");
const notificationScheduler = require("./scheduled/notifications");
const dailyReset = require("./scheduled/dailyReset");
const rankingScheduler = require("./scheduled/ranking");

// --- API ---

// teams.js
exports.createTeam = teamApi.createTeam;
exports.joinTeam = teamApi.joinTeam;
exports.getTeamDashboard = teamApi.getTeamDashboard;

// users.js
exports.setUserAlarm = userApi.setUserAlarm;
exports.registerDeviceToken = userApi.registerDeviceToken;

// challenge.js
exports.getTodayMission = challengeApi.getTodayMission;
exports.processChallengeResult = challengeApi.processChallengeResult;

// notifications.js
exports.sendWakeUpNotifications = notificationScheduler.sendWakeUpNotifications;

// auth.js
exports.createUserDocument = authTriggers.createUserDocument;
exports.deleteUserDocument = authTriggers.deleteUserDocument;

// dailyReset.js
exports.dailyResetAndTeamReward = dailyReset.dailyResetAndTeamReward;

// ranking.js
exports.processWeeklyRanking = rankingScheduler.processWeeklyRanking;
