import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/add_news_screen.dart';
import 'package:matchupnews/views/bookmark_provider.dart';
import 'package:matchupnews/views/news_detail_screen.dart';
import 'package:matchupnews/views/utils/client_internet_api.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class News {
  final String id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String imageUrl;
  final String category;
  final String publishedAt;
  final int viewCount;
  final String createdAt;
  final String updatedAt;
  final String authorName;

  News({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.publishedAt,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
    required this.authorName,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['featured_image_url'] ?? '',
      category: json['category'] ?? '',
      publishedAt: json['published_at'] ?? '',
      viewCount: json['view_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      authorName: json['author_name'] ?? '',
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
  int currentCarouselIndex = 0;

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
      final jsonData = await ClientInternetApi.getNews();
      if (jsonData['success'] == true) {
        final list = jsonData['data'] as List<dynamic>;
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
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddNewsScreen()),
      );
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
          id: article.id,
          title: article.title,
          content: article.content,
          featuredImageUrl: article.imageUrl,
          publishedAt: article.publishedAt,
          category: article.category,
          slug: article.slug,
          summary: article.summary,
        ),
      ),
    );

    if (result == true || (result is Map && (result['updated'] == true || result['deleted'] == true))) {
      _fetchArticles();
    }
  }

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
        leading: Image.asset('assets/images/logo matchup.png', width: 36.w, fit: BoxFit.contain),
        title: Text('MatchUP', style: headline4.copyWith(color: cPrimary, fontWeight: bold)),
      ),
      backgroundColor: cBgDc,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vsSmall,
            _buildCarousel(),
            vsLarge,
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            a.imageUrl,
                            width: 260.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
