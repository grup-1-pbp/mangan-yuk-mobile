import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/artikel_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/screens/edit_artikel_form.dart';

class ArtikelPage extends StatefulWidget {
  const ArtikelPage({super.key});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  Future<List<ArtikelEntry>> fetchArtikel(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/artikel/artikel-json/');
      if (response is! List) {
        return [];
      }
      return response.map((data) => ArtikelEntry.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching artikel: $e');
      return [];
    }
  }

  Future<void> deleteArtikel(CookieRequest request, String id) async {
    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/artikel/delete-artikel-flutter/',
        jsonEncode({'id': id}),
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Artikel deleted successfully!")),
        );
        setState(() {}); // Refresh data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete artikel: ${response['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Entry List'),
        backgroundColor: Colors.teal,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchArtikel(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data Artikel tersedia.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              final artikel = snapshot.data[index];
              return Container(
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
                        artikel.gambarUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      artikel.judul,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Isi : ${artikel.isi}",
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditArtikelFormPage(artikel: artikel),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Edit"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete artikel"),
                                  content: const Text("Are you sure you want to delete this artikel item?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deleteArtikel(request, artikel.pk);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
              );
            },
          );
        },
      ),
    );
  }
}