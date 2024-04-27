import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../const/const.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;

  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;

  //Edit profile controllers....

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

// Shop Controllers...

  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();

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
    var destination = 'images/${auth.currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, password, imgUrl}) async {
    var store =
    firestore.collection(vendorsCollection).doc(auth.currentUser!.uid);
    Map<String, dynamic> dataToUpdate = {};
    if (name != null && name.isNotEmpty) {
      dataToUpdate['vendor_name'] = name;
    }
    if (password != null && password.isNotEmpty) {
      dataToUpdate['password'] = password;
    }
    if (imgUrl != null && imgUrl.isNotEmpty) {
      dataToUpdate['imageUrl'] = imgUrl;
    }
    await store.set(dataToUpdate, SetOptions(merge: true));

    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    try {
      await auth.currentUser!.reauthenticateWithCredential(cred);
      await auth.currentUser!.updatePassword(newpassword);
    } catch (error) {
      print("Error changing password: $error");
    }
  }

  updateShop({shopname, shopaddress, shopmobile, shopwebsite, shopdesc}) async {
    var store =
        firestore.collection(vendorsCollection).doc(auth.currentUser!.uid);
    Map<String, dynamic> dataToUpdate = {};
    if (shopname != null && shopname.isNotEmpty) {
      dataToUpdate['shop_name'] = shopname;
    }
    if (shopaddress != null && shopaddress.isNotEmpty) {
      dataToUpdate['shop_address'] = shopaddress;
    }
    if (shopmobile != null && shopmobile.isNotEmpty) {
      dataToUpdate['shop_mobile'] = shopmobile;
    }
    if (shopwebsite != null && shopwebsite.isNotEmpty) {
      dataToUpdate['shop_website'] = shopwebsite;
    }
    if (shopdesc != null && shopdesc.isNotEmpty) {
      dataToUpdate['shop_desc'] = shopdesc;
    }
    await store.set(dataToUpdate, SetOptions(merge: true));

    isloading(false);
  }
}
