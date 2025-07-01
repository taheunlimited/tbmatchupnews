import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:matchupnews/views/utils/helper.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController readTimeController = TextEditingController();

  String? selectedCategory;
  final List<String> categories = ['Politics', 'Technology', 'Health', 'Sports'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      appBar: AppBar(
        backgroundColor: cBgDc,
        elevation: 0,
        leading: BackButton(color: cPrimary),
        title: Text(
          'Create New News',
          style: headline4.copyWith(color: cWhite, fontWeight: bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Text(
                  'News Details',
                  style: subtitle2.copyWith(color: cWhite, fontWeight: bold),
                ),
                SizedBox(height: 12),

                // Title Field
                TextFormField(
                  controller: titleController,
                  decoration: _inputDecoration('Title'),
                  style: TextStyle(color: cWhite),
                  validator: (value) =>
                      value == null || value.length < 5 ? 'Title must be at least 5 characters' : null,
                ),
                SizedBox(height: 12),

                // Image URL
                TextFormField(
                  controller: imageUrlController,
                  decoration: _inputDecoration('Image URL'),
                  style: TextStyle(color: cWhite),
                  validator: (value) =>
                      value == null || !value.startsWith('http') ? 'Enter valid image URL' : null,
                ),
                SizedBox(height: 12),

                // Read Time
                TextFormField(
                  controller: readTimeController,
                  decoration: _inputDecoration('Read Time (e.g. 5 min)'),
                  style: TextStyle(color: cWhite),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter read time' : null,
                ),
                SizedBox(height: 12),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, style: TextStyle(color: cWhite)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                  dropdownColor: cBoxDc,
                  iconEnabledColor: cWhite,
                  decoration: _inputDecoration('Category'),
                  style: TextStyle(decorationColor: cWhite),
                  validator: (val) => val == null ? 'Select category' : null,
                ),
                SizedBox(height: 12),

                // Content Field
                TextFormField(
                  controller: contentController,
                  decoration: _inputDecoration('Content'),
                  style: TextStyle(color: cWhite),
                  maxLines: 6,
                  validator: (value) =>
                      value == null || value.length < 100
                          ? 'Content must be at least 100 characters'
                          : null,
                ),

                SizedBox(height: 24),

                // Publish Button
                ElevatedButton(
                  onPressed: _publishNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Publish Now',
                    style: subtitle1.copyWith(color: cWhite, fontWeight: bold),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _publishNews() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must login to add news")),
        );
        return;
      }

      final url = Uri.parse('https://rest-api-berita.vercel.app/api/v1/news');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': titleController.text,
          'category': selectedCategory,
          'readTime': readTimeController.text,
          'imageUrl': imageUrlController.text,
          'content': contentController.text,
          'tags': ['flutter', 'news'],
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201 && responseData['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context, true); // Trigger refresh di HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News added successfully!")),
        );
      } else {
        print("Upload failed: ${response.body}");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add news: ${responseData['message']}")),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cWhite),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: cPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    imageUrlController.dispose();
    readTimeController.dispose();
    super.dispose();
  }
}
