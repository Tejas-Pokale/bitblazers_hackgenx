import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recyclens_app/controllers/drawer_controller.dart';
import 'package:recyclens_app/controllers/home_bottombar_controller.dart';
import 'package:recyclens_app/widgets/circle_image_url.dart';
import 'package:recyclens_app/widgets/home_badge.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _HomePageState();
}

class _HomePageState extends State<BottomBarPage> {
  final drawerController = Get.find<MyDrawerController>();
  final ScrollController _scrollController = ScrollController();
  final HomeBottombarController _homeBottombarController = Get.find<HomeBottombarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _homeBottombarController.currentIndex == 2 ? null :  AppBar(
        elevation: 2,
        shadowColor: Theme.of(context).primaryColor,

        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              drawerController.zoomDrawerController.open!();
            },
            child: CircleImageUrl(
              imageUrl:
                  'https://th.bing.com/th/id/OIP.868vh_SDCQdcqSIRRKaUgAHaEK?w=317&h=180&c=7&r=0&o=5&pid=1.7',
              radius: 3.0,
            ),
          ),
        ),
        title: Text(
          'RecycLens',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [HomeBadge()],
      ),
      
      body: _homeBottombarController.pages[_homeBottombarController.currentIndex],

      bottomNavigationBar: ScrollToHide(
        hideDirection: Axis.vertical,
        scrollController: _homeBottombarController.bottom_bar_scroll_controller,
        height: 70, // The initial height of the widget.
        duration: Duration(
          milliseconds: 300,
        ), // Duration of the hide/show animation.
        child: Container(
         
          height: 70,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: SalomonBottomBar(
            currentIndex: _homeBottombarController.currentIndex,
            
            onTap: (i) => setState(() => _homeBottombarController.currentIndex = i),
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: Colors.purple,
              ),
          
              /// Community
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text("Community"),
                selectedColor: Colors.pink,
              ),
          
              /// Search
              // SalomonBottomBarItem(
              //   icon: Icon(Icons.search),
              //   title: Text("Search"),
              //   selectedColor: Colors.orange,
              // ),
          
              /// Marketplace
              SalomonBottomBarItem(
                icon: Icon(Icons.shopify_rounded),
                title: Text("Marketplace"),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),

      
    );
  
  }
}


