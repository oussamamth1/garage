import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/HomePage.dart';
import 'package:garage_management/src/screen/LoginPage.dart';
import 'package:garage_management/src/screen/auth/PhoneAuthScreen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // User is not logged in
          return const PhoneAuthScreen();
        } else {
          // User is logged in, fetch profile from Firestore
          final profileAsync = ref.watch(userProfileProvider(user.uid));

          return profileAsync.when(
            data: (profile) {
              if (profile == null) {
                return LoginPage();
               // const Center(child: Text("Profile not found"));
              }
              // Pass profile to HomePage
              return HomePage();
            },
            loading: () => Scaffold(
              body: const Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}
