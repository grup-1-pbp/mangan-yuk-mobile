import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntry product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.fields.goldName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.fields.goldName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text("Description: ${product.fields.description}"),
            const SizedBox(height: 8),
            Text("Price: \$${product.fields.price}"),
            const SizedBox(height: 8),
            Text("Quantity: ${product.fields.quantity}"),
            const SizedBox(height: 8),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back to List"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}