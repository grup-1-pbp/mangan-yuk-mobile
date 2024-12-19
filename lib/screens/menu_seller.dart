import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/login.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer_seller.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyHomePageSeller extends StatefulWidget {
  const MyHomePageSeller({super.key});

  @override
  State<MyHomePageSeller> createState() => _MyHomePageSellerState();
}

class _MyHomePageSellerState extends State<MyHomePageSeller> {
  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFB23A48); // Warna tema utama (merah)

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ManganYuk! Seller',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Informasi dan Navigasi Seller
            Expanded(
              child: ListView(
                children: [
                  // Tombol Tambah Produk
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.add, color: Colors.teal),
                      title: const Text("Tambah Produk"),
                      subtitle: const Text("Tambahkan produk baru untuk dijual."),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FoodEntryFormPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Tombol Daftar Produk
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.list_alt, color: Colors.teal),
                      title: const Text("Daftar Produk"),
                      subtitle: const Text("Lihat daftar produk yang telah Anda tambahkan."),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FoodPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Tombol Logout
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

  // Fungsi Logout
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
