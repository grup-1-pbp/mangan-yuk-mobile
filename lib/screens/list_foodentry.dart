import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer_seller.dart';
import 'package:mangan_yuk_mobile/screens/edit_food_form.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodEntry> filteredFoods = [];
  List<FoodEntry> allFoods = [];
  bool isLoading = true;

  Future<List<FoodEntry>> fetchFood(CookieRequest request) async {
    try {
      final response = await request.get('https://mangan-yuk-production.up.railway.app/json/');
      if (response is! List) return [];
      return response.map((data) => FoodEntry.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching food: $e');
      return [];
    }
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredFoods = allFoods;
      });
      return;
    }

    setState(() => isLoading = true);

    // Simulasi pencarian async
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      filteredFoods = allFoods.where((food) {
        final matchesName = food.name.toLowerCase().contains(query.toLowerCase());
        final matchesDescription = food.deskripsi.toLowerCase().contains(query.toLowerCase());
        return matchesName || matchesDescription;
      }).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(() {
      performSearch(_searchController.text);
    });
  }

  Future<void> _loadFoods() async {
    final request = context.read<CookieRequest>();
    try {
      List<FoodEntry> foods = await fetchFood(request);
      setState(() {
        allFoods = foods;
        filteredFoods = foods;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading foods: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteFood(CookieRequest request, String id) async {
    try {
      final response = await request.postJson(
        'https://mangan-yuk-production.up.railway.app/delete-product-flutter/',
        jsonEncode({'id': id}),
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food deleted successfully!")),
        );
        _loadFoods(); // Reload the food list after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete food: ${response['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB23A48),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: "Search by name or description...",
                  filled: true,
                  fillColor: const Color(0xFFFBE8E7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredFoods.length,
              itemBuilder: (_, index) {
                final food = filteredFoods[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          food.imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB23A48),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                food.deskripsi,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Price: Rp${food.price}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditFoodFormPage(food: food),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.teal),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Delete Food"),
                                            content: const Text(
                                                "Are you sure you want to delete this food item?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  deleteFood(request, food.id);
                                                },
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
