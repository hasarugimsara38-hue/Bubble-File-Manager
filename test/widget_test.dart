import 'package:flutter_test/flutter_test.dart';
import 'package:bubble_file_manager/main.dart';
import 'package:bubble_file_manager/ai_assistant.dart';

void main() {
  testWidgets('Bubble File Manager shows splash then opens My Files home', (tester) async {
    await tester.pumpWidget(const AquaApp());

    expect(find.text('BUBBLE'), findsOneWidget);
    expect(find.text('FILE MANAGER'), findsOneWidget);
    expect(find.text('Safety and Relax File Management System'), findsOneWidget);
    expect(find.text('Created by H.G.Aluthge'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pump();

    expect(find.text('My Files'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
  });
}


testWidgets('Aqua Assistant opens and responds to a help question', (tester) async {
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData.dark(),
    home: const AquaAiAssistantPage(accent: Color(0xFF20E4E8)),
  ));

  expect(find.text('Aqua Assistant'), findsOneWidget);
  expect(find.text('Offline guidance'), findsOneWidget);

  await tester.tap(find.text('How do I allow storage access?'));
  await tester.pumpAndSettle();

  expect(find.textContaining('All files access settings page'), findsOneWidget);
});
