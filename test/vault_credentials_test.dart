import 'package:flutter_test/flutter_test.dart';
import 'package:bubble_file_manager/vault_credentials.dart';

void main() {
  group('VaultCredentials', () {
    test('verifies the correct password and rejects a different password', () {
      const salt = 'test-password-salt';
      const password = 'sample-password-482';
      final expected = VaultCredentials.digest(salt, password);

      expect(
        VaultCredentials.verifyPassword(
          password: password,
          salt: salt,
          expectedDigest: expected,
        ),
        isTrue,
      );
      expect(
        VaultCredentials.verifyPassword(
          password: 'not-the-password',
          salt: salt,
          expectedDigest: expected,
        ),
        isFalse,
      );
    });

    test('normalizes recovery answers before verification', () {
      const salt = 'test-recovery-salt';
      const savedAnswer = '  Blue   Ocean  ';
      final expected = VaultCredentials.digest(
        salt,
        VaultCredentials.normalizeRecoveryAnswer(savedAnswer),
      );

      expect(
        VaultCredentials.verifyRecoveryAnswer(
          answer: 'blue ocean',
          salt: salt,
          expectedDigest: expected,
        ),
        isTrue,
      );
      expect(
        VaultCredentials.verifyRecoveryAnswer(
          answer: 'green forest',
          salt: salt,
          expectedDigest: expected,
        ),
        isFalse,
      );
    });

    test('different salts produce different credential digests', () {
      const password = 'same-password';
      expect(
        VaultCredentials.digest('first-salt', password),
        isNot(VaultCredentials.digest('second-salt', password)),
      );
    });
  });
}
