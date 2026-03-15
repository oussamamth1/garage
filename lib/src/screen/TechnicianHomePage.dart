import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/TechnicianMyServicesScreen.dart';
import 'package:garage_management/src/screen/TechnicianIncomingRequestsScreen.dart';
import 'package:garage_management/src/screen/TechnicianMyJobsScreen.dart';
import 'package:garage_management/src/screen/ChatsListScreen.dart';
import 'package:garage_management/src/screen/ProfilePage.dart';

class TechnicianHomePage extends ConsumerStatefulWidget {
  const TechnicianHomePage({super.key});

  @override
  ConsumerState<TechnicianHomePage> createState() => _TechnicianHomePageState();
}

class _TechnicianHomePageState extends ConsumerState<TechnicianHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    TechnicianMyServicesScreen(),
    TechnicianIncomingRequestsScreen(),
    TechnicianMyJobsScreen(),
    ChatsListScreen(isTechnician: true),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final profile = ref.watch(userProfileProvider(uid));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          _getPageTitle(_selectedIndex),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: profile.when(
              data: (userData) => GestureDetector(
                onTap: () => setState(() => _selectedIndex = 4),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: userData?.photoUrl.isNotEmpty == true
                      ? NetworkImage(userData!.photoUrl)
                      : null,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: userData?.photoUrl.isEmpty == true
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),
              loading: () => const CircleAvatar(radius: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              error: (_, __) => const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.textIn,
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: const Color.fromARGB(255, 220, 217, 220),
        color: Colors.white.withOpacity(0.6),
        items: const [
          TabItem(icon: Icons.build_circle, title: 'My Services'),
          TabItem(icon: Icons.inbox, title: 'Requests'),
          TabItem(icon: Icons.assignment, title: 'My Jobs'),
          TabItem(icon: Icons.chat, title: 'Chats'),
          TabItem(icon: Icons.person_outlined, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'My Services';
      case 1:
        return 'Incoming Requests';
      case 2:
        return 'My Jobs';
      case 3:
        return 'Chats';
      case 4:
        return 'Profile';
      default:
        return 'Technician';
    }
  }
}
