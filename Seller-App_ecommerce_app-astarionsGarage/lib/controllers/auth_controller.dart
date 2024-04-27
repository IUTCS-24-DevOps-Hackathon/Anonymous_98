import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isloading = false.obs;

  //Text controllers....

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //Log in method...
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (userCredential != null) {
        // Check if the user is in the "vendors" collection
        bool isVendor = await isUserInVendorsCollection(userCredential.user!.uid);

        if (!isVendor) {
          // If the user is not in the "vendors" collection, handle accordingly
          VxToast.show(context, msg: "You are not authorized as a vendor.");
          await auth.signOut(); // Sign out the user
          userCredential = null; // Reset userCredential
        }
      }

    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  // Check if the user is in the "vendors" collection
  Future<bool> isUserInVendorsCollection(String userId) async {
    try {
      DocumentSnapshot snapshot = await firestore.collection(vendorsCollection).doc(userId).get();
      return snapshot.exists;
    } catch (e) {
      // Handle any errors
      print("Error checking user in vendors collection: $e");
      return false;
    }
  }

//Signout method...

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
