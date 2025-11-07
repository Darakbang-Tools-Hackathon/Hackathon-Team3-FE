import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ===============================================
// Riverpod Provider 정의
// ===============================================

// FirebaseFunctions 인스턴스를 직접 주입받는 Provider (테스트 용이)
final firebaseFunctionsProvider = Provider((ref) => FirebaseFunctions.instance);

// TeamService 인스턴스를 제공하는 Provider
// TeamCreateScreen, TeamJoinScreen 등에서 ref.read(teamServiceProvider)로 접근
final teamServiceProvider = Provider<TeamService>((ref) {
  // functions 인스턴스를 주입받아 TeamService를 생성
  final functions = ref.watch(firebaseFunctionsProvider);
  return TeamService(functions);
});

// ===============================================
// TeamService 클래스
// ===============================================

class TeamService {
  // FirebaseFunctions 객체를 내부 필드로 사용
  final FirebaseFunctions _functions;

  TeamService(this._functions);

  /// [API 호출] 새 팀 생성 및 유저를 방장으로 등록합니다.
  /// @param teamName: 생성할 팀 이름
  /// @return Map: { teamId: string, joinCode: string }
  Future<Map<String, dynamic>> createTeam(String teamName) async {
    try {
      final result = await _functions.call(
        "createTeam", // 백엔드 함수 이름
        {
          "teamName": teamName, // 요청 본문 (Body)
        },
      );

      // 응답 데이터 사용: teamId와 joinCode를 프론트엔드에 반환
      final data = result.data as Map<String, dynamic>;

      // 💡 [참고] 프론트엔드에서는 여기서 받은 data['joinCode']를
      //    TeamCreateScreen의 바텀 시트에 표시해야 합니다.
      return data;

    } on FirebaseFunctionsException catch (e) {
      // 백엔드 HttpsError 처리
      throw Exception(e.message ?? "팀 생성 중 알 수 없는 오류 발생");
    }
  }

  /// [API 호출] 팀 코드를 사용하여 팀에 참가합니다.
  /// @param joinCode: 4자리 팀 참여 코드
  Future<void> joinTeam(String joinCode) async {
    try {
      await _functions.call(
        "joinTeam", // 백엔드 함수 이름
        {
          "joinCode": joinCode.toUpperCase(), // 요청 본문 (코드 전달)
        },
      );

      // 성공적으로 참가하면 void를 반환

    } on FirebaseFunctionsException catch (e) {
      // 백엔드 HttpsError 처리 (예: 이미 팀에 속해 있음, 코드가 유효하지 않음)
      throw Exception(e.message ?? "팀 참여 중 알 수 없는 오류 발생");
    }
  }

  // --- 추가될 수 있는 API ---

  /// [API 호출] 현재 유저가 속한 팀의 대시보드 정보를 조회합니다.
  Future<Map<String, dynamic>> getTeamDashboard() async {
    try {
      final result = await _functions.call("getTeamDashboard", {});
      return result.data as Map<String, dynamic>;
    } on FirebaseFunctionsException {
      rethrow;
    }
  }
}