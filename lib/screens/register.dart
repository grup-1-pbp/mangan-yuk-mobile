import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _budgetController = TextEditingController();
  final _profileImageController = TextEditingController();
  String? selectedRole; // Untuk melacak pilihan role

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12.0),

                  // Pilihan Role dengan RadioListTile
                  const Text(
                    'Select your role:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  RadioListTile<String>(
                    title: const Text('Buyer'),
                    value: 'buyer',
                    groupValue: selectedRole,
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Seller'),
                    value: 'seller',
                    groupValue: selectedRole,
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: 'Budget',
                      hintText: 'Enter your budget (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    controller: _profileImageController,
                    decoration: const InputDecoration(
                      labelText: 'Profile Image URL',
                      hintText: 'Enter a valid image URL (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () async {
                      String username = _usernameController.text;
                      String password1 = _passwordController.text;
                      String password2 = _confirmPasswordController.text;
                      String role = selectedRole ?? ''; // Ambil nilai dari radio button
                      int budget = int.tryParse(_budgetController.text) ?? 0;
                      String profileImage = _profileImageController.text;

                      if (role.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a role.'),
                          ),
                        );
                        return;
                      }

                      // Cek kredensial
                      final response = await request.postJson(
                          "http://127.0.0.1:8000/auth/register_app/",
                          jsonEncode({
                            "username": username,
                            "password1": password1,
                            "password2": password2,
                            "role": role,
                            "budget": budget,
                            "profile_image": profileImage.isEmpty
                                ? "https://tse3.mm.bing.net/th?id=OIP.lLmJV7N4bgAwEBtziWijSQHaJL&pid=Api&P=0&h=180"
                                : profileImage,
                          }));
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully registered!'),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(response['message'] ?? 'Failed to register!'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
