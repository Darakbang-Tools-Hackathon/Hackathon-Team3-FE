import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final alarmServiceProvider = Provider<AlarmService>((ref) {
  return AlarmService();
});

class AlarmService {
  Future<void> setUserAlarm(String userId, String time) async {
    final url = Uri.parse('https://setuseralarm-i3lpaiubpq-uc.a.run.app');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'time': time}),
    );
    if (response.statusCode != 200) {
      throw Exception('알람 등록 실패: ${response.body}');
    }
  }
}

