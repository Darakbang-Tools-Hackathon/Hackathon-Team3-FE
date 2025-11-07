class AppUser {
  const AppUser({
    required this.id,
    required this.displayName,
    required this.lp,
    required this.wakeUpTime,
    this.teamId,
    this.lastChallengeStatus,
    this.weeklySuccessCount,
  });

  final String id;
  final String displayName;
  final int lp;
  final String wakeUpTime;
  final String? teamId;
  final String? lastChallengeStatus;
  final int? weeklySuccessCount;

  AppUser copyWith({
    String? id,
    String? displayName,
    int? lp,
    String? wakeUpTime,
    String? teamId,
    String? lastChallengeStatus,
    int? weeklySuccessCount,
  }) {
    return AppUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      lp: lp ?? this.lp,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      teamId: teamId ?? this.teamId,
      lastChallengeStatus: lastChallengeStatus ?? this.lastChallengeStatus,
      weeklySuccessCount: weeklySuccessCount ?? this.weeklySuccessCount,
    );
  }
}

