import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/artikel_entry.dart';

class ArtikelDetailPage extends StatelessWidget {
  final ArtikelEntry artikel;

  const ArtikelDetailPage({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB23A48), // Warna tema utama
        title: Text(
          artikel.fields.judul,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Artikel
            if (artikel.fields.gambarUrl != null && artikel.fields.gambarUrl!.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    artikel.fields.gambarUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            const SizedBox(height: 20),

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
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  artikel.fields.isi,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Kembali
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB23A48), // Warna tombol
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  "Back to List",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
