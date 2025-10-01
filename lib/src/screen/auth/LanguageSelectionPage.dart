import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/provider/locale_provider.dart';
import 'package:garage_management/src/screen/AuthGate.dart';
import 'package:garage_management/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionPage extends ConsumerWidget {
  const LanguageSelectionPage({super.key});

  void _selectLanguage(
    WidgetRef ref,
    BuildContext context,
    String languageCode,
  ) async {
    // Update locale using Riverpod
    await ref.read(localeProvider.notifier).setLocale(Locale(languageCode));

    // Navigate to main app
    // if (context.mounted) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const AuthGate()),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                    ),
                  ),
                );
              },
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Welcome text
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.welcome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.letsGetStarted,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Language selection card
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.pick_your_language,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // English button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                            onPressed: () =>
                                _selectLanguage(ref, context, 'en'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              localizations.langEN,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Arabic button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: OutlinedButton(
                            onPressed: () =>
                                _selectLanguage(ref, context, 'ar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 55),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              localizations.langAR,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Logo
                        Image.asset(
                          'assets/garage_logo.jpg',
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.directions_car,
                              size: 60,
                              color: Colors.black54,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.walks_regularly,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class LanguageSelectionPage extends StatelessWidget {
//   const LanguageSelectionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images.jpg', // Add your image to assets
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Dark overlay
//           Positioned.fill(
//             child: Container(color: Colors.black.withOpacity(0.4)),
//           ),
//           // Content
//           SafeArea(
//             child: Column(
//               children: [
//                 // Status bar area
//                 const SizedBox(height: 20),

//                 // Welcome text
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Text(
//                         'WELCOME',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Let\'s Get Started',
//                         style: TextStyle(color: Colors.white70, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Language selection card
//                 Expanded(
//                   flex: 2,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           'Select Language',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 30),

//                         // English button
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 40),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Navigate to main app with English
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const AuthGate(),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,
//                               foregroundColor: Colors.white,
//                               minimumSize: const Size(double.infinity, 55),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: const Text(
//                               'ENGLISH',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 15),

//                         // Arabic button
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 40),
//                           child: OutlinedButton(
//                             onPressed: () {
//                               // Navigate to main app with Arabic
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const AuthGate(),
//                                 ),
//                               );
//                             },
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: Colors.black,
//                               minimumSize: const Size(double.infinity, 55),
//                               side: const BorderSide(
//                                 color: Colors.grey,
//                                 width: 1.5,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: const Text(
//                               'ARABIC',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 30),

//                         // Logo
//                         Image.asset(
//                           'assets/garage_logo.jpg', // Add your logo
//                           height: 60,
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'الموقع الرسمي للسيارة والمحركات',
//                           style: TextStyle(fontSize: 12, color: Colors.black54),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
