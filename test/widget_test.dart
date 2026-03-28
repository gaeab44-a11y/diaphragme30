import 'package:flutter_test/flutter_test.dart';
import 'package:diaphragmatix/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiaphragmeApp());
    await tester.pump();
    expect(find.byType(DiaphragmeApp), findsOneWidget);
  });
}
