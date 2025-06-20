import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/add_news_screen.dart';
import 'package:matchupnews/views/bookmark_provider.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Model News
class News {
  final String title;
  final String content;
  final String imageUrl;
  final String publishedAt;

  News({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
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
  List<News> articles = [];      // ✅ list hasil fetch API
  bool isLoading = true;         // ✅ indikator loading

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _loadToken();
    _fetchArticles(); // ✅ fetch data awal
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

  void _handleAddNews() {
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to add news")),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNewsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kalau masih loading, tampilkan spinner
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
            vsSmall,
            vsSmall,
            SizedBox(
              height: 170.h, width: 320.w,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 150.h, autoPlay: true, enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  onPageChanged: (i, _) => setState(() => currentCarouselIndex = i),
                ),
                items: articles.map((a) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(a.imageUrl,
                          width: 320.w,
                          height: 150.h,
                          fit: BoxFit.cover
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(a.title,
                            style: subtitle1.copyWith(color: cWhite, fontWeight: bold),
                            maxLines: 2, overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            vsLarge, SizedBox(height: 10),
            Text("Hot News", style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
            vsTiny,

            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, idx) {
                  final a = articles[idx];
                  return Container(
                    width: 260.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: Card(
                      elevation: 0,
                      color: cBoxDc,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Stack(
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(a.imageUrl,
                                width: 260.w,
                                height: 100.h,
                                fit: BoxFit.cover
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.title,
                                    style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                                    maxLines: 1, overflow: TextOverflow.ellipsis
                                  ),
                                  Text(a.content,
                                    style: caption.copyWith(color: cWhite),
                                    maxLines: 1, overflow: TextOverflow.ellipsis
                                  ),
                                  Text(a.publishedAt.split('T').first,
                                    style: caption.copyWith(color: cWhite),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          Positioned(
                            bottom: 12, right: 12,
                            child: Consumer<BookmarkProvider>(
                              builder: (context, bookmarkProvider, _) {
                                final isBookmarked = bookmarkProvider.isBookmarked(a);
                                return GestureDetector(
                                  onTap: () {
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
                  );
                },
              ),
            ),

            vsSmall,
            Text("All News", style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
            vsTiny,

            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, idx) {
                  final a = articles[idx];
                  return Container(
                    width: 260.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: Card(
                      elevation: 0,
                      color: cBoxDc,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Stack(
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(a.imageUrl,
                                width: 260.w,
                                height: 100.h,
                                fit: BoxFit.cover),
                            ),
                            SizedBox(height: 6.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.title,
                                    style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text(a.content,
                                    style: caption.copyWith(color: cWhite),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text(a.publishedAt.split('T').first,
                                    style: caption.copyWith(color: cWhite)),
                                ],
                              ),
                            ),
                          ]),
                          Positioned(
                            bottom: 12, right: 12,
                            child: Consumer<BookmarkProvider>(
                              builder: (context, bookmarkProvider, _) {
                                final isBookmarked = bookmarkProvider.isBookmarked(a);
                                return GestureDetector(
                                  onTap: () {
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
                  );
                },
              ),
            ),

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

  int currentCarouselIndex = 0;
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
