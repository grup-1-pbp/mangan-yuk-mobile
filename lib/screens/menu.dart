import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/widgets/product_card.dart';
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart'; // Import the foodentry_form.dart page
import 'package:mangan_yuk_mobile/screens/artikelentry_form.dart'; // Import the foodentry_form.dart page

class ItemHomepage {
  final String title;
  final IconData icon;
  final Color color;

  ItemHomepage(this.title, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        onTap: () {
          if (item.title == "Lihat Daftar Produk") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FoodPage()),
            );
          } else if (item.title == "Tambah Produk") {
            // Navigate to the food entry form page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FoodEntryFormPage()),
            );
            
          }
          else if (item.title == "Tambah Artikel") {
            // Navigate to the food entry form page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArtikelEntryFormPage()),
            );
            
          } 
          else if (item.title == "Logout") {
            // Handle logout
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

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key) {
    // Initialize items in the constructor
    items.addAll([
      ItemHomepage(
          "Lihat Daftar Produk", Icons.card_giftcard, Colors.deepOrange.shade400),
      ItemHomepage("Tambah Produk", Icons.add, Colors.pink.shade200),
      ItemHomepage("Tambah Artikel", Icons.add, Colors.pink.shade200),
      ItemHomepage("Logout", Icons.logout, Colors.red.shade200),
    ]);
  }

  final String npm = '2306275651';
  final String name = 'Athallah Nadhif Yuzak';
  final String className = 'PBP B';
  
  final List<ItemHomepage> items = [];

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
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: className),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Mangan yuk!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      primary: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: items.map((ItemHomepage item) {
                        return ItemCard(item);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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