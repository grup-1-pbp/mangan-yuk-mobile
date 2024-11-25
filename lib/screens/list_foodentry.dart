import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
 Future<List<Food>> fetchFood(CookieRequest request) async {
  try {
    final response = await request.get('http://127.0.0.1:8000/json/');
    
    // Debug print untuk melihat response
    print('Response: $response');

    // Pastikan response adalah List
    if (response is! List) {
      print('Invalid response format. Expected List, got: ${response.runtimeType}');
      return [];
    }

    List<Food> listFood = [];
    for (var d in response) {
      try {
        if (d != null) {
          var food = Food.fromJson(d);
          listFood.add(food);
          print('Successfully parsed food: ${food.fields.name}'); // Debug print
        }
      } catch (e) {
        print('Error parsing food item: $e');
        print('Problematic data: $d'); // Debug print untuk melihat data yang bermasalah
      }
    }

    return listFood;
  } catch (e) {
    print('Error in fetchFood: $e');
    rethrow;
  }
}
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchFood(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada data Food tersedia.',
                  style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data![index].fields.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Restaurant: ${snapshot.data![index].fields.restaurant}"),
                      const SizedBox(height: 10),
                      Text(
                          "Description: ${snapshot.data![index].fields.description}"),
                      const SizedBox(height: 10),
                      Text("Price: ${snapshot.data![index].fields.price}"),
                      const SizedBox(height: 10),
                      Text(
                          "Preference: ${snapshot.data![index].fields.preference}"),
                      const SizedBox(height: 10),
                      Image.network(snapshot.data![index].fields.imageUrl),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
