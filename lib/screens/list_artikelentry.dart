import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/artikel_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/screens/edit_artikel_form.dart';
import 'package:mangan_yuk_mobile/screens/artikelentry_form.dart';

class ArtikelPage extends StatefulWidget {
  final String username;
  const ArtikelPage({super.key, required this.username});

  @override
  State<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  Future<List<ArtikelEntry>> fetchArtikel(CookieRequest request) async {
    try {
      final response = await request.get('https://mangan-yuk-production.up.railway.app/artikel/artikel-json/');
      if (response is! List) return [];
      return response.map((data) => ArtikelEntry.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching artikel: $e');
      return [];
    }
  }

  Future<void> deleteArtikel(CookieRequest request, String id) async {
    try {
      final response = await request.postJson(
        'https://mangan-yuk-production.up.railway.app/artikel/delete-artikel-flutter/',
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
        title: const Text('Artikel List'),
        backgroundColor: const Color(0xFFB23A48),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArtikelEntryFormPage()),
              );
            },
          ),
        ],
      ),
      drawer:  LeftDrawer(role: "unknown", username: widget.username ),
      body: FutureBuilder<List<ArtikelEntry>>(
        future: fetchArtikel(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No Artikel Data Available',
                    style: TextStyle(fontSize: 20, color: Color(0xffB23A48)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ArtikelEntryFormPage()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Artikel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB23A48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              const SizedBox(height: 20), // Spacing between header and content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ArtikelEntryFormPage()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Artikel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacing after button
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    final artikel = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Artikel
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              artikel.fields.gambarUrl,
                              height: 300, // Larger image height
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Judul Artikel
                                Text(
                                  artikel.fields.judul,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB23A48),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Isi Artikel
                                Text(
                                  artikel.fields.isi,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Tombol Aksi
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditArtikelFormPage(artikel: artikel),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit, color: Colors.teal),
                                      tooltip: 'Edit Artikel',
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Delete Artikel"),
                                              content: const Text(
                                                  "Are you sure you want to delete this artikel?"),
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
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: 'Delete Artikel',
                                    ),
                                  ],
                                ),
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
          );
        },
      ),
    );
  }
}
