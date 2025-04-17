import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/pages/home/home_options/notifications.dart';

// ignore: must_be_immutable
class HomeBadge extends StatelessWidget {
   HomeBadge({super.key});

  bool avail = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: badges.Badge(
        position: badges.BadgePosition.topEnd(top: 3, end: 3),
        showBadge: avail,
        ignorePointer: false,
       
        badgeContent: avail ? Container(
          width: 1, 
          height: 1, 
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ): null ,
        // badgeAnimation: badges.BadgeAnimation.rotation(
        //   animationDuration: Duration(seconds: 1),
        //   colorChangeAnimationDuration: Duration(seconds: 1),
        //   loopAnimation: false,
        //   curve: Curves.fastOutSlowIn,
        //   colorChangeAnimationCurve: Curves.easeInCubic,
        // // ),
        // badgeStyle: badges.BadgeStyle(
        //   shape: badges.BadgeShape.circle,
        //   badgeColor: Colors.blue,
        //   padding: EdgeInsets.all(5),
        //   borderSide: BorderSide(color: Colors.white, width: 2),
        //   elevation: 0,
        // ),
        child: IconButton(onPressed: () {
          Get.to(NotificationsPage());
        }, icon: const Icon(Icons.notifications_active_rounded)),
      ),
    );
  }
}
