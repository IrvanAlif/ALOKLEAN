import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Aloklean app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AlokleanApp());
    expect(find.text('ALOKLEAN'), findsWidgets);
  });
}
