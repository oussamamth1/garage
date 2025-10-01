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
      //_buildBookingsPage(context),
Accuile(),
      const ProfilePage(),
MotoTypeScreen(),
    //  _buildJobsPage(context),
      MyActivityScreen(),
CustomerHomeScreen()
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _selectedIndex != 3
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
      bottomNavigationBar: ConvexAppBar.badge(
        {0: '2', 1: Icons.new_releases},
        badgeMargin: const EdgeInsets.only(bottom: 30, right: 40),
        badgeColor: const Color.fromARGB(255, 5, 1, 6),
        badgeTextColor: Colors.white,
        style: TabStyle.textIn,

        backgroundColor: Theme.of(context).primaryColor,
        activeColor:  const Color.fromARGB(255, 220, 217, 220),
        color: Colors.white.withOpacity(0.6),
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person_outlined, title: 'Profile'),
          TabItem(icon: Icons.build_circle, title: 'Jobs'),
          TabItem(icon: Icons.inventory_2, title: 'Inventory'),
          TabItem(icon: Icons.motorcycle, title: 'MotoItem'),
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
        return 'My Bookings';
      case 1:
        return 'Jobs';
      case 2:
        return 'Inventory';
      default:
        return 'Garage Management';
    }
  }

  Widget _buildBookingsPage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCard(context),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Bookings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBookingCard(context, index),
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Active', '8', Icons.pending_actions),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          _buildStatItem('Completed', '24', Icons.check_circle),
          Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
          _buildStatItem('Pending', '3', Icons.schedule),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBookingCard(BuildContext context, int index) {
    final isUrgent = index == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUrgent ? Border.all(color: Colors.orange, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Toyota Camry 2020',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[900],
                          ),
                        ),
                        if (isUrgent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'URGENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      'Oil Change & Inspection',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'In Progress',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Today, 2:30 PM',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const Spacer(),
              Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
              Text(
                '\$150',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobsPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '🛠️ Jobs Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Coming Soon', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildInventoryPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            '📦 Inventory System',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Coming Soon', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
