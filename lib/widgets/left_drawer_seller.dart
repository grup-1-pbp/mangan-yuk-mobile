import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart'; // Daftar Product
import 'package:mangan_yuk_mobile/screens/foodentry_form.dart'; // Tambah Product
import 'package:mangan_yuk_mobile/screens/login.dart'; // Logout

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: isCollapsed ? 80 : 250, // Mengatur lebar drawer
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: isCollapsed
                ? CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'John Smith',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Dashboard',
                        style: TextStyle(color: Colors.yellow, fontSize: 16),
                      ),
                    ],
                  ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              children: [
                // Daftar Product
                _buildDrawerItem(
                  context,
                  icon: Icons.list_alt,
                  title: 'Daftar Product',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FoodPage()),
                    );
                  },
                ),

                // Tambah Product
                _buildDrawerItem(
                  context,
                  icon: Icons.add_box_outlined,
                  title: 'Tambah Product',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FoodEntryFormPage()),
                    );
                  },
                ),

                // Logout
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Collapse Button
          ListTile(
            title: Text(isCollapsed ? '' : 'Collapse', style: const TextStyle(fontSize: 16)),
            leading: Icon(isCollapsed ? Icons.arrow_forward : Icons.arrow_back),
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk membuat item pada drawer
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: isCollapsed ? null : Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
