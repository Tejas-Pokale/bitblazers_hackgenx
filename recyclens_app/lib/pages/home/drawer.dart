import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:recyclens_app/controllers/drawer_controller.dart';
import 'package:recyclens_app/controllers/user_controller.dart';
import 'package:recyclens_app/models/user.dart';
import 'package:recyclens_app/pages/account/user_profile.dart';
import 'package:recyclens_app/pages/auth/sign_in.dart';
import 'package:recyclens_app/pages/home/bottom_bar.dart';
import 'package:recyclens_app/pages/home/home_drawer/about.dart';
import 'package:recyclens_app/pages/home/home_drawer/help_support.dart';
import 'package:recyclens_app/pages/home/home_drawer/settings.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final drawerController = Get.put(MyDrawerController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      await userController.fetchUserData();

      if (userController.currentUser.value == null) {
        // user not signed in
        Get.snackbar('Pikachu', 'Im causing errro');
        Get.offAll(() => const SignInPage());
      } else {
        final user = userController.currentUser.value!;
        // Update static fields
        // YourStaticClass.userId = user.id;
        // YourStaticClass.name = user.name;
        // YourStaticClass.phone = user.phone;
        // YourStaticClass.location = user.location;
        // YourStaticClass.age = user.age;
        // YourStaticClass.gender = user.gender;
        // YourStaticClass.userType = user.userType;
        // YourStaticClass.imageUrl = user.imageUrl ?? '';
        setState(() {});
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      Get.offAll(() => const SignInPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (userController.isLoading.value) {
        return  Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return GetBuilder<MyDrawerController>(
        builder: (_) => ZoomDrawer(
          controller: drawerController.zoomDrawerController,
          borderRadius: 50,
          showShadow: true,
          openCurve: Curves.fastOutSlowIn,
          slideWidth: MediaQuery.of(context).size.width * 0.65,
          duration: const Duration(milliseconds: 500),
          menuScreenTapClose: true,
          menuBackgroundColor: Colors.blue,
          mainScreen: const BottomBarPage(),
          moveMenuScreen: true,
          mainScreenOverlayColor: Colors.black12,
          menuScreenWidth: MediaQuery.of(context).size.width,
          menuScreen:  Scaffold(
            backgroundColor: Colors.black12,
            body: DrawerContent(usermodel: userController.currentUser.value!,),
          ),
          style: DrawerStyle.defaultStyle,
        ),
      );
    });
  }
}

class DrawerContent extends StatelessWidget {
  DrawerContent({super.key , required this.usermodel});
  UserModel usermodel ;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Get.find<UserController>() ;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: Center(
                        child: Obx(() => AdvancedAvatar(
                          statusColor: Colors.deepOrange,
                          name: user.currentUser.value!.name ?? 'User',
                          size: 55,
                          foregroundDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.deepOrange.withOpacity(0.75),
                              width: 3.0,
                            ),
                          ),
                        ),)
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Center(
                        child: Obx(() => Text(
                          user.currentUser.value!.name ?? 'User',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),)
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width: 300,
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => Get.to(() => const UserProfilePage()),
                            leading: const Icon(Icons.person, color: Colors.cyan),
                            title: const Text(
                              'My Profile',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.to(() => const SettingsPage()),
                            leading: const Icon(AntDesign.setting_outline, color: Colors.cyan),
                            title: const Text(
                              'Settings',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.to(() => const AboutPage()),
                            leading: const Icon(Icons.question_mark, color: Colors.cyan),
                            title: const Text(
                              'About',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ListTile(
                            onTap: () => Get.to(() => const HelpSupportPage()),
                            leading: const Icon(Icons.contact_support_outlined, color: Colors.cyan),
                            title: const Text(
                              'Help & Support',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 200),
                    SizedBox(
                      width: 200,
                      height: 100,
                      child: ListTile(
                        onTap: () => Get.to(() => const SignInPage()),
                        leading: const RiveAnimatedIcon(
                          riveIcon: RiveIcon.warning,
                          width: 50,
                          height: 50,
                          color: Colors.redAccent,
                          strokeWidth: 3,
                          loopAnimation: true,
                          onTap: null,
                          onHover: null,
                        ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
