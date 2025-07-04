import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:matchupnews/views/edit_news_screen.dart';
import 'package:matchupnews/views/utils/client_internet_api.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String featuredImageUrl;
  final String category;
  final String publishedAt;

  const NewsDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.featuredImageUrl,
    required this.category,
    required this.publishedAt,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  late String title;
  late String content;
  late String imageUrl;
  late String category;
  late String summary;

  String? token;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    content = widget.content;
    imageUrl = widget.featuredImageUrl;
    category = widget.category;
    summary = widget.summary;
    _loadToken();
    _fetchDetailNews();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> _fetchDetailNews() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final result = await ClientInternetApi.detailNews(widget.slug);

    if (!mounted) return;

    if (result['success'] == true) {
      final news = result['data'];

      setState(() {
        title = news['title'];
        content = news['content'];
        imageUrl = news['featured_image_url'];
        category = news['category'];
        summary = news['summary'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${result['message'] ?? 'Unknown error'}")),
      );
    }
  }

  Future<void> _navigateToEdit() async {
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
          articleId: widget.id,
          title: title,
          content: content,
          featuredImageUrl: imageUrl,
          publishedAt: widget.publishedAt,
          category: category,
          summary: summary,
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
        summary = updated['summary'];
      });

      Navigator.pop(context, {
        'updated': true,
        'updatedArticle': {
          'articleId': widget.id,
          'title': updated['title'],
          'content': updated['content'],
          'imageUrl': updated['imageUrl'],
          'category': updated['category'],
          'publishedAt': widget.publishedAt,
          'summary': updated['summary'],
        }
      });
    }
  }

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
      final result = await ClientInternetApi.deleteNews(widget.id);
      if (!mounted) return;

   
      if (result['success'] == true) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("News deleted successfully")),
        );
        Navigator.pop(context, {'deleted': true});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${result['message'] ?? 'Unknown error'}")),
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
            ? [
                IconButton(
                  onPressed: _navigateToEdit,
                  icon: Icon(Icons.edit, color: cWhite),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context),
                  icon: Icon(Icons.delete, color: cError),
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
