import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';

class DialogUtils{
  static void showError(String title, String msg,BuildContext context) {
    Flushbar(
      title: "Error",
      titleColor: Colors.white,
      message: "Please fill the all fields",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: const [
        BoxShadow(color: Colors.red, offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      // backgroundGradient:
      //     const LinearGradient(colors: [Colors.red, Colors.blueAccent]),
      isDismissible: false,
      duration: const Duration(seconds: 4),
      icon: const Icon(
        Icons.close,
        color: Colors.greenAccent,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
    ).show(context);
  }

  static void showAwesomeError(String title, String msg,BuildContext context){
     final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: title,
                    message: msg,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
  }

  static void showAwesomeSuccess(String title, String msg,BuildContext context){
     final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: title,
                    message: msg,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
  }
  
}