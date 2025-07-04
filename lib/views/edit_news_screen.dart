import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matchupnews/views/utils/client_internet_api.dart';
import 'package:matchupnews/views/utils/helper.dart';

class EditNewsScreen extends StatefulWidget {
  final String articleId;
  final String title;
  final String content;
  final String featuredImageUrl;
  final String publishedAt;
  final String category;
  final String summary;

  const EditNewsScreen({
    super.key,
    required this.articleId,
    required this.title,
    required this.content,
    required this.featuredImageUrl,
    required this.publishedAt,
    required this.category,
    required this.summary,
  });

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController imageUrlController;
  late TextEditingController summaryController;
  late TextEditingController tagsController;

  String? selectedCategory;
  bool isPublished = true;
  final List<String> categories = ['Politics', 'Technology', 'Health', 'Sports'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    imageUrlController = TextEditingController(text: widget.featuredImageUrl);
    summaryController = TextEditingController(text: widget.summary);
    tagsController = TextEditingController(text: 'flutter, news');
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
                const SizedBox(height: 24),
                Text('Edit News Details', style: subtitle2.copyWith(color: cWhite, fontWeight: bold)),
                const SizedBox(height: 12),

                TextFormField(
                  controller: titleController,
                  decoration: _inputDecoration('Title'),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.length < 5 ? 'Title must be at least 5 characters' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: summaryController,
                  decoration: _inputDecoration('Summary (optional)'),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: tagsController,
                  decoration: _inputDecoration('Tags (comma separated)'),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(
                      value: isPublished,
                      activeColor: cPrimary,
                      checkColor: cWhite,
                      onChanged: (val) => setState(() => isPublished = val ?? true),
                    ),
                    Text('Is Published', style: subtitle1.copyWith(color: cWhite)),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: imageUrlController,
                  decoration: _inputDecoration('Featured Image URL'),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || !value.startsWith('http') ? 'Enter valid image URL' : null,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCategory = val),
                  dropdownColor: cBoxDc,
                  iconEnabledColor: cWhite,
                  decoration: _inputDecoration('Category'),
                  style: const TextStyle(color: Colors.white),
                  validator: (val) => val == null ? 'Select category' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: contentController,
                  decoration: _inputDecoration('Content'),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 6,
                  validator: (value) =>
                      value == null || value.length < 20 ? 'Content must be at least 20 characters' : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _updateNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Update News', style: subtitle1.copyWith(color: cWhite, fontWeight: bold)),
                ),
                const SizedBox(height: 24),
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must login to update news")),
        );
        return;
      }

      final summaryText = summaryController.text.trim().isNotEmpty
          ? summaryController.text.trim()
          : (contentController.text.length >= 50
              ? contentController.text.substring(0, 50)
              : contentController.text);

      final responseData = await ClientInternetApi.putNews(widget.articleId, {
        'title': titleController.text,
        'category': selectedCategory,
        'content': contentController.text,
        'featuredImageUrl': imageUrlController.text,
        'summary': summaryText,
        'tags': tagsController.text.split(',').map((e) => e.trim()).toList(),
        'isPublished': isPublished,
      });

      if (!mounted) return;

      if (responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News updated successfully!")),
        );

        Navigator.pop(context, {
        'updated': true,
        'updatedArticle': {
          'id': widget.articleId,
          'title': titleController.text,
          'content': contentController.text,
          'imageUrl': imageUrlController.text,
          'category': selectedCategory,
          'summary': summaryText,
        }
      });
      print('Navigator berhasil');

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${responseData['message'] ?? 'Unknown error'}")),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
    summaryController.dispose();
    tagsController.dispose();
    super.dispose();
  }
}
