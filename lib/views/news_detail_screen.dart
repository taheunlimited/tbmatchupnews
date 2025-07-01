import 'dart:convert'; // 🔹 DITAMBAHKAN
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http; // 🔹 DITAMBAHKAN
import 'package:matchupnews/views/edit_news_screen.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔹 DITAMBAHKAN

class NewsDetailScreen extends StatefulWidget {
  final String articleId;
  final String title;
  final String content;
  final String imageUrl;
  final String publishedAt;
  final String category;
  final String readTime;

  const NewsDetailScreen({
    super.key,
    required this.articleId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.category,
    required this.readTime,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late String title;
  late String content;
  late String imageUrl;
  late String category;
  late String readTime;

  String? token;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    content = widget.content;
    imageUrl = widget.imageUrl;
    category = widget.category;
    readTime = widget.readTime;
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> _navigateToEdit() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to Edit News")),
      );
      return;
    }
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNewsScreen(
          articleId: widget.articleId,
          title: title,
          content: content,
          imageUrl: imageUrl,
          publishedAt: widget.publishedAt,
          category: category,
          readTime: readTime,
        ),
      ),
    );

    if (result != null && result['updated'] == true) {
      final updated = result['updatedArticle'];
      setState(() {
        title = updated['title'];
        content = updated['content'];
        imageUrl = updated['imageUrl'];
        category = updated['category'];
        readTime = updated['readTime'];
      });

      Navigator.pop(context, {
        'updated': true,
        'updatedArticle': {
          'articleId': widget.articleId,
          'title': updated['title'],
          'content': updated['content'],
          'imageUrl': updated['imageUrl'],
          'category': updated['category'],
          'publishedAt': widget.publishedAt,
          'readTime': updated['readTime'],
        }
      });
    }
  }

  // 🔹 DITAMBAHKAN: Fungsi konfirmasi delete
  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cBoxDc,
        title: const Text("Confirm Delete", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure about that?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("No", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Yes", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must login to delete this")),
        );
        return;
      }

      final url = Uri.parse('https://rest-api-berita.vercel.app/api/v1/news/${widget.articleId}');
      final resp = await http.delete(url, headers: {
        'Authorization': 'Bearer $token',
      });

      final data = jsonDecode(resp.body);
      if (resp.statusCode == 200 && data['success'] == true) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News deleted successfully")),
        );
        Navigator.pop(context, {'deleted': true}); // 🔹 Kembali ke Home dengan status deleted
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${data['message'] ?? 'Unknown error'}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      appBar: AppBar(
        backgroundColor: cBgDc,
        title: Text(
          title,
          style: TextStyle(color: cWhite),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: IconThemeData(color: cWhite),
        actions: token != null 
            ?[
              IconButton(
                onPressed: _navigateToEdit, 
                icon: Icon(Icons.edit, color: cWhite),
              ),
              IconButton(
                onPressed: () => _confirmDelete(context), 
                icon: Icon(Icons.delete,color: cError),
              ),
              ]
            : [],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180.h,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: cWhite,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.publishedAt,
                style: TextStyle(color: cWhite.withOpacity(0.7), fontSize: 12.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                content,
                style: TextStyle(fontSize: 14.sp, color: cWhite, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
