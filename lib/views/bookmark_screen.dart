import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/bookmark_provider.dart';
import 'package:matchupnews/views/news_detail_screen.dart'; // ✅ DITAMBAHKAN
import 'package:matchupnews/views/utils/helper.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isGuest = bookmarkProvider.isGuest;
    final bookmarks = bookmarkProvider.bookmarkedNews;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cBgDc,
        leading: Image.asset(
          'assets/images/logo matchup.png',
          width: 36.w,
          fit: BoxFit.contain,
        ),
        title: Text(
          'MatchUP',
          style: headline4.copyWith(color: cPrimary, fontWeight: bold),
        ),
      ),
      backgroundColor: cBgDc,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vsSmall,
            vsSmall,
            Text(
              "Bookmarked News",
              style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
            ),
            vsTiny,
            Expanded(
              child: isGuest
                  ? Center(
                      child: Text(
                        'Login to view bookmarks.',
                        style: subtitle1.copyWith(color: cWhite),
                      ),
                    )
                  : bookmarks.isEmpty
                      ? Center(
                          child: Text(
                            'No bookmarks yet.',
                            style: subtitle1.copyWith(color: cWhite),
                          ),
                        )
                      : ListView.builder(
                          itemCount: bookmarks.length,
                          itemBuilder: (context, index) {
                            final news = bookmarks[index];
                            return GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NewsDetailScreen(
                                      id: news.id, // ✅ ganti dari articleId
                                      title: news.title,
                                      slug: news.slug,
                                      summary: news.summary,
                                      content: news.content,
                                      featuredImageUrl: news.imageUrl,
                                      publishedAt: news.publishedAt,
                                      category: news.category,
                                    ),
                                  ),
                                );

                                // ✅ Auto remove jika dihapus dari detail
                                if (result != null && result['deleted'] == true) {
                                  bookmarkProvider.removeBookmark(news);
                                  setState(() {});
                                }
                              },
                              child: Card(
                                elevation: 0,
                                margin: EdgeInsets.only(bottom: 12.h),
                                color: cBoxDc,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.network(
                                        news.imageUrl, // ✅ ganti dari imageUrl
                                        width: 80.w,
                                        height: 80.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            news.title,
                                            style: subtitle2.copyWith(color: cWhite, fontWeight: semibold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            news.summary,
                                            style: caption.copyWith(color: cWhite),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            news.publishedAt.split('T').first,
                                            style: caption.copyWith(color: cWhite),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: cWhite, size: 20),
                                      onPressed: () {
                                        bookmarkProvider.removeBookmark(news);
                                      },
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
    );
  }
}
