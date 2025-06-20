import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/add_news_screen.dart';
import 'package:matchupnews/views/bookmark_provider.dart';
import 'package:matchupnews/views/news_detail_screen.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class News {
  final String articleId;
  final String title;
  final String content;
  final String imageUrl;
  final String publishedAt;
  final String readTime;
  final String category;

  News({
    required this.articleId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.readTime,
    required this.category,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      articleId: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      readTime: json['readTime'] ?? '',
      category: json['category'] ?? '',
    );
  }

  News copyWith({
    String? title,
    String? content,
    String? imageUrl,
    String? category,
    String? readTime,
  }) {
    return News(
      articleId: articleId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt,
      readTime: readTime ?? this.readTime,
      category: category ?? this.category,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String? token;
  List<News> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _loadToken();
    _fetchArticles();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> _fetchArticles() async {
    try {
      final resp = await http.get(Uri.parse('https://rest-api-berita.vercel.app/api/v1/news?page=1&limit=10'));
      final jsonData = jsonDecode(resp.body);

      if (jsonData['success'] == true) {
        final list = jsonData['data']['articles'] as List<dynamic>;
        setState(() {
          articles = list.map((e) => News.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Fetch error: $e');
      setState(() => isLoading = false);
    }
  }

  void _handleAddNews() async {
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to add news")),
      );
    } else {
      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNewsScreen()));
      if (result == true) {
        _fetchArticles();
      }
    }
  }

  Future<void> _handleDetail(News article) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailScreen(
          articleId: article.articleId,
          title: article.title,
          content: article.content,
          imageUrl: article.imageUrl,
          publishedAt: article.publishedAt,
          category: article.category,
          readTime: article.readTime,
        ),
      ),
    );

    if (result is Map) {
      if (result['updated'] == true || result['deleted'] == true) {
        _fetchArticles();
      }
    }

    if (result is Map && result['updated'] == true) {
      final updated = result['updatedArticle'];
      setState(() {
        articles = articles.map((a) {
          if (a.articleId == updated['articleId']) {
            return a.copyWith(
              title: updated['title'],
              content: updated['content'],
              imageUrl: updated['imageUrl'],
              category: updated['category'],
              readTime: updated['readTime'],
            );
          }
          return a;
        }).toList();
      });
    }
  }

  int currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: cBgDc,
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cBgDc,
        leading: Image.asset('assets/images/logo Ai no bg-01.png', width: 36.w, fit: BoxFit.contain),
        title: Text('MatchUP', style: headline4.copyWith(color: cPrimary, fontWeight: bold)),
      ),
      backgroundColor: cBgDc,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vsSmall, vsSmall,
            _buildCarousel(),
            vsLarge, SizedBox(height: 10),
            Text("Hot News", style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
            vsTiny,
            _buildNewsList(articles),
            vsSmall,
            Text("All News", style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
            vsTiny,
            _buildNewsList(articles),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddNews,
        backgroundColor: cPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 170.h,
      width: 320.w,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150.h,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          onPageChanged: (i, _) => setState(() => currentCarouselIndex = i),
        ),
        items: articles.map((a) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  a.imageUrl,
                  width: 320.w,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    a.title,
                    style: subtitle1.copyWith(color: cWhite, fontWeight: bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNewsList(List<News> newsList) {
    return SizedBox(
      height: 180.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, idx) {
          final a = newsList[idx];
          return GestureDetector(
            onTap: () => _handleDetail(a),
            child: Container(
              width: 260.w,
              margin: EdgeInsets.only(right: 12.w),
              child: Card(
                elevation: 0,
                color: cBoxDc,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            a.imageUrl,
                            width: 260.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.title,
                                style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                a.content,
                                style: caption.copyWith(color: cWhite),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                a.publishedAt.split('T').first,
                                style: caption.copyWith(color: cWhite),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Consumer<BookmarkProvider>(
                        builder: (context, bookmarkProvider, _) {
                          final isBookmarked = bookmarkProvider.isBookmarked(a);
                          return GestureDetector(
                            onTap: () {
                              if (bookmarkProvider.isGuest) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Login To Add Bookmark")),
                                );
                                return;
                              }

                              if (isBookmarked) {
                                bookmarkProvider.removeBookmark(a);
                              } else {
                                bookmarkProvider.addBookmark(a);
                              }
                            },
                            child: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                              color: cWhite,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
