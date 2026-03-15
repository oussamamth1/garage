import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/HomePage.dart';
import 'package:garage_management/src/screen/LoginPage.dart';
import 'package:garage_management/src/screen/AdminDashboardPage.dart';
import 'package:garage_management/src/screen/TechnicianHomePage.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginPage();
        }
        final profileAsync = ref.watch(userProfileProvider(user.uid));

        return profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text("Profile not found"));
            }
            if (profile.isAdmin) {
              return const AdminDashboardPage();
            }
            if (profile.isTechnician) {
              return const TechnicianHomePage();
            }
            return const HomePage();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
    );
  }
}
