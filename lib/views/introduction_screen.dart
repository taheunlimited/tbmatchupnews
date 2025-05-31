import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matchupnews/routes/routes_name.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:matchupnews/views/widgets/primary_button.dart';
import 'package:matchupnews/views/widgets/secondary_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  List<Map<String, dynamic>> pageList = [
    {
      'imageUrl':'assets/images/logo Ai no bg-01.png',
      'heading':'Selamat datang',
      'body':'Coming Soon',
    },
    {
      'imageUrl':'assets/images/logo Ai no bg-01.png',
      'heading':'ようこそ！',
      'body':'Coming Soon',
    },
    {
      'imageUrl':'',
      'heading':'',
      'body':'',
    },
  ];

  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: pageList.length,
              itemBuilder: (context, index) {
                if (_currentPage ==  pageList.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Selamat Datang di MATCHUP!",
                          style: headline2.copyWith(
                            color: cPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        PrimaryButton(
                          onPressed: () {
                            context.goNamed(RouteNames.login);
                          }, 
                          title: "Masuk",
                          width: 200,
                        ),
                        SizedBox(height: 16),
                        SecondaryButton(
                          onPressed: () {
                            context.goNamed(RouteNames.register);
                          }, 
                          title: "Daftar",
                          width: 200,
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 100),
                      Image.asset(pageList[index]['imageUrl'], height: 300),
                      SizedBox(height: 100),
                      Text(
                        pageList[index]['heading'],
                        style: headline3.copyWith(
                          color: cPrimary,
                          fontWeight: bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(pageList[index]['body'], style: subtitle1.copyWith(color: cWhite)),
                      SizedBox(height: 12),
                      SmoothPageIndicator(
                        controller: _pageController, 
                        count: pageList.length,
                        axisDirection: Axis.horizontal,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 3,
                          activeDotColor: cPrimary,
                          dotColor: cLinear,
                        ),
                      ),
                      Spacer(),
                      _currentPage == pageList.length - 1
                      ? SizedBox(height: 14)
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SecondaryButton(
                                onPressed: () {
                                  _pageController.jumpToPage(
                                    pageList.length - 1,
                                  );
                                }, 
                                title: 'Skip',
                                width: 150,
                              ),
                            ],
                          ),
                          hsLarge,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PrimaryButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(
                                      milliseconds: 500,
                                    ), 
                                    curve: Curves.ease,
                                  );
                                }, 
                                title: 'Next',
                                width: 150,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        )
      ),
    );
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}