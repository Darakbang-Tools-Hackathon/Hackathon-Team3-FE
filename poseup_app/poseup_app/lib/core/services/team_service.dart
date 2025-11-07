import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamServiceProvider = Provider<TeamService>((ref) {
  return TeamService();
});

class TeamService {
  Future<void> createTeam(String teamName) async {
    // TODO: POST /teams 연동
  }

  Future<void> joinTeam(String joinCode) async {
    // TODO: POST /teams/join 연동
  }

  Future<void> refreshTeamDashboard() async {
    // TODO: GET /teams/{teamId} 연동
  }
}

