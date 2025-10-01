import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyActivityScreen extends StatelessWidget {
  const MyActivityScreen({super.key});

  void _showBookingDetails(
    BuildContext context,
    Map<String, dynamic> booking,
    DateTime? dateTime,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(booking["serviceName"] ?? "Unknown Service"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        dateTime!=null?    Text("Date: ${DateFormat('dd/MM/yyyy HH:mm').format(dateTime)}"):SizedBox.shrink(),
            Text("Status: ${booking["status"] ?? "pending"}"),
            Text("Description: ${booking["description"] ?? "No description"}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(order["itemName"] ?? "Unknown Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quantity: ${order["quantity"]}"),
            Text("Price: \$${order["price"]?.toStringAsFixed(2) ?? 0}"),
            Text("Total: \$${order["totalPrice"]?.toStringAsFixed(2) ?? 0}"),
            Text("Status: ${order["status"] ?? "pending"}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDocument(
    BuildContext context,
    String path,
    String docId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Item"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.doc('$path/$docId').delete();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Please log in to see your activity",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    final bookingsStream = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("bookings")
        .orderBy("createdAt", descending: true)
        .snapshots();

    final ordersStream = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("orders")
        .orderBy("createdAt", descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text("My Activity")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bookings
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "My Bookings",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: bookingsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final bookings = snapshot.data!.docs;
                if (bookings.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No bookings found"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final doc = bookings[index];
                    final booking = doc.data() as Map<String, dynamic>;
                final DateTime? dateTime = (booking["dateTime"] as Timestamp?)
                        ?.toDate();
                    final status = booking["status"] ?? "pending";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        onTap: () =>
                            _showBookingDetails(context, booking, dateTime),
                        leading: const Icon(Icons.build_circle, size: 40),
                        title: Text(
                            booking["serviceName"] ??
                              "${booking["itemType"] ?? ''} ${booking["itemName"] ?? ''}",
                        ),
                  subtitle: dateTime != null
    ? Text("${DateFormat('dd/MM/yyyy HH:mm').format(dateTime)} | Status: $status")
    : Text("Status: $status ${booking["itemName"]}"),


                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            final docId = doc.id;
                            if (value == "delete") {
                              await _deleteDocument(
                                context,
                                'users/${user.uid}/bookings',
                                docId,
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Orders
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "My Orders",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: ordersStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final orders = snapshot.data!.docs;
                if (orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No orders found"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final doc = orders[index];
                    final order = doc.data() as Map<String, dynamic>;
                    final status = order["status"] ?? "pending";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        onTap: () => _showOrderDetails(context, order),
                        leading: const Icon(Icons.shopping_cart, size: 40),
                        title: Text(order["itemName"] ?? "Unknown Item"),
                        subtitle: Text(
                          "Quantity: ${order["quantity"]} | Status: $status",
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            final docId = doc.id;
                            if (value == "delete") {
                              await _deleteDocument(
                                context,
                                'users/${user.uid}/orders',
                                docId,
                              );
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
