import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:mangan_yuk_mobile/widgets/bookmark_button.dart';
import 'package:mangan_yuk_mobile/models/bookmark_model.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodEntry food;

  const FoodDetailPage({super.key, required this.food});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (widget.food.imageUrl != null && widget.food.imageUrl.isNotEmpty)
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.food.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.food.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                BookmarkButton(
                  foodId: widget.food.id,
                  isBookmarked: widget.food.isBookmarked,
                  onToggle: (isBookmarked) {
                    setState(() {
                      widget.food.isBookmarked = isBookmarked;
                      BookmarkModel.toggleBookmark(widget.food);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
           
            Text(
              "Restaurant: ${widget.food.restaurant}",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Description: ${widget.food.deskripsi}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Price: Rp${widget.food.price}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Preference: ${widget.food.preference}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back to List"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
