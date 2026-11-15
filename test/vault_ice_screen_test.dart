import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bubble_file_manager/app_language.dart';
import 'package:bubble_file_manager/vault_ice_screen.dart';

void main() {
  setUp(() {
    AppLanguage.code = 'en';
  });

  testWidgets('Vault opens with the dedicated icy interface and empty state',
      (tester) async {
    var imported = false;

    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => VaultIceScreen(
                      files: const <File>[],
                      onImport: () async {
                        imported = true;
                      },
                      onExport: (_) async {},
                      onChangePassword: () async {},
                      onChangeRecovery: () async {},
                    ),
                  ),
                );
              },
              child: const Text('Open Vault'),
            ),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Open Vault'));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('SECRET VAULT'), findsOneWidget);
    expect(find.text('ICE-CORE SECURITY'), findsOneWidget);
    expect(find.text('AES-256-GCM'), findsOneWidget);
    expect(find.text('Your vault is frozen and empty'), findsOneWidget);

    await tester.tap(find.text('Add a file'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(imported, isTrue);
    expect(find.text('Open Vault'), findsOneWidget);
  });
}
