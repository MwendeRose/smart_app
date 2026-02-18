import 'package:flutter_test/flutter_test.dart';
import 'package:smart_app/main.dart';

void main() {
  testWidgets('Maji Smart app launches successfully', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MajiSmartApp());

    // Verify key UI elements are present
    expect(find.text('Maji Smart'), findsOneWidget);
    expect(find.text('Good Afternoon, John Kamau'), findsOneWidget);
    expect(find.text('Borehole System'), findsOneWidget);
  });
}