import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:garage_management/src/model/supplierItem.dart'; // For animations
class BuyItemScreen extends StatefulWidget {
  final SupplierItem item;

  const BuyItemScreen({super.key, required this.item});

  @override
  State<BuyItemScreen> createState() => _BuyItemScreenState();
}

class _BuyItemScreenState extends State<BuyItemScreen> {
  int quantity = 1;
  bool isLoading = false;

  Future<void> _buyItem() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please log in to buy")));
      return;
    }

    setState(() => isLoading = true);

    final orderRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("orders")
        .doc();

    await orderRef.set({
      "itemId": widget.item.id,
      "itemName": widget.item.name,
      "quantity": quantity,
      "price": widget.item.price,
      "totalPrice": widget.item.price * quantity,
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });

    setState(() => isLoading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Purchase successful!")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buy ${widget.item.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(widget.item.imageUrl, height: 180, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              widget.item.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("${widget.item.motoType} - ${widget.item.model}"),
            Text("Price: ${widget.item.price} OMR"),
            const SizedBox(height: 16),

            // Quantity selector
            Row(
              children: [
                const Text("Quantity:"),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: quantity > 1
                      ? () => setState(() => quantity--)
                      : null,
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _buyItem,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Buy Now"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
