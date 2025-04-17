import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/models/user.dart';


class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var currentUser = Rxn<UserModel>();
  var isLoading = false.obs;

  /// Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;

      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        currentUser.value = UserModel.fromFirestore(doc);
      } else {
        throw Exception("User document not found");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;

      // Navigate to login screen or do appropriate routing
      Get.offAllNamed('/login'); // Make sure route is registered
    } catch (e) {
      Get.snackbar("Sign Out Failed", e.toString());
    }
  }
}
