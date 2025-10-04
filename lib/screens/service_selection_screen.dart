// lib/screens/service_selection_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garage_management/screens/ChatsListScreen.dart';
import '../widgets/chat_button.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final String customerId;

  ServiceSelectionScreen({Key? key, required this.customerId})
    : super(key: key);

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

final currentUser = FirebaseAuth.instance.currentUser;
final customerId = currentUser?.uid;

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  final List<Map<String, dynamic>> services = [
    {
      'name': 'Oil Change',
      'description': 'Complete oil and filter replacement',
      'icon': Icons.oil_barrel,
    },
    {
      'name': 'Oil 2t',
      'description': 'Complete oil and filter replacement',
      'icon': Icons.oil_barrel,
    },
    {
      'name': 'Brake Service',
      'description': 'Brake inspection and repair',
      'icon': Icons.car_repair,
    },
    {
      'name': 'Engine Repair',
      'description': 'Full engine diagnostics and repair',
      'icon': Icons.engineering,
    },
    {
      'name': 'Tire Service',
      'description': 'Tire change and balancing',
      'icon': Icons.tire_repair,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Service')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        service['icon'] as IconData,
                        size: 32,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              service['description'] as String,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle service booking
                          },
                          child: const Text('Book Now'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat button for service inquiry
                      ChatButton(
                        serviceType: service['name'] as String,
                        customerId: customerId ?? "",
                        buttonText: 'Ask',
                        icon: Icons.help_outline,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatsListScreen(
                             
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.list),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
