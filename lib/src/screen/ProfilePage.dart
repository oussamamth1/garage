import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_management/src/provider/authProvider.dart';
import 'package:garage_management/src/screen/AuthGate.dart';
import 'package:garage_management/src/screen/EditProfilePage.dart';
import 'package:garage_management/src/screen/MyBookingsScreen.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCreatingProfile = false;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (_isCreatingProfile) return;

    setState(() => _isCreatingProfile = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user logged in");
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!docSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
              'uid': currentUser.uid,
              'email': currentUser.email ?? '',
              'firstName': currentUser.displayName?.split(' ').first ?? 'User',
              'lastName': currentUser.displayName?.split(' ').last ?? '',
              'phone': currentUser.phoneNumber ?? '',
              'role': 'customer',
              'photoUrl': currentUser.photoURL ?? '',
              'photoBase64': '',
              'createdAt': DateTime.now().toIso8601String(),
            });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile created successfully!")),
          );
          ref.invalidate(userProfileProvider(currentUser.uid));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error creating profile: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingProfile = false);
      }
    }
  }

  Future<void> _navigateToEditProfile(Map<String, dynamic> userData) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text("Not logged in"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Go Back"),
              ),
            ],
          ),
        ),
      );
    }

    final profile = ref.watch(userProfileProvider(uid));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: profile.when(
        data: (user) {
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    "Profile not found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let's create your profile",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isCreatingProfile ? null : _createProfile,
                    icon: _isCreatingProfile
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add),
                    label: Text(
                      _isCreatingProfile ? "Creating..." : "Create Profile",
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final userData = {
            'uid': user.uid,
            'email': user.email,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'phone': user.phone,
            'role': user.role,
            'photoUrl': user.photoUrl,
            'photoBase64': user.photoBase64 ?? '',
          };

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context, userData),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildStatsCards(context),
                    const SizedBox(height: 24),
                    _buildInfoSection(context, userData),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, ref),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                "Error loading profile",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "$e",
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProfileProvider(uid)),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Map<String, dynamic> userData) {
    final opacity = (_scrollOffset / 300).clamp(0.0, 1.0);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white.withOpacity(0.6 + (opacity * 0.4)),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: Colors.white.withOpacity(0.6 + (opacity * 0.4)),
          ),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 200),
          child: Text(
            "${userData['firstName']} ${userData['lastName']}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                    Theme.of(context).primaryColor.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Hero(
                    tag: 'profile_image',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 62,
                              backgroundImage: _getProfileImage(userData),
                              backgroundColor: Colors.grey[100],
                              child: _getProfileImage(userData) == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[400],
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _navigateToEditProfile(userData),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${userData['firstName']} ${userData['lastName']}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      userData['role'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.calendar_today_outlined,
              value: "12",
              label: "Appointments",
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.check_circle_outline,
              value: "8",
              label: "Completed",
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.schedule,
              value: "2",
              label: "Pending",
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Contact Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
            const Divider(height: 1),
            _buildInfoTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: userData['email'] ?? 'Not provided',
              color: Colors.blue,
            ),
            const Divider(height: 1, indent: 68),
            _buildInfoTile(
              icon: Icons.phone_outlined,
              title: "Phone",
              value: userData['phone'] ?? 'Not provided',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildActionButton(
            context,
            icon: Icons.lock_outline,
            label: "Change Password",
            onTap: () {},
            gradient: LinearGradient(
              colors: [Colors.blue[400]!, Colors.blue[600]!],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.notifications_outlined,
            label: "Notifications",
            onTap: () {},
            gradient: LinearGradient(
              colors: [Colors.purple[400]!, Colors.purple[600]!],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.help_outline,
            label: "Help & Support",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBookingsScreen(),
                ),
              );
            },
            gradient: LinearGradient(
              colors: [Colors.orange[400]!, Colors.orange[600]!],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.help_outline,
            label: "My bookings",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBookingsScreen(),
                ),
              );
            },
            gradient: LinearGradient(
              colors: [Colors.orange[400]!, Colors.orange[600]!],
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.logout,
            label: "Logout",
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
            //    await FirebaseAuth.instance.signOut();
              try {
          // Sign out from Firebase
          await FirebaseAuth.instance.signOut();
          
          if (context.mounted) {
            // Navigate to AuthGate and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthGate()),
              (route) => false,
            );
          }}catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
              }
              }},
            gradient: LinearGradient(
              colors: [Colors.red[400]!, Colors.red[600]!],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage(Map<String, dynamic> userData) {
    final photoBase64 = userData['photoBase64'];
    final photoUrl = userData['photoUrl'];

    if (photoBase64 != null && photoBase64.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(photoBase64));
      } catch (e) {
        print("Error decoding base64 image: $e");
      }
    }

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return NetworkImage(photoUrl);
    }

    return null;
  }
}
