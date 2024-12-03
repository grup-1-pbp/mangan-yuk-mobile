import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/models/artikel_entry.dart';

class EditArtikelFormPage extends StatefulWidget {
  final ArtikelEntry artikel;

  const EditArtikelFormPage({super.key, required this.artikel});

  @override
  State<EditArtikelFormPage> createState() => _EditArtikelFormPageState();
}

class _EditArtikelFormPageState extends State<EditArtikelFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _judul;
  late String _isi;
  late String _gambarUrl;

  // Daftar preference yang valid
  final List<String> _validPreferences = ['Indo', 'Chin', 'West'];

  @override
  void initState() {
    super.initState();
    _judul = widget.artikel.fields.judul;
    _isi = widget.artikel.fields.isi;

    _gambarUrl = widget.artikel.fields.gambarUrl ?? '';
  }

  Future<void> updateArtikel(CookieRequest request) async {
    final url = 'http://127.0.0.1:8000/artikel/update-artikel/';
    try {
      final response = await request.postJson(
        url,
        jsonEncode(<String, dynamic>{
          'id': widget.artikel.pk,
          'judul': _judul,
          'isi': _isi,
          'gambar_url': _gambarUrl,
        }),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("artikel updated successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update artikel.")),
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
        title: const Text("Edit artikel"),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // judul Field
              TextFormField(
                initialValue: _judul,
                decoration: InputDecoration(
                  labelText: "Judul Artikel",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _judul = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "judul tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // isi Field
              TextFormField(
                initialValue: _isi,
                decoration: InputDecoration(
                  labelText: "isi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _isi = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "isi tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // gambar URL Field
              TextFormField(
                initialValue: _gambarUrl,
                decoration: InputDecoration(
                  labelText: "URL Gambar",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _gambarUrl = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "URL tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Update Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateArtikel(request);
                    }
                  },
                  child: const Text("Update artikel"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
