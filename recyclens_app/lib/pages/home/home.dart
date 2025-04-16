import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/controllers/home_bottombar_controller.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class HomePage extends StatefulWidget {
   HomePage({super.key , required this.scrollController});
  ScrollController scrollController ;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeBottombarController _homeBottombarController = Get.find<HomeBottombarController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
            
              //     FancyUploadButton(
              //   onTap: () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageScanScreen(),));
              //   },
              // ),
            ],
          ),
        ),
    );
  }
}