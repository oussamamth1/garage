import 'package:flutter/material.dart';
import 'package:garage_management/src/provider/ThemeModeNotifier.dart';
import 'package:garage_management/src/provider/locale_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoPlayVideos = false;
  bool _biometricEnabled = true;
  bool _marketingEmails = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isRTL = ref.watch(isRTLProvider);
    final languageName = ref.watch(currentLanguageNameProvider);
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: themeMode == ThemeMode.dark
            ? const Color(0xFF1C1C1E)
            : Colors.grey[100],
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)?.settings ??
                _getLocalizedText('settings', currentLocale.languageCode),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: themeMode == ThemeMode.dark
              ? const Color(0xFF2C2C2E)
              : Colors.white,
          foregroundColor: themeMode == ThemeMode.dark
              ? Colors.white
              : Colors.black87,
        ),
        body: SettingsList(
          darkTheme: const SettingsThemeData(
            settingsListBackground: Color(0xFF1C1C1E),
            settingsSectionBackground: Color(0xFF2C2C2E),
          ),
          lightTheme: const SettingsThemeData(
            settingsListBackground: Color(0xFFF2F2F7),
            settingsSectionBackground: Colors.white,
          ),
          sections: [
            // Account Section
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)?.account ??
                    _getLocalizedText('account', currentLocale.languageCode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.person_outline, color: Colors.blue),
                  title: Text(
                    AppLocalizations.of(context)?.profile ??
                        _getLocalizedText(
                          'profile',
                          currentLocale.languageCode,
                        ),
                  ),
                  description: Text(
                    AppLocalizations.of(context)!.view_edit_profile,
                    // _getLocalizedText(
                    //   'view_edit_profile',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
                      AppLocalizations.of(context)!.profile_tapped,
                      // _getLocalizedText(
                      //   'profile_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.email_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.email,

                    //_getLocalizedText('email', currentLocale.languageCode),
                  ),
                  value: const Text('user@example.com'),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {

                    _showSnackBar(
                    AppLocalizations.of(context)!.email_tapped

                    //   _getLocalizedText(
                    //     'email_tapped',
                    //     currentLocale.languageCode,
                    //   ),
                     );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.phone_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.phone
                    //_getLocalizedText('phone', currentLocale.languageCode),
                  ),
                  value: const Text('+1 234 567 8900'),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
                    AppLocalizations.of(context)!.phone_tapped
                    
  // _getLocalizedText(
                      //   'phone_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
              ],
            ),

            // Preferences Section
            SettingsSection(
              title: Text(
//                 _getLocalizedText('preferences', currentLocale.languageCode
// ),
  AppLocalizations.of(context)!.preferences,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _notificationsEnabled,
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.red,
                  ),
                  title: Text(
                    // _getLocalizedText(
                    //   'notifications',
                    //   currentLocale.languageCode,
                    // ),
                    AppLocalizations.of(context)!.notifications,

                  ),
                  description: Text(
                    // _getLocalizedText(
                    //   'receive_notifications',
                    //   currentLocale.languageCode,
                    // ),
                    AppLocalizations.of(context)!.receive_notifications,

                  ),
                  onToggle: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    _showSnackBar(
                 
                      '${   AppLocalizations.of(context)!.notifications } ${value ?   AppLocalizations.of(context)!.enabled :   AppLocalizations.of(context)!.disabled}',
                    );
                  },
                ),
                SettingsTile.switchTile(
                  initialValue: _autoPlayVideos,
                  leading: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.teal,
                  ),
                  title: Text(
                    // _getLocalizedText(
                    //   'autoplay_videos',
                    //   currentLocale.languageCode,
                    // ),
AppLocalizations.of(context)!.autoplay_videos
                  ),
                  description: Text(
           AppLocalizations.of(context)!.videos_play_auto
                  ),
                  onToggle: (value) {
                    setState(() {
                      _autoPlayVideos = value;
                    });
                    _showSnackBar(
                                            '${AppLocalizations.of(context)!.autoplay} ${value ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled}',

                    );

                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.language_outlined,
                    color: Colors.indigo,
                  ),
                  title: Text(
AppLocalizations.of(context)!.language

                  //  _getLocalizedText('language', currentLocale.languageCode),
                  ),
                  value: Text(languageName),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showLanguageDialog(context);
                  },
                ),
              ],
            ),

            // Theme Section
            SettingsSection(
              title: Text(
AppLocalizations.of(context)!.theme,

            //    _getLocalizedText('theme', currentLocale.languageCode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: themeMode == ThemeMode.dark,
                  leading: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
AppLocalizations.of(context)!.dark_mode,

                  //  _getLocalizedText('dark_mode', currentLocale.languageCode),
                  ),
                  description: Text(
AppLocalizations.of(context)!.dark_mode_description,

                    // _getLocalizedText(
                    //   'dark_mode_description',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  onToggle: (value) async {
                    if (value) {
                      await themeModeNotifier.useDarkTheme();
                      _showSnackBar(
AppLocalizations.of(context)!.dark_mode_enabled,

                        // _getLocalizedText(
                        //   'dark_mode_enabled',
                        //   currentLocale.languageCode,
                        // ),
                      );
                    } else {
                      await themeModeNotifier.useLightTheme();
                      _showSnackBar(
AppLocalizations.of(context)!.light_mode_enabled,

                        // _getLocalizedText(
                        //   'light_mode_enabled',
                        //   currentLocale.languageCode,
                        // ),
                      );
                    }
                  },
                ),
                SettingsTile.switchTile(
                  initialValue: themeMode == ThemeMode.system,
                  leading: const Icon(
                    Icons.brightness_auto,
                    color: Colors.orange,
                  ),
                  title: Text(
AppLocalizations.of(context)!.system_theme,
                    // _getLocalizedText(
                    //   'system_theme',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  description: Text(
AppLocalizations.of(context)!.system_theme_description,
                    // _getLocalizedText(
                    //   'system_theme_description',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  onToggle: (value) async {
                    if (value) {
                      await themeModeNotifier.useSystemTheme();
                      _showSnackBar(
AppLocalizations.of(context)!.system_theme_enabled,
                        // _getLocalizedText(
                        //   'system_theme_enabled',
                        //   currentLocale.languageCode,
                        // ),
                      );
                    } else {
                      await themeModeNotifier.useLightTheme();
                      _showSnackBar(
AppLocalizations.of(context)!.light_mode_enabled,
                        // _getLocalizedText(
                        //   'light_mode_enabled',
                        //   currentLocale.languageCode,
                        // ),
                      );
                    }
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.palette_outlined,
                    color: Colors.pink,
                  ),
                  title: Text(
AppLocalizations.of(context)!.theme_preview,
                    // _getLocalizedText(
                    //   'theme_preview',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  description: Text(
                    _getCurrentThemeText(themeMode, currentLocale.languageCode),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showThemeDialog(
                      context,
                      ref,
                      currentLocale.languageCode,
                      _showSnackBar,
                    );
                  },
                ),
              ],
            ),

            // Security Section
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.security,
                //_getLocalizedText('security', currentLocale.languageCode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.lock_outline, color: Colors.amber),
                  title: Text(
AppLocalizations.of(context)!.change_password,
                    // _getLocalizedText(
                    //   'change_password',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
AppLocalizations.of(context)!.change_password_tapped,
                      // _getLocalizedText(
                      //   'change_password_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
                SettingsTile.switchTile(
                  initialValue: _biometricEnabled,
                  leading: const Icon(
                    Icons.fingerprint,
                    color: Colors.deepOrange,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.biometric,
                  //  _getLocalizedText('biometric', currentLocale.languageCode),
                  ),
                  description: Text(
AppLocalizations.of(context)!.use_fingerprint,
                    // _getLocalizedText(
                    //   'use_fingerprint',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  onToggle: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                    _showSnackBar(
                      '${AppLocalizations.of(context)!.biometric} ${value ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled}',
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.security_outlined,
                    color: Colors.cyan,
                  ),
                  title: Text(
AppLocalizations.of(context)!.privacy_policy,
                    // _getLocalizedText(
                    //   'privacy_policy',
                    //   currentLocale.languageCode,
                    // ),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
AppLocalizations.of(context)!.privacy_tapped
                      // _getLocalizedText(
                      //   'privacy_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.shield_outlined,
                    color: Colors.pink,
                  ),
                  title: Text(AppLocalizations.of(context)!.terms
                    //_getLocalizedText('terms', currentLocale.languageCode),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
AppLocalizations.of(context)!.terms_tapped
                      // _getLocalizedText(
                      //   'terms_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
              ],
            ),

            // Communication Section
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.communication,
               // _getLocalizedText('communication', currentLocale.languageCode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _marketingEmails,
                  leading: const Icon(
                    Icons.email_outlined,
                    color: Colors.lightGreen,
                  ),
                  title: Text(
                    _getLocalizedText(
                      'marketing_emails',
                      currentLocale.languageCode,
                    ),
                  ),
                  description: Text(
                    _getLocalizedText(
                      'receive_promotional',
                      currentLocale.languageCode,
                    ),
                  ),
                  onToggle: (value) {
                    setState(() {
                      _marketingEmails = value;
                    });
                    _showSnackBar(
                      '${_getLocalizedText('marketing_emails', currentLocale.languageCode)} ${value ? _getLocalizedText('enabled', currentLocale.languageCode) : _getLocalizedText('disabled', currentLocale.languageCode)}',
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.feedback_outlined,
                    color: Colors.deepPurple,
                  ),
                  title: Text(
                    _getLocalizedText('feedback', currentLocale.languageCode),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
                      _getLocalizedText(
                        'feedback_tapped',
                        currentLocale.languageCode,
                      ),
                    );
                  },
                ),
              ],
            ),

            // About Section
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.about,
               // _getLocalizedText('about', currentLocale.languageCode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.blueGrey,
                  ),
                  title: Text(AppLocalizations.of(context)!.app_version,
                   
                  ),
                  value: const Text('1.0.0'),
                  onPressed: (context) {
                    _showSnackBar(
                      '${AppLocalizations.of(context)!.version} 1.0.0',
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.help_outline, color: Colors.brown),
                  title: Text(AppLocalizations.of(context)!.help
                   // _getLocalizedText('help', currentLocale.languageCode),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(
AppLocalizations.of(context)!.help_tapped
                      // _getLocalizedText(
                      //   'help_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.star_outline, color: Colors.yellow),
                  title: Text(AppLocalizations.of(context)!.rate_app
                 //   _getLocalizedText('rate_app', currentLocale.languageCode),
                  ),
                  trailing: Icon(
                    isRTL ? Icons.chevron_left : Icons.chevron_right,
                  ),
                  onPressed: (context) {
                    _showSnackBar(AppLocalizations.of(context)!.rate_tapped
                      // _getLocalizedText(
                      //   'rate_tapped',
                      //   currentLocale.languageCode,
                      // ),
                    );
                  },
                ),
              ],
            ),

            // Danger Zone
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.danger_zone,
              //  _getLocalizedText('danger_zone', currentLocale.languageCode),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(AppLocalizations.of(context)!.log_out,
                //    _getLocalizedText('logout', currentLocale.languageCode),
                    style: const TextStyle(color: Colors.red),
                  ),
                  onPressed: (context) {
                    _showLogoutDialog(context);
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(AppLocalizations.of(context)!.delete_account,
                    // _getLocalizedText(
                    //   'delete_account',
                    //   currentLocale.languageCode,
                    // ),
                    style: const TextStyle(color: Colors.red),
                  ),
                  onPressed: (context) {
                    _showDeleteDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            _getLocalizedText('select_language', currentLocale.languageCode),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageOption(
                flag: '🇬🇧',
                language: 'English',
                languageCode: 'en',
                isSelected: currentLocale.languageCode == 'en',
                onTap: () {
                  Navigator.pop(dialogContext);
                  _selectLanguage('en');
                },
              ),
              const SizedBox(height: 8),
              _LanguageOption(
                flag: '🇸🇦',
                language: 'العربية',
                languageCode: 'ar',
                isSelected: currentLocale.languageCode == 'ar',
                onTap: () {
                  Navigator.pop(dialogContext);
                  _selectLanguage('ar');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getCurrentThemeText(ThemeMode mode, String languageCode) {
    switch (mode) {
      case ThemeMode.light:
        return _getLocalizedText('current_light', languageCode);
      case ThemeMode.dark:
        return _getLocalizedText('current_dark', languageCode);
      case ThemeMode.system:
        return _getLocalizedText('current_system', languageCode);
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
    Function(String) showSnackBar,
  ) {
    final themeMode = ref.read(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getLocalizedText('select_theme', languageCode)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(_getLocalizedText('light_mode', languageCode)),
              subtitle: Text(
                _getLocalizedText('light_mode_desc', languageCode),
              ),
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await themeModeNotifier.setThemeMode(value);
                  Navigator.pop(context);
                  showSnackBar(
                    _getLocalizedText('light_mode_enabled', languageCode),
                  );
                }
              },
              secondary: const Icon(Icons.light_mode),
            ),
            RadioListTile<ThemeMode>(
              title: Text(_getLocalizedText('dark_mode', languageCode)),
              subtitle: Text(_getLocalizedText('dark_mode_desc', languageCode)),
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await themeModeNotifier.setThemeMode(value);
                  Navigator.pop(context);
                  showSnackBar(
                    _getLocalizedText('dark_mode_enabled', languageCode),
                  );
                }
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            RadioListTile<ThemeMode>(
              title: Text(_getLocalizedText('system_theme', languageCode)),
              subtitle: Text(
                _getLocalizedText('system_theme_desc', languageCode),
              ),
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (value) async {
                if (value != null) {
                  await themeModeNotifier.setThemeMode(value);
                  Navigator.pop(context);
                  showSnackBar(
                    _getLocalizedText('system_theme_enabled', languageCode),
                  );
                }
              },
              secondary: const Icon(Icons.brightness_auto),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_getLocalizedText('cancel', languageCode)),
          ),
        ],
      ),
    );
  }

  void _selectLanguage(String languageCode) async {
    await ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
    if (mounted) {
      _showSnackBar(_getLocalizedText('language_changed', languageCode));
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getLocalizedText('logout', currentLocale.languageCode)),
          content: Text(
            _getLocalizedText('logout_confirm', currentLocale.languageCode),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _getLocalizedText('cancel', currentLocale.languageCode),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar(
                  _getLocalizedText('logged_out', currentLocale.languageCode),
                );
              },
              child: Text(
                _getLocalizedText('logout', currentLocale.languageCode),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _getLocalizedText('delete_account', currentLocale.languageCode),
          ),
          content: Text(
            _getLocalizedText('delete_confirm', currentLocale.languageCode),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _getLocalizedText('cancel', currentLocale.languageCode),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar(
                  _getLocalizedText(
                    'delete_requested',
                    currentLocale.languageCode,
                  ),
                );
              },
              child: Text(
                _getLocalizedText('delete', currentLocale.languageCode),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  // Localization helper
  String _getLocalizedText(String key, String languageCode) {
    final translations = {
      'en': {
        'settings': 'Settings',
        'account': 'Account',
        'profile': 'Profile',
        'view_edit_profile': 'View and edit your profile',
        'email': 'Email',
        'phone': 'Phone Number',
        'theme': 'Theme',
        'preferences': 'Preferences',
        'notifications': 'Push Notifications',
        'receive_notifications': 'Receive push notifications',
        'dark_mode': 'Dark Mode',
        'enable_dark_theme': 'Enable dark theme',
        'autoplay_videos': 'Auto-play Videos',
        'videos_play_auto': 'Videos play automatically',
        'autoplay': 'Auto-play',
        'language': 'Language',
        'security': 'Security & Privacy',
        'change_password': 'Change Password',
        'biometric': 'Biometric Authentication',
        'use_fingerprint': 'Use fingerprint or face ID',
        'privacy_policy': 'Privacy Policy',
        'terms': 'Terms of Service',
        'communication': 'Communication',
        'marketing_emails': 'Marketing Emails',
        'receive_promotional': 'Receive promotional emails',
        'feedback': 'Send Feedback',
        'about': 'About',
        'app_version': 'App Version',
        'version': 'Version',
        'help': 'Help & Support',
        'rate_app': 'Rate This App',
        'danger_zone': 'Danger Zone',
        'logout': 'Log Out',
        'delete_account': 'Delete Account',
        'enabled': 'enabled',
        'disabled': 'disabled',
        'profile_tapped': 'Profile tapped',
        'email_tapped': 'Email tapped',
        'phone_tapped': 'Phone Number tapped',
        'change_password_tapped': 'Change Password tapped',
        'privacy_tapped': 'Privacy Policy tapped',
        'terms_tapped': 'Terms of Service tapped',
        'feedback_tapped': 'Send Feedback tapped',
        'help_tapped': 'Help & Support tapped',
        'rate_tapped': 'Rate App tapped',
        'select_language': 'Select Language',
        'language_changed': 'Language changed successfully',
        'logout_confirm': 'Are you sure you want to log out?',
        'delete_confirm':
            'Are you sure you want to delete your account? This action cannot be undone.',
        'cancel': 'Cancel',
        'delete': 'Delete',
        'logged_out': 'Logged out successfully',
        'delete_requested': 'Account deletion requested',
      },
      'ar': {
        'settings': 'الإعدادات',
        'account': 'الحساب',
        'profile': 'الملف الشخصي',
        'theme': 'Theme',
        'view_edit_profile': 'عرض وتعديل ملفك الشخصي',
        'email': 'البريد الإلكتروني',
        'phone': 'رقم الهاتف',
        'preferences': 'التفضيلات',
        'notifications': 'الإشعارات الفورية',
        'receive_notifications': 'تلقي الإشعارات الفورية',
        'dark_mode': 'الوضع الداكن',
        'enable_dark_theme': 'تفعيل السمة الداكنة',
        'autoplay_videos': 'تشغيل الفيديو تلقائياً',
        'videos_play_auto': 'تشغيل الفيديوهات تلقائياً',
        'autoplay': 'التشغيل التلقائي',
        'language': 'اللغة',
        'security': 'الأمان والخصوصية',
        'change_password': 'تغيير كلمة المرور',
        'biometric': 'المصادقة البيومترية',
        'use_fingerprint': 'استخدام بصمة الإصبع أو الوجه',
        'privacy_policy': 'سياسة الخصوصية',
        'terms': 'شروط الخدمة',
        'communication': 'التواصل',
        'marketing_emails': 'رسائل التسويق',
        'receive_promotional': 'تلقي رسائل ترويجية',
        'feedback': 'إرسال ملاحظات',
        'about': 'حول',
        'app_version': 'إصدار التطبيق',
        'version': 'الإصدار',
        'help': 'المساعدة والدعم',
        'rate_app': 'قيم هذا التطبيق',
        'danger_zone': 'منطقة الخطر',
        'logout': 'تسجيل الخروج',
        'delete_account': 'حذف الحساب',
        'enabled': 'مفعّل',
        'disabled': 'معطّل',
        'profile_tapped': 'تم النقر على الملف الشخصي',
        'email_tapped': 'تم النقر على البريد الإلكتروني',
        'phone_tapped': 'تم النقر على رقم الهاتف',
        'change_password_tapped': 'تم النقر على تغيير كلمة المرور',
        'privacy_tapped': 'تم النقر على سياسة الخصوصية',
        'terms_tapped': 'تم النقر على شروط الخدمة',
        'feedback_tapped': 'تم النقر على إرسال ملاحظات',
        'help_tapped': 'تم النقر على المساعدة والدعم',
        'rate_tapped': 'تم النقر على تقييم التطبيق',
        'select_language': 'اختر اللغة',
        'language_changed': 'تم تغيير اللغة بنجاح',
        'logout_confirm': 'هل أنت متأكد من تسجيل الخروج؟',
        'delete_confirm':
            'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.',
        'cancel': 'إلغاء',
        'delete': 'حذف',
        'logged_out': 'تم تسجيل الخروج بنجاح',
        'delete_requested': 'تم طلب حذف الحساب',
      },
    };

    return translations[languageCode]?[key] ?? key;
  }
}

// Language option widget
class _LanguageOption extends StatelessWidget {
  final String flag;
  final String language;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.language,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }
}
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _notificationsEnabled = true;
//   bool _darkModeEnabled = false;
//   bool _autoPlayVideos = false;
//   bool _biometricEnabled = true;
//   bool _marketingEmails = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _darkModeEnabled
//           ? const Color(0xFF1C1C1E)
//           : Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'Settings',
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: _darkModeEnabled
//             ? const Color(0xFF2C2C2E)
//             : Colors.white,
//         foregroundColor: _darkModeEnabled ? Colors.white : Colors.black87,
//       ),
//       body: SettingsList(
//         darkTheme: const SettingsThemeData(
//           settingsListBackground: Color(0xFF1C1C1E),
//           settingsSectionBackground: Color(0xFF2C2C2E),
//         ),
//         lightTheme: const SettingsThemeData(
//           settingsListBackground: Color(0xFFF2F2F7),
//           settingsSectionBackground: Colors.white,
//         ),
//         sections: [
//           // Account Section
//           SettingsSection(
//             title: const Text(
//               'Account',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.person_outline, color: Colors.blue),
//                 title: const Text('Profile'),
//                 description: const Text('View and edit your profile'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Profile tapped');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.email_outlined, color: Colors.green),
//                 title: const Text('Email'),
//                 value: const Text('user@example.com'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Email tapped');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.phone_outlined, color: Colors.orange),
//                 title: const Text('Phone Number'),
//                 value: const Text('+1 234 567 8900'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Phone Number tapped');
//                 },
//               ),
//             ],
//           ),

//           // Preferences Section
//           SettingsSection(
//             title: const Text(
//               'Preferences',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             tiles: [
//               SettingsTile.switchTile(
//                 initialValue: _notificationsEnabled,
//                 leading: const Icon(
//                   Icons.notifications_outlined,
//                   color: Colors.red,
//                 ),
//                 title: const Text('Push Notifications'),
//                 description: const Text('Receive push notifications'),
//                 onToggle: (value) {
//                   setState(() {
//                     _notificationsEnabled = value;
//                   });
//                   _showSnackBar(
//                     'Notifications ${value ? 'enabled' : 'disabled'}',
//                   );
//                 },
//               ),
//               SettingsTile.switchTile(
//                 initialValue: _darkModeEnabled,
//                 leading: const Icon(
//                   Icons.dark_mode_outlined,
//                   color: Colors.purple,
//                 ),
//                 title: const Text('Dark Mode'),
//                 description: const Text('Enable dark theme'),
//                 onToggle: (value) {
//                   setState(() {
//                     _darkModeEnabled = value;
//                   });
//                 },
//               ),
//               SettingsTile.switchTile(
//                 initialValue: _autoPlayVideos,
//                 leading: const Icon(
//                   Icons.play_circle_outline,
//                   color: Colors.teal,
//                 ),
//                 title: const Text('Auto-play Videos'),
//                 description: const Text('Videos play automatically'),
//                 onToggle: (value) {
//                   setState(() {
//                     _autoPlayVideos = value;
//                   });
//                   _showSnackBar('Auto-play ${value ? 'enabled' : 'disabled'}');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(
//                   Icons.language_outlined,
//                   color: Colors.indigo,
//                 ),
//                 title: const Text('Language'),
//                 value: const Text('English'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Language tapped');
//                 },
//               ),
//             ],
//           ),

//           // Security Section
//           SettingsSection(
//             title: const Text(
//               'Security & Privacy',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.lock_outline, color: Colors.amber),
//                 title: const Text('Change Password'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Change Password tapped');
//                 },
//               ),
//               SettingsTile.switchTile(
//                 initialValue: _biometricEnabled,
//                 leading: const Icon(
//                   Icons.fingerprint,
//                   color: Colors.deepOrange,
//                 ),
//                 title: const Text('Biometric Authentication'),
//                 description: const Text('Use fingerprint or face ID'),
//                 onToggle: (value) {
//                   setState(() {
//                     _biometricEnabled = value;
//                   });
//                   _showSnackBar('Biometric ${value ? 'enabled' : 'disabled'}');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(
//                   Icons.security_outlined,
//                   color: Colors.cyan,
//                 ),
//                 title: const Text('Privacy Policy'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Privacy Policy tapped');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.shield_outlined, color: Colors.pink),
//                 title: const Text('Terms of Service'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Terms of Service tapped');
//                 },
//               ),
//             ],
//           ),

//           // Communication Section
//           SettingsSection(
//             title: const Text(
//               'Communication',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             tiles: [
//               SettingsTile.switchTile(
//                 initialValue: _marketingEmails,
//                 leading: const Icon(
//                   Icons.email_outlined,
//                   color: Colors.lightGreen,
//                 ),
//                 title: const Text('Marketing Emails'),
//                 description: const Text('Receive promotional emails'),
//                 onToggle: (value) {
//                   setState(() {
//                     _marketingEmails = value;
//                   });
//                   _showSnackBar(
//                     'Marketing emails ${value ? 'enabled' : 'disabled'}',
//                   );
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(
//                   Icons.feedback_outlined,
//                   color: Colors.deepPurple,
//                 ),
//                 title: const Text('Send Feedback'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Send Feedback tapped');
//                 },
//               ),
//             ],
//           ),

//           // About Section
//           SettingsSection(
//             title: const Text(
//               'About',
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//             ),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
//                 title: const Text('App Version'),
//                 value: const Text('1.0.0'),
//                 onPressed: (context) {
//                   _showSnackBar('Version 1.0.0');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.help_outline, color: Colors.brown),
//                 title: const Text('Help & Support'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Help & Support tapped');
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.star_outline, color: Colors.yellow),
//                 title: const Text('Rate This App'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onPressed: (context) {
//                   _showSnackBar('Rate App tapped');
//                 },
//               ),
//             ],
//           ),

//           // Danger Zone
//           SettingsSection(
//             title: const Text(
//               'Danger Zone',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.red,
//               ),
//             ),
//             tiles: [
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title: const Text(
//                   'Log Out',
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onPressed: (context) {
//                   _showLogoutDialog(context);
//                 },
//               ),
//               SettingsTile.navigation(
//                 leading: const Icon(Icons.delete_forever, color: Colors.red),
//                 title: const Text(
//                   'Delete Account',
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onPressed: (context) {
//                   _showDeleteDialog(context);
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Log Out'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showSnackBar('Logged out successfully');
//               },
//               child: const Text('Log Out', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Account'),
//           content: const Text(
//             'Are you sure you want to delete your account? This action cannot be undone.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _showSnackBar('Account deletion requested');
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // Main function to run the app
