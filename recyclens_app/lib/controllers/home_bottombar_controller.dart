import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/pages/community/community.dart';
import 'package:recyclens_app/pages/home/home.dart';
import 'package:recyclens_app/pages/marketplace/marketplace.dart';


class HomeBottombarController extends GetxController {
  int currentIndex = 0;
  final ScrollController bottom_bar_scroll_controller = ScrollController();
  dynamic pages = [];

  @override
  void onInit() {
    pages = [
      HomePage(scrollController: bottom_bar_scroll_controller),
      CommunityPage(),
      //HomePage(scrollController: bottom_bar_scroll_controller),
      MarketplacePage(),
    ];
    super.onInit();
  }
}
