import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_locale.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in ProviderScope');
}

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  static const _prefsKey = 'app_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return Locale(prefs.getString(_prefsKey) ?? 'my');
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(sharedPreferencesProvider).setString(_prefsKey, locale.languageCode);
    state = locale;
  }
}
