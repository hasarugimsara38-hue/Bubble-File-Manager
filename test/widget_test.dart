import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bubble_file_manager/main.dart';
import 'package:bubble_file_manager/ai_assistant.dart';
import 'package:bubble_file_manager/home_companions.dart';
import 'package:bubble_file_manager/app_language.dart';

void main() {
  testWidgets('Bubble File Manager shows splash and opens the Assistant from Home', (tester) async {
    // Use the deterministic language override here. The first-run language
    // selection itself is verified in a separate widget test below.
    await tester.pumpWidget(const AquaApp(initialLanguage: 'en'));

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

    final assistantShortcut =
        find.byKey(const ValueKey<String>('homeAiAssistantShortcut'));
    await tester.scrollUntilVisible(
      assistantShortcut,
      250,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey<String>('homeList')),
        matching: find.byType(Scrollable),
      ).first,
    );
    expect(assistantShortcut, findsOneWidget);
    await tester.ensureVisible(assistantShortcut);
    await tester.pump();
    await tester.tap(assistantShortcut);
    // Allow the MaterialPageRoute transition to complete deterministically.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.byType(AquaAiAssistantPage), findsOneWidget);
    expect(find.text('Aqua Assistant'), findsOneWidget);
    expect(find.textContaining('Detailed offline help for app features'), findsOneWidget);
    expect(find.textContaining('Live ChatGPT-style AI is not connected'), findsOneWidget);
  });


  testWidgets('First-run language selector offers Sinhala and English', (tester) async {
    String? selectedLanguage;
    await tester.pumpWidget(MaterialApp(
      home: LanguageSelectionScreen(
        onSelected: (language) => selectedLanguage = language,
      ),
    ));

    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('සිංහල'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('සිංහල'));
    expect(selectedLanguage, 'si');
    await tester.tap(find.text('English'));
    expect(selectedLanguage, 'en');
  });

  testWidgets('Language picker can be opened from a feature screen', (tester) async {
    String? selected;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () async {
                selected = await showAppLanguageDialog(
                  context,
                  accent: const Color(0xFF20E4E8),
                );
              },
              child: const Text('Open language'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Open language'));
    await tester.pumpAndSettle();
    expect(find.text('සිංහල'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('සිංහල'));
    await tester.pumpAndSettle();
    expect(selected, 'si');
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

  testWidgets('Tapping each anime companion starts its own conversation', (tester) async {
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

    await tester.tap(find.bySemanticsLabel('Talk to Yunadie'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Yunadie'), findsWidgets);
    expect(find.text('Photos'), findsOneWidget);
    await tester.tap(find.text('Face Albums'));
    expect(selectedAction, 'faces');

    await tester.tap(find.bySemanticsLabel('Talk to Hasaru'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Hasaru'), findsWidgets);
    expect(find.text('Open Files'), findsOneWidget);
    await tester.tap(find.text('Open Files'));
    expect(selectedAction, 'files');
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

    expect(find.textContaining('Detailed offline help for app features'), findsOneWidget);
    await tester.tap(find.text('How do I allow storage access?'));
    await tester.pumpAndSettle();

    expect(find.text('How do I allow storage access?'), findsOneWidget);
    expect(find.textContaining('Allow storage access'), findsOneWidget);
    expect(find.textContaining('Enable “Allow access to manage all files”'), findsOneWidget);
  });
}
