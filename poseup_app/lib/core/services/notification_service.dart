import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  Future<void> requestPermission() async {
    // TODO: FCM 권한 요청 및 토큰 등록
  }

  Future<void> handlePayload(Map<String, dynamic> payload) async {
    // TODO: 챌린지 화면 딥링크 처리
  }
}

