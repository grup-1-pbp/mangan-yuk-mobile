import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/screens/food_detail_page.dart';

class FoodBuyerPage extends StatefulWidget {
  final String username;
  const FoodBuyerPage({super.key, required this.username});

  @override
  State<FoodBuyerPage> createState() => _FoodBuyerPageState();
}

class _FoodBuyerPageState extends State<FoodBuyerPage> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodEntry> _allFoods = [];
  List<FoodEntry> _filteredFoods = [];
  bool _isLoading = true;
  bool _isError = false;

  // Desired categories
  final List<String> categories = [
    "All",
    "Indonesian",
    "Chinese",
    "Western",
    "Japanese"
  ];
  String selectedCategory = "All";

  Future<List<FoodEntry>> fetchFood(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/json/');

      if (response is! List) {
        print(
            'Invalid response format. Expected List, got: ${response.runtimeType}');
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

  String mapPreferenceToCategory(Preference preference) {
    switch (preference) {
      case Preference.CHIN:
      case Preference.CHINESE:
        return "Chinese";
      case Preference.INDO:
      case Preference.INDONESIA:
        return "Indonesian";
      case Preference.JAPANESE:
      case Preference.JEPANG:
        return "Japanese";
      case Preference.PREFERENCE_WESTERN:
      case Preference.WEST:
      case Preference.WESTERN:
        return "Western";
      case Preference.INDIAN:
        return "Indian";
    }
  }

  void _filterFoods() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      List<FoodEntry> filtered = _allFoods;

      if (query.isNotEmpty) {
        filtered = filtered
            .where((food) =>
                food.name.toLowerCase().contains(query) ||
                food.restaurant.toLowerCase().contains(query))
            .toList();
      }

      if (selectedCategory != "All") {
        filtered = filtered
            .where((food) =>
                mapPreferenceToCategory(food.preference).toLowerCase() ==
                selectedCategory.toLowerCase())
            .toList();
      }

      _filteredFoods = filtered;
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

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _filterFoods();
    });
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
        backgroundColor: Color(0xFFB23A48),
      ),
      drawer:  LeftDrawer(role: "unknown", username: widget.username),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isError
              ? const Center(
                  child: Text('Error loading food. Please try again later.'),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: categories.map((category) {
                            final isSelected = category == selectedCategory;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Color(0xFFB23A48),
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  if (selected) {
                                    _onCategorySelected(category);
                                  }
                                },
                                selectedColor: Color(0xFFB23A48),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFFB23A48)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _filteredFoods.isEmpty
                          ? const Center(
                              child: Text(
                                'No food available.',
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xff59A5D8)),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: _filteredFoods.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, index) {
                                final food = _filteredFoods[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodDetailPage(food: food, username: widget.username),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          child: SizedBox(
                                            height: 180.0,
                                            width: double.infinity,
                                            child: Image.network(
                                              food.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[200],
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                food.name,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFB23A48),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Restaurant: ${food.restaurant}",
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Price: \$${food.price}",
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFB23A48),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
