import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodEntry food;

  const FoodDetailPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text("Restaurant: ${food.restaurant}"),
            const SizedBox(height: 8),
            Text("Description: ${food.deskripsi}"),
            const SizedBox(height: 8),
            Text("Price: \$${food.price}"),
            const SizedBox(height: 8),
            Text("Preference: ${food.preference}"),
            const SizedBox(height: 16),
            if (food.imageUrl.isNotEmpty)
              Image.network(food.imageUrl),
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