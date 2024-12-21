import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/bookmark_list_screen.dart';
import 'package:mangan_yuk_mobile/screens/buyer_list.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/menu.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
import 'package:mangan_yuk_mobile/screens/list_artikelentry.dart';
import 'package:mangan_yuk_mobile/screens/artikelentry_form.dart';
import 'package:mangan_yuk_mobile/screens/login.dart'; // Logout

class LeftDrawer extends StatefulWidget {
  final String role;
  final String username;

  const LeftDrawer({
    super.key,
    required this.role,
    required this.username,
  });

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  late final String uname; // Nilai uname hanya ditentukan sekali

  @override
  void initState() {
    super.initState();
    uname = widget.username; // Tetapkan uname hanya sekali
    print("uname initialized: $uname"); // Debug log
  }

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
                MaterialPageRoute(
                  builder: (context) =>
                      FoodBuyerPage(username: uname), // Gunakan uname
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
                  builder: (context) =>  ArtikelPage(username: uname),
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
                  builder: (context) =>
                      BookmarkListScreen(username: uname), // Gunakan uname
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
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
