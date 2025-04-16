import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:recyclens_app/controllers/drawer_controller.dart';
import 'package:recyclens_app/pages/home/bottom_bar.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  final drawerController = Get.find<MyDrawerController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
      controller: drawerController.zoomDrawerController,
      borderRadius: 50,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      menuScreenTapClose: true,
      // angle: 0.0,
      menuBackgroundColor: Colors.blue,
      mainScreen: BottomBarPage(),
      moveMenuScreen: true,
      mainScreenOverlayColor: Colors.black12,
      menuScreenWidth: MediaQuery.of(context).size.width,
      menuScreen: const Scaffold(
        backgroundColor: Colors.black12,
        body: DrawerContent(),
      ),
      style: DrawerStyle.defaultStyle,
    ),
    );
  }
}

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Stack(
          children: [
            // Lottie.asset('assets/anim.json',
            //     width: size.width, height: size.height, fit: BoxFit.contain),
            Positioned(
              top: 50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: size.width * 0.4,
                        //color: Colors.blue,
                        child: Center(
                          child: AdvancedAvatar(
                            statusColor: Colors.deepOrange,
                            name: 'Tejas Pokale',
                            size: 55,
                            foregroundDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.deepOrange.withOpacity(0.75),
                                width: 3.0,
                              ),
                            ),
                          ),
                        )),
                    Container(
                        width: size.width * 0.4,
                        //color: Colors.blue,
                        child: const Center(
                            child: Text(
                          'Tejas Pokale',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 300,
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Column(
                        children: [
                          
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.cyan,
                            ),
                            title: Text(
                              'My Profile',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              AntDesign.setting_outline,
                              color: Colors.cyan,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.question_mark,
                              color: Colors.cyan,
                            ),
                            title: Text(
                              'About',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.contact_support_outlined,
                              color: Colors.cyan,
                            ),
                            title: Text(
                              'help & Support',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                    SizedBox(
                      width: 200,
                      height: 100,
                      child: ListTile(
                        leading: RiveAnimatedIcon(
                            riveIcon: RiveIcon.warning,
                            width: 50,
                            height: 50,
                            color: Colors.redAccent,
                            strokeWidth: 3,
                            loopAnimation: true,
                            onTap: () {},
                            onHover: (value) {}),
                        title: const Text(
                          'Log out',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  'App version : 1.0',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                )),
          ],
        ),
      ),
    );
  }
}