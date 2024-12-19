import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/screens/food_detail_page.dart'; // Import FoodDetailPage

class FoodBuyerPage extends StatefulWidget {
  const FoodBuyerPage({super.key});

  @override
  State<FoodBuyerPage> createState() => _FoodBuyerPageState();
}

class _FoodBuyerPageState extends State<FoodBuyerPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodEntry> _allFoods = [];
  List<FoodEntry> _filteredFoods = [];
  bool _isLoading = true;
  bool _isError = false;

  Future<List<FoodEntry>> fetchFood(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/json/');

      if (response is! List) {
        print('Invalid response format. Expected List, got: ${response.runtimeType}');
        return [];
      }

      List<FoodEntry> listFood = [];
      for (var d in response) {
        try {
          if (d != null) {
            var food = FoodEntry.fromJson(d);
            listFood.add(food);
          }
        } catch (e) {
          print('Error parsing food item: $e');
        }
      }

      return listFood;
    } catch (e) {
      print('Error in fetchFood: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(_filterFoods);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFoods() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredFoods = List.from(_allFoods);
      } else {
        _filteredFoods = _allFoods
            .where((food) =>
                food.name.toLowerCase().contains(query) ||
                food.restaurant.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _loadFoods() async {
    final request = context.read<CookieRequest>();
    try {
      List<FoodEntry> fetchedFoods = await fetchFood(request);
      setState(() {
        _allFoods = fetchedFoods;
        _filteredFoods = List.from(_allFoods);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search food...',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.teal,
      ),
      drawer: const LeftDrawer(role: "unknown"),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? const Center(
                  child: Text('Error loading food. Please try again later.'),
                )
              : _filteredFoods.isEmpty
                  ? const Center(
                      child: Text(
                        'No food available.',
                        style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredFoods.length,
                      itemBuilder: (_, index) {
                        final food = _filteredFoods[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigasi ke FoodDetailPage saat kartu ditekan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailPage(food: food),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8.0,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    food.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Restaurant: ${food.restaurant}",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Price: \$${food.price}",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
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
