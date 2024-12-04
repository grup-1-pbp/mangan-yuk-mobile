import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:mangan_yuk_mobile/screens/list_foodentry.dart';

class EditFoodFormPage extends StatefulWidget {
  final FoodEntry food;

  const EditFoodFormPage({super.key, required this.food});

  @override
  State<EditFoodFormPage> createState() => _EditFoodFormPageState();
}

class _EditFoodFormPageState extends State<EditFoodFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _restaurant;
  late String _description;
  late double _price;
  late String _preference;
  late String _imageUrl;

  // Daftar preference yang valid
  final List<String> _validPreferences = ['Indo', 'Chin', 'West'];

  @override
  void initState() {
    super.initState();
    _name = widget.food.fields.name;
    _restaurant = widget.food.fields.restaurant;
    _description = widget.food.fields.deskripsi;
    _price = double.tryParse(widget.food.fields.price.toString()) ?? 0.0;

    // Validasi preference
    _preference = _validPreferences.contains(widget.food.fields.preference)
        ? widget.food.fields.preference
        : _validPreferences[0]; // Default ke 'Indo' jika tidak cocok

    _imageUrl = widget.food.fields.imageUrl ?? '';
  }

  Future<void> updateFood(CookieRequest request) async {
    final url = 'http://127.0.0.1:8000/update-food/';
    try {
      final response = await request.postJson(
        url,
        jsonEncode(<String, dynamic>{
          'id': widget.food.pk,
          'name': _name,
          'restaurant': _restaurant,
          'deskripsi': _description,
          'price': _price,
          'preference': _preference,
          'image_url': _imageUrl,
        }),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food updated successfully!")),
        );
        Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const FoodPage()),
                                );;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update food.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Food"),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: "Food Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Restaurant Field
              TextFormField(
                initialValue: _restaurant,
                decoration: InputDecoration(
                  labelText: "Restaurant",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _restaurant = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Restaurant tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description Field
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Price Field
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Price tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Dropdown for Preference
              DropdownButtonFormField<String>(
                value: _preference,
                decoration: InputDecoration(
                  labelText: "Preference",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _preference = value!;
                  });
                },
                items: _validPreferences.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Image URL Field
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _imageUrl = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Image URL tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Update Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateFood(request);
                    }
                  },
                  child: const Text("Update Food"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
