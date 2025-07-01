import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matchupnews/views/utils/helper.dart';

class EditNewsScreen extends StatefulWidget {
  final String articleId;
  final String title;
  final String imageUrl;
  final String publishedAt;
  final String readTime;
  final String category;
  final String content;

  const EditNewsScreen({
    super.key,
    required this.articleId,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
    required this.readTime,
    required this.category,
    required this.content,
  });

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController imageUrlController;
  late TextEditingController readTimeController;
  String? selectedCategory;

  final List<String> categories = ['Politics', 'Technology', 'Health', 'Sports'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    imageUrlController = TextEditingController(text: widget.imageUrl);
    readTimeController = TextEditingController(text: widget.readTime);
    selectedCategory = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      appBar: AppBar(
        backgroundColor: cBgDc,
        elevation: 0,
        leading: BackButton(color: cPrimary),
        title: Text('Edit News', style: headline4.copyWith(color: cWhite, fontWeight: bold)),
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
                Text('Edit News Details', style: subtitle2.copyWith(color: cWhite, fontWeight: bold)),
                SizedBox(height: 12),

                TextFormField(
                  controller: titleController,
                  decoration: _inputDecoration('Title'),
                  style: TextStyle(color: cWhite),
                  validator: (value) => value == null || value.length < 5 ? 'Title must be at least 5 characters' : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: imageUrlController,
                  decoration: _inputDecoration('Image URL'),
                  style: TextStyle(color: cWhite),
                  validator: (value) => value == null || !value.startsWith('http') ? 'Enter valid image URL' : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: readTimeController,
                  decoration: _inputDecoration('Read Time (e.g. 5 min)'),
                  style: TextStyle(color: cWhite),
                  validator: (value) => value == null || value.isEmpty ? 'Enter read time' : null,
                ),
                SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, style: TextStyle(color: cWhite)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCategory = val),
                  dropdownColor: cBoxDc,
                  iconEnabledColor: cWhite,
                  decoration: _inputDecoration('Category'),
                  style: TextStyle(decorationColor: cWhite),
                  validator: (val) => val == null ? 'Select category' : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: contentController,
                  decoration: _inputDecoration('Content'),
                  style: TextStyle(color: cWhite),
                  maxLines: 6,
                  validator: (value) => value == null || value.length < 100 ? 'Content must be at least 100 characters' : null,
                ),
                SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _updateNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Update News', style: subtitle1.copyWith(color: cWhite, fontWeight: bold)),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateNews() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You must login to update news")));
        return;
      }

      final url = Uri.parse('https://rest-api-berita.vercel.app/api/v1/news/${widget.articleId}');
      final body = jsonEncode({
        'title': titleController.text,
        'category': selectedCategory,
        'readTime': readTimeController.text,
        'imageUrl': imageUrlController.text,
        'content': contentController.text,
        'tags': ['flutter', 'news'],
        'isTrending': true,
      });

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context, {
          'updated': true,
          'updatedArticle': {
            'title': titleController.text,
            'content': contentController.text,
            'imageUrl': imageUrlController.text,
            'category': selectedCategory,
            'readTime': readTimeController.text,
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("News updated successfully!")));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: ${responseData['message'] ?? 'Unknown error'}")));
      }
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cWhite),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: cPrimary), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cPrimary), borderRadius: BorderRadius.circular(8)),
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
