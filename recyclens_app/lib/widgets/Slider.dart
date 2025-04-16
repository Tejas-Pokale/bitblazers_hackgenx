import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recyclens_app/data/slider_data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MySlider extends StatefulWidget {
  const MySlider({super.key});

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  final _data = SliderData.data;
  late List _keys = [];
  final _pageController = PageController(initialPage: 0);
  int _index = 0;
  bool _scroll = true;

  @override
  void initState() {
    // TODO: implement initState
    _keys = _data.keys.toList();

    Timer.periodic(Duration(seconds: 2), (timer) {
      if (_scroll) {
        print('Im called ${_index}');
        _pageController.animateToPage(_index,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

        _index == (_keys.length - 1) ? _index = 0 : _index++;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        _scroll = false;
      },
      child: Container(
          height: size.height * 0.25,
          width: size.width,
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.234),
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              PageView.builder(
                onPageChanged: (value) {
                  _index = value;
                  _scroll = true;
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.asset(
                        _data[_keys[index]]!['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        child: Text(
                          _keys[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 5,
                                ),
                              ]),
                        ),
                        left: 5,
                        top: 2,
                      ),
                      Positioned(
                        child: Container(
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.145),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _data[_keys[index]]!['title']!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5,
                                      ),
                                    ]),
                              ),
                              Text(
                                _data[_keys[index]]!['desc']!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5,
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        right: 5,
                        bottom: 10,
                      ),
                    ],
                  );
                },
                controller: _pageController,
                itemCount: _keys.length,
              ),
              Positioned(
                child: SmoothPageIndicator(
                  controller: _pageController, // PageController
                  count: _keys.length,
                  // forcing the indicator to use a specific direction
                  textDirection: TextDirection.ltr,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 5,
                    activeDotColor: Colors.red,
                  ),
                ),
                left: 30,
                bottom: 30,
              ),
            ],
          )),
    );
  }
}