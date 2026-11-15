import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bubble_file_manager/main.dart';
import 'package:bubble_file_manager/ai_assistant.dart';
import 'package:bubble_file_manager/home_companions.dart';

void main() {
  testWidgets('Bubble File Manager shows splash and opens the Assistant from Home', (tester) async {
    await tester.pumpWidget(const AquaApp());

    await tester.pump();
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('සිංහල'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pump();
    expect(find.text('BUBBLE'), findsOneWidget);
    expect(find.text('FILE MANAGER'), findsOneWidget);
    expect(find.text('Safety and Relax File Management System'), findsOneWidget);
    expect(find.text('Created by H.G.Aluthge'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 3300));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('My Files'), findsOneWidget);
    expect(find.text('HASARU & YUNADIE'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Categories'),
      250,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey<String>('homeList')),
        matching: find.byType(Scrollable),
      ).first,
    );
    expect(find.text('Categories'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('AI Assistant'),
      250,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey<String>('homeList')),
        matching: find.byType(Scrollable),
      ).first,
    );
    await tester.tap(find.text('AI Assistant'));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Aqua Assistant'), findsOneWidget);
    expect(find.text('Offline guidance'), findsOneWidget);
  });


  testWidgets('Hasaru and Yunadie type messages and offer working feature options', (tester) async {
    String? selectedAction;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(children: <Widget>[
          HomeCompanionsPanel(
            accent: const Color(0xFF20E4E8),
            isSinhala: false,
            onAction: (action) => selectedAction = action,
          ),
        ]),
      ),
    ));

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Browse files'), findsOneWidget);
    expect(find.text('Photos & videos'), findsOneWidget);

    await tester.tap(find.text('Special features'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Yunadie'), findsNWidgets(2));
    expect(find.text('Secret Vault'), findsOneWidget);
    expect(find.text('Face Albums'), findsOneWidget);

    await tester.tap(find.text('Secret Vault'));
    expect(selectedAction, 'vault');
  });

  testWidgets('Hasaru and Yunadie speak Sinhala when Sinhala is selected', (tester) async {
    String? selectedAction;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ListView(children: <Widget>[
        HomeCompanionsPanel(
          accent: const Color(0xFF20E4E8),
          isSinhala: true,
          onAction: (action) => selectedAction = action,
        ),
      ])),
    ));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('ගොනු පිරික්සන්න'), findsOneWidget);
    expect(find.text('ඡායාරූප සහ වීඩියෝ'), findsOneWidget);
    await tester.tap(find.text('විශේෂාංග'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('රහස් සුරක්ෂිතාගාරය'), findsOneWidget);
    expect(find.text('මුහුණු ඇල්බම'), findsOneWidget);
    await tester.tap(find.text('රහස් සුරක්ෂිතාගාරය'));
    expect(selectedAction, 'vault');
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
