import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';

class MyHomePageBuyer extends StatefulWidget {
  final String username;
  const MyHomePageBuyer({super.key, required this.username});

  @override
  State<MyHomePageBuyer> createState() => _MyHomePageBuyerState();
}

class _MyHomePageBuyerState extends State<MyHomePageBuyer> {
  List<FoodEntry> allFoods = [];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final request = context.read<CookieRequest>();
    try {
      final foods = await fetchFoods(request);
      setState(() {
        allFoods = foods;
      });
    } catch (e) {
      print("Error loading foods: $e");
    }
  }

  Future<List<FoodEntry>> fetchFoods(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/json/');
      if (response is! List) return [];
      return response.map((data) => FoodEntry.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching foods: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFB23A48);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Mangan Yuk!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
      drawer:  LeftDrawer(role: 'buyer', username: widget.username),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card that holds the image as a background
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background1.jpg'),
                      fit: BoxFit.cover, // fill the card area completely
                      alignment: Alignment.center,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Welcome to Mangan Yuk!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Food cards section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: allFoods.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text(
                          "No Foods Available",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: allFoods.length,
                      itemBuilder: (context, index) {
                        final food = allFoods[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  food.imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp${food.price}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      food.deskripsi,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
