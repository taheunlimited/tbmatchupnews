import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/utils/form_validator.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:matchupnews/views/widgets/custom_form_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late TabController tabController;
  int currentTabIndex = 0;
  int currentCarouselIndex = 0;

  List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'assets/images/sample 1.jpg',
      'title': 'Lorem ipsum sit dolor',
    },
    {
      'image': 'assets/images/sample 2.jpg',
      'title': 'Ipsum sit dolor Amet',
    },
    {
      'image': 'assets/images/sample 3.jpg',
      'title': 'Sit dolor Amet consectetur',
    },
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cBgDc,
        leading: Image.asset(
          'assets/images/logo Ai no bg-01.png',
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
            SizedBox(
              height: 200.h,
              width: 320.w,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 150.h,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentCarouselIndex = index;
                    });
                  },
                ),
                items: carouselItems.map((item) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          item['image'],
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
                            item['title'],
                            style: subtitle1.copyWith(
                              color: cWhite,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),

            vsLarge,
            SizedBox(height: 10),
            Text(
              "Hot News",
              style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
            ),
            vsTiny,

            /// =================== HOT NEWS ======================
            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    width: 260.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: Card(
                      elevation: 0,
                      color: cBoxDc,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: Image.asset(
                              "assets/images/sample 4.jpeg",
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
                                  "Photo anime aja ,ya gitulah",
                                  style: subtitle1.copyWith(
                                      color: cWhite, fontWeight: semibold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Ga ada photo lagi',
                                  style: caption.copyWith(color: cWhite),
                                ),
                                Text(
                                  '2045-13-32',
                                  style: caption.copyWith(color: cWhite),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// =================== ALL NEWS ======================
            vsSmall,
            Text(
              "All News",
              style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
            ),
            vsTiny,
            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    width: 260.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: Card(
                      elevation: 0,
                      color: cBoxDc,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: Image.asset(
                              "assets/images/sample 4.jpeg",
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
                                  "Judul Berita Index",
                                  style: subtitle1.copyWith(
                                      color: cWhite, fontWeight: semibold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Deskripsi singkat...',
                                  style: caption.copyWith(color: cWhite),
                                ),
                                Text(
                                  '2025-06-19',
                                  style: caption.copyWith(color: cWhite),
                                ),
                              ],
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
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }
}
