import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> registerDeviceToken(String userId, String deviceToken) async {
    final url = Uri.parse('https://registerdevicetoken-i3lpaiubpq-uc.a.run.app');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'deviceToken': deviceToken}),
    );
    if (response.statusCode != 200) {
      throw Exception('디바이스 토큰 등록 실패: ${response.body}');
    }
  }
}

