import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:garage_management/src/provider/authProvider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final profile = ref.watch(userProfileProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider).signOut();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
              }
            },
          ),
        ],
      ),
      body: profile.when(
        data: (admin) {
          if (admin == null || !admin.isAdmin) {
            return const Center(child: Text('Access denied. Admin only.'));
          }
          return _AdminContent();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _AdminContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (context, usersSnap) {
              if (!usersSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final users = usersSnap.data!.docs;
              final technicians = users.where((d) => (d.data() as Map)['role'] == 'technician').length;
              final clients = users.where((d) {
                final r = (d.data() as Map)['role'];
                return r == 'client' || r == 'customer';
              }).length;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatRow('Total users', '${users.length}'),
                      _StatRow('Technicians', '$technicians'),
                      _StatRow('Clients', '$clients'),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Users',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Text('No users yet.');
              }
              final list = docs.map((doc) {
                final d = doc.data() as Map<String, dynamic>;
                return MapEntry(doc.id, d);
              }).toList();
              list.sort((a, b) {
                final ca = a.value['createdAt']?.toString() ?? '';
                final cb = b.value['createdAt']?.toString() ?? '';
                return cb.compareTo(ca);
              });
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final d = list[index].value;
                  final role = d['role'] ?? 'client';
                  return ListTile(
                    title: Text('${d['firstName'] ?? ''} ${d['lastName'] ?? ''}'.trim()),
                    subtitle: Text(d['email'] ?? ''),
                    trailing: Chip(label: Text(role)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
