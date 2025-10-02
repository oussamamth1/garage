import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/Accuile.dart';
import 'package:garage_management/src/screen/Moto/MotoTypeScreen.dart';
import 'package:garage_management/src/screen/MotoItemsScreen.dart';
import 'package:garage_management/src/screen/MyActivityScreen.dart';
import 'package:garage_management/src/screen/ProfilePage.dart';
import 'package:garage_management/src/screen/costomer/CustomerHomeScreen.dart';
import 'package:garage_management/src/settings/Settings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? "";
    final profile = ref.watch(userProfileProvider(uid));

    final List<Widget> _pages = [
      Accuile(),
      const ProfilePage(),
      MotoTypeScreen(),
      MyActivityScreen(),
      CustomerHomeScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBodyBehindAppBar: _selectedIndex == 0,
      appBar: _selectedIndex != 3
          ? PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                elevation: 0,
                backgroundColor: _selectedIndex == 0
                    ? Colors.transparent
                    : Theme.of(context).primaryColor,
                flexibleSpace: _selectedIndex != 0
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      )
                    : null,
                title: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPageTitle(_selectedIndex),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        _getPageSubtitle(_selectedIndex),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // Notification icon with modern badge
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              size: 24,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
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
                  ),
                  // Enhanced profile avatar
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: profile.when(
                      data: (userData) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 3;
                            _animationController.reset();
                            _animationController.forward();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                userData?.photoUrl.isNotEmpty == true
                                ? NetworkImage(userData!.photoUrl)
                                : null,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            child: userData?.photoUrl.isEmpty == true
                                ? const Icon(Icons.person, size: 22)
                                : null,
                          ),
                        ),
                      ),
                      loading: () => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      error: (_, __) => const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ConvexAppBar.badge(
          {0: '2', 1: Icons.fiber_manual_record},
          badgeMargin: const EdgeInsets.only(bottom: 30, right: 35),
          badgePadding: const EdgeInsets.all(4),
          badgeColor: const Color(0xFFFF6B6B),
          badgeTextColor: Colors.white,
          style: TabStyle.custom,
          backgroundColor: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          activeColor: const Color.fromARGB(255, 16, 10, 10),
          color: const Color.fromARGB(255, 12, 7, 156),
          height: 60,
          curveSize: 80,
          top: -25,
          items: const [
            TabItem(icon: Icons.home_rounded, title: 'Home'),
            TabItem(icon: Icons.person_outline_rounded, title: 'Profile'),
            TabItem(icon: Icons.build_circle_outlined, title: 'Jobs'),
            TabItem(icon: Icons.inventory_2_outlined, title: 'Activity'),
            TabItem(icon: Icons.two_wheeler_rounded, title: 'Vehicles'),
          ],
          initialActiveIndex: 0,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _animationController.reset();
              _animationController.forward();
            });
          },
        ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'My Profile';
      case 2:
        return 'Service Jobs';
      case 3:
        return 'My Activity';
      case 4:
        return 'Vehicle Management';
      default:
        return 'Garage Management';
    }
  }

  String _getPageSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Welcome back!';
      case 1:
        return 'Manage your account';
      case 2:
        return 'Active service requests';
      case 3:
        return 'Track your operations';
      case 4:
        return 'Manage motorcycles & parts';
      default:
        return 'Your workspace';
    }
  }
}
