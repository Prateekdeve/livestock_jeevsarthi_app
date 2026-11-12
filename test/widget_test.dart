import 'package:flutter_test/flutter_test.dart';
import 'package:jeevsarthi_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('JeevSarthi welcome screen renders and language changes work',
      (WidgetTester tester) async {
    await tester.pumpWidget(const JeevSarthiApp());
    await tester.pumpAndSettle();

    // Verify JeevSarthi header
    expect(find.text('JeevSarthi'), findsOneWidget);

    // Verify language pills exist
    expect(find.text('मराठी'), findsOneWidget);
    expect(find.text('हिन्दी'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Switch to Hindi
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    // Verify Hindi labels
    expect(find.text('भाषा चुनें'), findsOneWidget);
    expect(find.text('आगे बढ़ें'), findsOneWidget);
    expect(find.text('किसान (Farmer)'), findsOneWidget);

    // Switch to Marathi
    await tester.tap(find.text('मराठी'));
    await tester.pumpAndSettle();

    // Verify Marathi labels
    expect(find.text('भाषा निवडा'), findsOneWidget);
    expect(find.text('पुढे जा'), findsOneWidget);
    expect(find.text('शेतकरी (Farmer)'), findsOneWidget);

    // Switch back to English
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Verify English labels
    expect(find.text('Choose language'), findsOneWidget);
    expect(find.text('Continue as'), findsOneWidget);
    expect(find.text('Farmer'), findsOneWidget);
  });
}
