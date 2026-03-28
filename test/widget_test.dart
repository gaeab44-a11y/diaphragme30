import 'package:flutter_test/flutter_test.dart';
import 'package:diaphragmatix/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DiaphragmatixApp());
    await tester.pump();
    expect(find.byType(DiaphragmatixApp), findsOneWidget);
  });
}
