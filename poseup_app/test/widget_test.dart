
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:poseup_app/app.dart';

void main() {
  testWidgets('앱이 정상적으로 렌더링되는지 확인', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PoseUpApp(),
      ),
    );

    expect(find.text('알람 설정 시작'), findsOneWidget);
  });
}
