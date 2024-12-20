import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/bookmark_list_screen.dart';
import 'package:mangan_yuk_mobile/screens/buyer_list.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/menu.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
import 'package:mangan_yuk_mobile/screens/list_artikelentry.dart';
import 'package:mangan_yuk_mobile/screens/artikelentry_form.dart';
import 'package:mangan_yuk_mobile/screens/login.dart'; // Logout


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
                  "Nikmati masakan khas Yogyakarta!",
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
          ListTile(
            leading: const Icon(Icons.food_bank),
            title: const Text('Daftar Menu'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                  MaterialPageRoute(builder: (context) => const FoodBuyerPage(),
                ),
              );
            },
          ),
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
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                  MaterialPageRoute(builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
