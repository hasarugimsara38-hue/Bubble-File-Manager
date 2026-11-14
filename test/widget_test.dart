import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bubble_file_manager/main.dart';
import 'package:bubble_file_manager/ai_assistant.dart';

void main() {
  testWidgets('Bubble File Manager shows splash and opens the Assistant from Home', (tester) async {
    await tester.pumpWidget(const AquaApp());

    expect(find.text('BUBBLE'), findsOneWidget);
    expect(find.text('FILE MANAGER'), findsOneWidget);
    expect(find.text('Safety and Relax File Management System'), findsOneWidget);
    expect(find.text('Created by H.G.Aluthge'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pump();

    expect(find.text('My Files'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);

    await tester.ensureVisible(find.text('AI Assistant'));
    await tester.tap(find.text('AI Assistant'));
    await tester.pumpAndSettle();
    expect(find.text('Aqua Assistant'), findsOneWidget);
    expect(find.text('Offline guidance'), findsOneWidget);
  });

  testWidgets('Aqua Assistant responds to a help question', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData.dark(),
      home: const AquaAiAssistantPage(accent: Color(0xFF20E4E8)),
    ));

    await tester.tap(find.text('How do I allow storage access?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('All files access settings page'), findsOneWidget);
  });
}
