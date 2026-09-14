import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('TaskFlowApp smoke test loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskFlowApp());
    expect(find.text('Workspace'), findsOneWidget);
  });
}
