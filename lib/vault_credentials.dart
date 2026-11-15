import 'dart:convert';

import 'package:crypto/crypto.dart';

/// The exact digest/normalisation rules used by Secret Vault credentials.
/// This class contains no storage access and cannot unlock the Vault by itself.
class VaultCredentials {
  VaultCredentials._();

  static String normalizeRecoveryAnswer(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\\s+'), ' ');

  static String digest(String salt, String value) =>
      sha256.convert(utf8.encode('$salt:$value')).toString();

  static bool verifyPassword({
    required String password,
    required String salt,
    required String expectedDigest,
  }) =>
      digest(salt, password) == expectedDigest;

  static bool verifyRecoveryAnswer({
    required String answer,
    required String salt,
    required String expectedDigest,
  }) =>
      digest(salt, normalizeRecoveryAnswer(answer)) == expectedDigest;
}
