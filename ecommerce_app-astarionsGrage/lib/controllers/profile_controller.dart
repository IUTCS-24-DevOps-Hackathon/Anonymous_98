// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../consts/consts.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;

  //Text filed...

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${auth.currentUser!.uid}/filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(usersCollection).doc(auth.currentUser!.uid);
    await store.set({'name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
      auth.currentUser!.updatePassword(newpassword);
    }).catchError((error) {
    });
  }

  void refreshProfileScreen() {
    // Perform the refresh logic specific to the ProfileController
    // For example, you can update the profile data or perform any other necessary operations

    // Your refresh logic here
    // For instance, if you want to update the profile image path:
    updateProfileImage();

    // Trigger a rebuild of the ProfileScreen widget
    update();
  }

  void updateProfileImage() {
    // Update the profile image path logic here
    // For example, fetch the profile image path from an API or update it from other data sources
    profileImgPath.value = getProfileImagePath();
  }

  String getProfileImagePath() {
    // Get the profile image path based on your logic
    // Return the profile image path
    return ''; // Replace with your actual implementation
  }
}
