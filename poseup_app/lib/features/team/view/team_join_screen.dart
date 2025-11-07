import 'package:flutter/material.dart';
// 💡 Riverpod 사용을 위한 패키지 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 💡 TeamService 경로를 가정하고 추가 (실제 경로에 맞게 수정 필요)
import '../../../core/services/team_service.dart';

// 💡 Riverpod의 ConsumerStatefulWidget으로 변경
class TeamJoinScreen extends ConsumerStatefulWidget {
  const TeamJoinScreen({super.key});

  static const routePath = '/team/join';

  @override
  // 💡 ConsumerState로 변경
  ConsumerState<TeamJoinScreen> createState() => _TeamJoinScreenState();
}

// 💡 ConsumerState로 변경
class _TeamJoinScreenState extends ConsumerState<TeamJoinScreen> {
  final _codeController = TextEditingController(text: ''); // 테스트 코드는 비워둡니다.
  // 💡 로딩 및 에러 상태 추가
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // 💡 API 호출 핸들러 함수 추가
  Future<void> _handleJoinTeam() async {
    final joinCode = _codeController.text.trim().toUpperCase();

    // 1. 클라이언트 측 유효성 검사 (4자리 코드 확인)
    if (joinCode.isEmpty || joinCode.length != 4) { // 백엔드 설계에 따라 4자리 검증
      setState(() {
        _error = '유효한 4자리 팀 코드를 입력해주세요.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 2. 백엔드 API 호출: teamServiceProvider를 통해 joinTeam 함수 호출
      // teamServiceProvider는 프론트엔드에서 정의해야 합니다.
      await ref.read(teamServiceProvider).joinTeam(joinCode);

      // 3. 성공 처리: 성공 모달 팝업 또는 대시보드 화면으로 이동
      if (mounted) {
        // 성공 시 간단한 스낵바 대신, 팀 대시보드로 이동하거나 팝업을 띄울 수 있습니다.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('팀에 성공적으로 합류했습니다!')),
        );
        // Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false); // 예시
        Navigator.of(context).pop(); // 일단 현재 화면 닫기
      }

    } catch (e) {
      // 4. 에러 처리: 백엔드에서 던진 HttpsError 포함
      setState(() {
        // HttpsError의 e.message를 사용하거나, 일반 에러 메시지를 표시
        _error = e.toString().contains('HttpsError')
            ? '참가 실패: 코드가 유효하지 않거나 이미 팀에 속해 있습니다.'
            : '알 수 없는 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Text('팀 참여하기', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFFFFF4D7),
                        child: Icon(Icons.group_add, color: Colors.orange.shade500, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text('친구에게 받은 팀 코드를 입력해주세요',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600, color: Colors.orange)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 4, // 💡 4자리 코드로 제한
                        decoration: InputDecoration(
                          hintText: 'ABCD', // 💡 4자리 예시로 변경
                          filled: true,
                          fillColor: const Color(0xFFFFFBEB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('팀장에게 코드를 받아 입력해주세요',
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('참여 전 확인하세요', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 12),
                    _JoinGuideBullet(text: '한 번에 하나의 팀에만 참여할 수 있어요'),
                    _JoinGuideBullet(text: '팀을 떠나면 7일 후 다른 팀에 들어갈 수 있어요'),
                    _JoinGuideBullet(text: '팀 활동은 즉시 시작됩니다'),
                  ],
                ),
              ),
              // 💡 에러 메시지 표시
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // 💡 API 호출 함수 연결 및 로딩 중 비활성화
                  onPressed: _loading ? null : _handleJoinTeam,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: const Color(0xFFF97316),
                  ),
                  child: _loading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                      : const Text('팀 참여하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinGuideBullet extends StatelessWidget {
  const _JoinGuideBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Color(0xFFF97316)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}