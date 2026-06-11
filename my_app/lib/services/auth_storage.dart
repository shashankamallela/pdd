import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _savedAccountsKey = 'saved_accounts';
  static const String _currentEmailKey = 'current_email';

  static String _profileCreatedKey(String email) {
    return 'profile_created_${email.trim().toLowerCase()}';
  }

  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String trimmedEmail = email.trim();
    final List<Map<String, String>> accounts = await savedAccounts();

    accounts.removeWhere(
      (account) =>
          account['email']?.toLowerCase() == trimmedEmail.toLowerCase(),
    );
    accounts.insert(
      0,
      {
        'email': trimmedEmail,
        'password': password,
      },
    );

    await prefs.setString(_savedAccountsKey, jsonEncode(accounts));
    await prefs.setString(_savedEmailKey, trimmedEmail);
    await prefs.setString(_savedPasswordKey, password);
  }

  static Future<Map<String, String>> savedCredentials() async {
    final accounts = await savedAccounts();

    if (accounts.isNotEmpty) {
      return accounts.first;
    }

    return {
      'email': '',
      'password': '',
    };
  }

  static Future<List<Map<String, String>>> savedAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedAccountsJson = prefs.getString(_savedAccountsKey);

    if (savedAccountsJson != null && savedAccountsJson.isNotEmpty) {
      final decodedAccounts = jsonDecode(savedAccountsJson);

      if (decodedAccounts is List) {
        return decodedAccounts
            .whereType<Map>()
            .map(
              (account) => {
                'email': account['email']?.toString() ?? '',
                'password': account['password']?.toString() ?? '',
              },
            )
            .where((account) => account['email']!.isNotEmpty)
            .toList();
      }
    }

    final String legacyEmail = prefs.getString(_savedEmailKey) ?? '';
    final String legacyPassword = prefs.getString(_savedPasswordKey) ?? '';

    if (legacyEmail.isEmpty || legacyPassword.isEmpty) {
      return [];
    }

    final legacyAccounts = [
      {
        'email': legacyEmail,
        'password': legacyPassword,
      }
    ];
    await prefs.setString(_savedAccountsKey, jsonEncode(legacyAccounts));

    return legacyAccounts;
  }

  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedAccountsKey);
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
  }

  static Future<void> removeSavedCredential(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final String trimmedEmail = email.trim();
    final List<Map<String, String>> accounts = await savedAccounts();

    accounts.removeWhere(
      (account) =>
          account['email']?.toLowerCase() == trimmedEmail.toLowerCase(),
    );

    await prefs.setString(_savedAccountsKey, jsonEncode(accounts));

    if (accounts.isEmpty) {
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
      return;
    }

    await prefs.setString(_savedEmailKey, accounts.first['email'] ?? '');
    await prefs.setString(_savedPasswordKey, accounts.first['password'] ?? '');
  }

  static Future<void> setCurrentEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentEmailKey, email.trim());
  }

  static Future<String> currentEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentEmailKey) ?? '';
  }

  static Future<bool> hasProfile(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileCreatedKey(email)) ?? false;
  }

  static Future<void> markProfileCreated(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileCreatedKey(email), true);
  }
}
