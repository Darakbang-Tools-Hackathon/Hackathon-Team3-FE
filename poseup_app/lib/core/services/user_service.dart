import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_user.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

class UserService {
  // 회원가입 예시
  Future<void> signUp(String email, String password) async {
    // 실제 URL과 파라미터에 맞도록 수정해서 사용
    final url = Uri.parse('https://createuserdocument-i3lpaiubpq-uc.a.run.app');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  // 로그인 예시
  Future<void> login(String email, String password) async {
    final url = Uri.parse('https://userlogin-i3lpaiubpq-uc.a.run.app');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  Future<AppUser> fetchCurrentUser() async {
    // TODO: Firebase Auth + Firestore 프로필 조회 (연동시 필요)
    return const AppUser(
      id: 'stub-user',
      displayName: '김포즈',
      lp: 1840,
      wakeUpTime: '07:15',
    );
  }
}

