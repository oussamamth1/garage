import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
//   ref,
// ) async {
//   return await SharedPreferences.getInstance();
// });

// // StateNotifier for managing locale
// class LocaleNotifier extends StateNotifier<Locale> {
//   final Ref ref;

//   LocaleNotifier(this.ref) : super(const Locale('en')) {
//     _loadLocale();
//   }

//   static const String _localeKey = 'language_code';

//   // Load saved locale from SharedPreferences
//   Future<void> _loadLocale() async {
//     try {
//       // Get the AsyncValue and handle its state
//       final prefsAsync = ref.read(sharedPreferencesProvider);

//       prefsAsync.when(
//         data: (prefs) {
//           final languageCode = prefs.getString(_localeKey);
//           if (languageCode != null && ['en', 'ar'].contains(languageCode)) {
//             state = Locale(languageCode);
//           }
//         },
//         loading: () => debugPrint('Loading SharedPreferences...'),
//         error: (error, stack) => debugPrint('Error loading locale: $error'),
//       );
//     } catch (e) {
//       // If error, keep default locale
//       debugPrint('Error loading locale: $e');
//     }
//   }

//   // Change locale and save to SharedPreferences
//   Future<void> setLocale(Locale locale) async {
//     if (!['en', 'ar'].contains(locale.languageCode)) return;

//     // Update state immediately for better UX
//     state = locale;

//     try {
//       // Get SharedPreferences instance directly
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_localeKey, locale.languageCode);
//       debugPrint('Locale saved: ${locale.languageCode}');
//     } catch (e) {
//       debugPrint('Error saving locale: $e');
//       // State is already updated, so user experience is not affected
//     }
//   }

//   // Toggle between English and Arabic
//   Future<void> toggleLocale() async {
//     final newLocale = state.languageCode == 'en'
//         ? const Locale('ar')
//         : const Locale('en');
//     await setLocale(newLocale);
//   }

//   // Reset to default locale
//   Future<void> resetLocale() async {
//     await setLocale(const Locale('en'));
//   }
// }

// // Provider for LocaleNotifier
// final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
//   return LocaleNotifier(ref);
// });

// // Helper provider to check if current locale is RTL
// final isRTLProvider = Provider<bool>((ref) {
//   final locale = ref.watch(localeProvider);
//   return locale.languageCode == 'ar';
// });

// // Helper provider to get current language name
// final currentLanguageNameProvider = Provider<String>((ref) {
//   final locale = ref.watch(localeProvider);
//   return locale.languageCode == 'en' ? 'English' : 'العربية';
// });

//

// StateNotifier for managing locale
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  static const String _localeKey = 'language_code';

  // Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);
      
      debugPrint('Loading saved language: $languageCode');
      
      if (languageCode != null && ['en', 'ar'].contains(languageCode)) {
        state = Locale(languageCode);
        debugPrint('Locale loaded successfully: $languageCode');
      } else {
        debugPrint('No saved language found, using default: en');
      }
    } catch (e) {
      debugPrint('Error loading locale: $e');
    }
  }

  // Change locale and save to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (!['en', 'ar'].contains(locale.languageCode)) return;

    // Update state immediately for better UX
    state = locale;
    debugPrint('State updated to: ${locale.languageCode}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_localeKey, locale.languageCode);
      
      if (success) {
        debugPrint('Locale saved successfully: ${locale.languageCode}');
        // Verify it was saved
        final saved = prefs.getString(_localeKey);
        debugPrint('Verification - saved value: $saved');
      } else {
        debugPrint('Failed to save locale');
      }
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  // Toggle between English and Arabic
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en' 
        ? const Locale('ar') 
        : const Locale('en');
    await setLocale(newLocale);
  }

  // Reset to default locale
  Future<void> resetLocale() async {
    await setLocale(const Locale('en'));
  }
}

// Provider for LocaleNotifier
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

// Helper provider to check if current locale is RTL
final isRTLProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'ar';
});

// Helper provider to get current language name
final currentLanguageNameProvider = Provider<String>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'en' ? 'English' : 'العربية';
});