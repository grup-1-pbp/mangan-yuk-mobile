import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/screens/artikelentry_form.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart';
import 'package:mangan_yuk_mobile/screens/buyer_list.dart';
import 'package:mangan_yuk_mobile/models/profile.dart';
import 'package:mangan_yuk_mobile/screens/login.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/screens/menu_buyer.dart';
import 'package:mangan_yuk_mobile/screens/menu_seller.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';

Future<Profile> fetchUserProfile(CookieRequest request) async {
  try {
    final response =
        await request.get("https://mangan-yuk-production.up.railway.app/auth/user_profile/");
    print("API RESPONSE: $response");

    if (response['status'] == 'success' && response['data'] != null) {
      return Profile.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Invalid response format');
    }
  } catch (e) {
    print("ERROR: $e");
    throw Exception('Error fetching user profile: $e');
  }
}

class ItemHomepage {
  final String title;
  final IconData icon;
  final Color color;

  ItemHomepage(this.title, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        onTap: () async {
          if (item.title == "Tambah Produk") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FoodEntryFormPage()),
            );
          } else if (item.title == "Daftar Product") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FoodPage()),
            );
          } else if (item.title == "Logout") {
            // Panggil fungsi logout
            final request = Provider.of<CookieRequest>(context, listen: false);
            await logout(request, context);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Fungsi logout
Future<void> logout(CookieRequest request, BuildContext context) async {
  try {
    final response =
        await request.get('https://mangan-yuk-production.up.railway.app/auth/logout-flutter/');
    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout berhasil')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Pastikan LoginPage sudah diimport
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Profile> _userProfile;

  final List<ItemHomepage> items = [
    ItemHomepage("Tambah Produk", Icons.add, Colors.pink.shade200),
    ItemHomepage("Lihat Product", Icons.article, Colors.pink.shade200),
    ItemHomepage("Logout", Icons.logout, Colors.red.shade200),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = Provider.of<CookieRequest>(context, listen: false);
      setState(() {
        _userProfile = fetchUserProfile(request);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mangan Yuk!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: FutureBuilder<Profile>(
        
        future: _userProfile,
        builder: (context, snapshot) {
            final user = snapshot.data!;
            return LeftDrawer(role: user.role, username: user.name);
          
        },
      ),
      body: FutureBuilder<Profile>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final user = snapshot.data!;
            if (user.role == "buyer") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengarahkan ke Buyer Page ')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePageBuyer(username: user.name,)),
                );
              });
            } else if (user.role == "seller") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengarahkan ke Seller Page')),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHomePageSeller()),
                );
              });
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(title: 'Name', content: user.name),
                      InfoCard(title: 'Role', content: user.role),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.profileImage),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: GridView.count(
                      primary: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: items.map((ItemHomepage item) {
                        return ItemCard(item);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}
