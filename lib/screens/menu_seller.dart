import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:mangan_yuk_mobile/models/profile.dart';
import 'package:mangan_yuk_mobile/screens/edit_food_form.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer_seller.dart';

class MyHomePageSeller extends StatefulWidget {
  const MyHomePageSeller({super.key});

  @override
  State<MyHomePageSeller> createState() => _MyHomePageSellerState();
}

class _MyHomePageSellerState extends State<MyHomePageSeller> {
  late Future<Profile> _profileData;
  List<FoodEntry> allFoods = [];
  List<FoodEntry> filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final themeColor = const Color(0xFFB23A48);

  Future<Profile> fetchUserProfile(CookieRequest request) async {
    try {
      final response = await request.get("http://127.0.0.1:8000/auth/user_profile/");
      if (response['status'] == 'success' && response['data'] != null) {
        return Profile.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Invalid response format');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
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

  void filterFoods() {
    setState(() {
      filteredFoods = allFoods.where((food) {
        final matchesName = food.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesDescription = food.deskripsi.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesName || matchesDescription;
      }).toList();
    });
  }

  Future<void> _loadFoods() async {
    final request = context.read<CookieRequest>();
    try {
      final foods = await fetchFoods(request);
      setState(() {
        allFoods = foods;
        filteredFoods = foods;
      });
    } catch (e) {
      print("Error loading foods: $e");
    }
  }

  Future<void> deleteFood(CookieRequest request, String id) async {
    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/delete-product-flutter/',
        jsonEncode({'id': id}),
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food deleted successfully!")),
        );
        _loadFoods();
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
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _profileData = fetchUserProfile(request);
    _loadFoods();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
        filterFoods();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('ManganYuk! Seller'),
      backgroundColor: themeColor,
    ),
    drawer: const CustomDrawer(),
    body: FutureBuilder<Profile>(
      future: _profileData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final profile = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                // **Header Section**
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile.profileImage),
                        backgroundColor: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.role.toUpperCase(),
                        style: const TextStyle(color: Colors.amber, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // **Tombol Add New Food**
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FoodEntryFormPage()),
                      ).then((_) => _loadFoods());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Food"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // **Filter & List Container with White Background**
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // **Search Bar**
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search by name or description...",
                            prefixIcon: const Icon(Icons.search, color: Color(0xFFB23A48)),
                            filled: true,
                            fillColor: const Color(0xFFFBE8E7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      // **Food List**
                      filteredFoods.isEmpty
                          ? const Center(
                              child: Text(
                                'No foods available.',
                                style: TextStyle(fontSize: 18, color: Color(0xFFB23A48)),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredFoods.length,
                              itemBuilder: (context, index) {
                                final food = filteredFoods[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // **Food Image**
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
                                      // **Food Details**
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
                                              // Action Buttons
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EditFoodFormPage(food: food),
                                                        ),
                                                      ).then((_) => _loadFoods());
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
                                                                "Are you sure you want to delete this food?"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.pop(context),
                                                                child: const Text("Cancel"),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                  deleteFood(
                                                                      context.read<CookieRequest>(), food.id);
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
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}
}