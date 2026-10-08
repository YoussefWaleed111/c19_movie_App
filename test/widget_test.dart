import 'package:flutter_test/flutter_test.dart';
import 'package:movieapp/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MovieApp());
    expect(find.byType(MovieApp), findsOneWidget);
  });
}
