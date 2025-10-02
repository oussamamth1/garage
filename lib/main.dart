import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garage_management/l10n/l10n.dart';
import 'package:garage_management/src/provider/ThemeModeNotifier.dart';
import 'package:garage_management/src/provider/locale_provider.dart';
import 'package:garage_management/src/screen/AuthGate.dart';
import 'package:garage_management/src/screen/HomePage.dart';
import 'package:garage_management/src/screen/LoginPage.dart';
import 'package:garage_management/src/screen/auth/LanguageSelectionPage.dart';
import 'package:garage_management/src/screen/auth/PhoneAuthScreen.dart';
import 'package:garage_management/src/settings/Settings.dart';
import 'package:garage_management/src/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'l10n/app_localizations.dart';
// import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//  import 'package:localization_i18_arb/l10n/l10n.dart';
//import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize App Check in DEBUG mode for development
    await FirebaseAppCheck.instance.activate(
      // Use debug provider for development/testing
      // androidProvider: AndroidProvider.debug,

      // IMPORTANT: When you're ready for production, change to:
      // androidProvider: AndroidProvider.playIntegrity,

      // For iOS (uncomment when needed):
      // appleProvider: AppleProvider.debug, // for development
      // appleProvider: AppleProvider.appAttest, // for production
    );

    print("✅ Firebase and App Check initialized successfully");
  } catch (e) {
    print("❌ Firebase initialization error: $e");
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget  {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    return MaterialApp(debugShowCheckedModeBanner :false,
      title: 'Garage Management',
      locale: currentLocale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
//       supportedLocales: L10n.all,
//       locale: const Locale('ar'),
// localizationsDelegates: AppLocalizations.localizationsDelegates,
     theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/phone-auth': (context) => const PhoneAuthScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/auth': (context) => const AuthGate(),
      },
     home: const LanguageSelectionPage(),
    );
  }
}
