import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  Future<List<FoodEntry>> fetchFood(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/json/');
    
      // Debug print untuk melihat response
      print('Response: $response');
  
      // Pastikan response adalah List
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
        backgroundColor: Colors.teal, // Menyesuaikan warna AppBar
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
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
                      // Gambar Makanan dengan border radius dan efek shadow
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          snapshot.data![index].fields.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama Makanan yang lebih besar dan bold
                      Text(
                        snapshot.data![index].fields.name,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Menambahkan styling untuk detail makanan
                      Text(
                        "Restaurant: ${snapshot.data![index].fields.restaurant}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Description: ${snapshot.data![index].fields.deskripsi}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Price: \$${snapshot.data![index].fields.price}",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Preference: ${snapshot.data![index].fields.preference}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tombol Edit dan Delete
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tombol Edit
                          ElevatedButton(
                            onPressed: () {
                              // Logika untuk edit makanan, bisa pindah ke halaman edit
                              // misalnya Navigator.push(context, MaterialPageRoute(builder: (context) => EditFoodPage(food: snapshot.data![index])));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal, // Ganti 'primary' dengan 'backgroundColor'
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Edit"),
                          ),

                          // Tombol Delete
                          ElevatedButton(
                            onPressed: () {
                              // Konfirmasi sebelum menghapus
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Food"),
                                    content: const Text("Are you sure you want to delete this food item?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Delete"),
                                        onPressed: () {
                                          // Logika untuk menghapus item, misalnya memanggil API delete
                                          // Misalnya: deleteFood(snapshot.data![index].id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Ganti 'primary' dengan 'backgroundColor'
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
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
