import 'package:flutter/material.dart';

class TeamJoinScreen extends StatefulWidget {
  const TeamJoinScreen({super.key});

  static const routePath = '/team/join';

  @override
  State<TeamJoinScreen> createState() => _TeamJoinScreenState();
}

class _TeamJoinScreenState extends State<TeamJoinScreen> {
  final _codeController = TextEditingController(text: 'WAKE123456');

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
                        decoration: InputDecoration(
                          hintText: 'TEAMCODE',
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
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${_codeController.text} 팀에 참여 신청했어요 (스텁)')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: const Color(0xFFF97316),
                  ),
                  child: const Text('팀 참여하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

