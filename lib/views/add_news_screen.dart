import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:matchupnews/views/utils/client_internet_api.dart';
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
  final TextEditingController summary = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  bool isPublished = true;

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

                // Summary Field
                SizedBox(height: 12),
                TextFormField(
                  controller: summary,
                  decoration: _inputDecoration('Summary'),
                  style: TextStyle(color: cWhite),
                  maxLines: 2,
                  validator: (value) =>
                      value == null || value.length < 10 ? 'Summary must be at least 10 characters' : null,
                ),

                // Tags Field
                SizedBox(height: 12),
                TextFormField(
                  controller: tagsController,
                  decoration: _inputDecoration('Tags (comma separated)'),
                  style: TextStyle(color: cWhite),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter at least one tag' : null,
                ),

                // Is Published Checkbox
                SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: isPublished,
                      onChanged: (value) {
                        setState(() {
                          isPublished = value ?? true;
                        });
                      },
                      activeColor: cPrimary,
                    ),
                    Text(
                      'Published',
                      style: TextStyle(color: cWhite),
                    ),
                  ],
                ),
                // Image URL
                TextFormField(
                  controller: imageUrlController,
                  decoration: _inputDecoration('Image URL'),
                  style: TextStyle(color: cWhite),
                  validator: (value) =>
                      value == null || !value.startsWith('http') ? 'Enter valid image URL' : null,
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
                      value == null || value.length < 20
                          ? 'Content must be at least 20 characters'
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

      final responseData = await ClientInternetApi.postNews(
        {
          'title': titleController.text,
          'category': selectedCategory,
          'featuredImageUrl': imageUrlController.text,
          'summary': summary.text,
          'content': contentController.text,
          'tags': tagsController.text.split(',').map((e) => e.trim()).toList(),
          'isPublished': isPublished,
        },
      );


      if (responseData['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context, true); // Trigger refresh di HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News added successfully!")),
        );
      } else {
        print("Upload failed: ${responseData}");
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
    summary.dispose();
    tagsController.dispose();
    super.dispose();
  }

}
