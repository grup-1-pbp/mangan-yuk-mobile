import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/menu.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
    ),
    child: const Column(
      children: [
        Text(
          'Toko Emas 86',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
        Text(
          "Ayo jual beli emas ditempat yang aman dan nyaman!",
          // TODO: Tambahkan gaya teks dengan center alignment, font ukuran 15, warna putih, dan weight biasa
        ),
      ],
    ),
          ),
            ListTile(
    leading: const Icon(Icons.home_outlined),
    title: const Text('Main Menu'),
    // Bagian redirection ke MyHomePage
    onTap: () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
    },
  ),
  ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Tambah Produk'),
              // Bagian redirection ke 
              onTap: () {
                Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => const GoldEntryFormPage(),
                ));
              },
            ),

            ListTile(
    leading: const Icon(Icons.add_reaction_rounded),

    title: const Text('Daftar Product'),
    onTap: () {
        // Route menu ke halaman mood
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductEntryPage()),
        );
    },
),
        ],
      ),
    );
  }
}