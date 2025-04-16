import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static void message(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);

    try {
      if (!await launchUrl(smsUri)) {
        Get.snackbar('Error', 'SMS app not available on this device');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  static void call(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (!await launchUrl(uri)) {
        Get.snackbar('Error', 'Dialer not available on this device');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

    static void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar('opps..', 'could not launch the url',);
    }
  }
}
 