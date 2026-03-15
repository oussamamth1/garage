import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_management/src/model/service.dart';
import 'package:garage_management/src/model/supplierItem.dart';
import 'package:garage_management/src/provider/servicesProvider.dart';
import 'package:garage_management/src/screen/BookingScreen.dart';

final suppliersProvider = StreamProvider<List<SupplierItem>>((ref) {
  return FirebaseFirestore.instance
      .collection('suppliers')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => SupplierItem.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});
class Accuile extends ConsumerWidget {
  const Accuile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesProvider);
    final suppliersAsync = ref.watch(suppliersProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Banner
            Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/banner.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.4),
                child: Text(
                  "ALN Motorbike Maintenance\n30 Years Experience",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Popular Services
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Popular Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            servicesAsync.when(
              data: (services) {
                final withTechnician = services.where((s) => s.technicianId.isNotEmpty).toList();
                return SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: withTechnician.length,
                    itemBuilder: (context, index) {
                      final service = withTechnician[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: InkWell(onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                  serviceId: service.id,
                                  serviceName: service.name,
                                  serviceDescription: service.description,
                                  servicePrice: service.price.toDouble(),
                                  serviceImage: service.imageUrl,
                                  technicianId: service.technicianId,
                                  serviceType: service.type,
                                ),
                              ),
                            );

                        },
                          child: Column(
                            children: [
                              Image.network(
                                service.imageUrl,
                                height: 80,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                service.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                service.description,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Error: $e"),
            ),

            const SizedBox(height: 16),

            // 🔹 Popular Suppliers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Popular Suppliers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            suppliersAsync.when(
              data: (suppliers) {
                if (suppliers.isEmpty) {
                  return SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        "No suppliers yet",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: suppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = suppliers[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: supplier.logoUrl.isNotEmpty
                            ? Image.network(
                                supplier.logoUrl,
                                height: 60,
                                width: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 60,
                                  width: 80,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.store, color: Colors.grey[400]),
                                ),
                              )
                            : Container(
                                height: 60,
                                width: 80,
                                color: Colors.grey[200],
                                child: Icon(Icons.store, color: Colors.grey[400]),
                              ),
                      );
                    },
                  ),
                );
              },
              loading: () => SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    "Unable to load suppliers",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
