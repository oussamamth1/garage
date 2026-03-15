import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/Accuile.dart';
import 'package:garage_management/src/screen/MotoItemsScreen.dart';
import 'package:garage_management/src/screen/MyBookingsScreen.dart';
import 'package:garage_management/src/screen/ChatsListScreen.dart';
import 'package:garage_management/src/screen/ProfilePage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? "";
    final profile = ref.watch(userProfileProvider(uid));

    final List<Widget> _pages = [
      Accuile(),
      const MyBookingsScreen(),
      const ChatsListScreen(isTechnician: false),
      MotoItemsScreen(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _selectedIndex != 4
          ? AppBar(
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
                // Notification icon with badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        // Handle notifications
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                // Profile avatar in app bar
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: profile.when(
                    data: (userData) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
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
                    loading: () => const CircleAvatar(
                      radius: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => const CircleAvatar(
                      radius: 18,
                      child: Icon(Icons.person, size: 20),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.textIn,
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: const Color.fromARGB(255, 220, 217, 220),
        color: Colors.white.withOpacity(0.6),
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.calendar_today, title: 'Bookings'),
          TabItem(icon: Icons.chat, title: 'Chats'),
          TabItem(icon: Icons.motorcycle, title: 'MotoItem'),
          TabItem(icon: Icons.person_outlined, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'My Bookings';
      case 2:
        return 'Chats';
      case 3:
        return 'MotoItem';
      case 4:
        return 'Profile';
      default:
        return 'Garage Management';
    }
  }
}
