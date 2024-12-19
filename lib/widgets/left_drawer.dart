import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/bookmark_list_screen.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/menu.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
import 'package:mangan_yuk_mobile/screens/list_artikelentry.dart';
import 'package:mangan_yuk_mobile/screens/artikelentry_form.dart';

class LeftDrawer extends StatelessWidget {
  final String role;

  const LeftDrawer({super.key, required this.role});

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
                  'ManganYuk!',
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Main Menu'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          // Tampilkan hanya jika role bukan "buyer"
          if (role == "seller")
            ListTile(
              leading: const Icon(Icons.add_reaction_rounded),

              /// ini ganti jadi ke buyer list ya jangan ke seller list
              title: const Text('Daftar Produk'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ganti jadi list yang dibuat abby 
                    builder: (context) => const FoodPage(),
                  ),
                );
              },
            ),
          if (role == "buyer")
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('Daftar Artikel'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArtikelPage(),
                ),
              );
            },
          ),
          if (role != "seller")
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('My Saved Foods'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarkListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
