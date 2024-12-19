import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/list_artikelentry.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MyHomePageBuyer extends StatefulWidget {
  const MyHomePageBuyer({super.key});

  @override
  State<MyHomePageBuyer> createState() => _MyHomePageBuyerState();
}

class _MyHomePageBuyerState extends State<MyHomePageBuyer> {
  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFB23A48); // Warna tema utama (merah)

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ManganYuk!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
      ),
      drawer: const LeftDrawer(role: "buyer"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Informasi dan Navigasi Buyer
            Expanded(
              child: ListView(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.list_alt, color: Colors.teal),
                      title: const Text("Lihat Produk"),
                      subtitle: const Text("Jelajahi daftar produk yang tersedia."),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FoodPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.article, color: Colors.teal),
                      title: const Text("Lihat Artikel"),
                      subtitle: const Text("Baca artikel menarik dan informatif."),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ArtikelPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                final request = context.read<CookieRequest>();
                logout(request, context);
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(CookieRequest request, BuildContext context) async {
    try {
      final response =
          await request.get('http://127.0.0.1:8000/auth/logout-flutter/');
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout berhasil')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal logout: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
