import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/home_controller.dart';
import 'package:ecommerce_seller_app/models/category_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProductsController extends GetxController {
  var isloading = false.obs;

// Textfield controllers...

  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = 0.obs;

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategoryList(cat) {
    subcategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImage() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${auth.currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion([Colors.red.value, Colors.green.value]),
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_rating': "5.0",
      'p_seller': Get
          .find<HomeController>()
          .username,
      'vendor_id': auth.currentUser!.uid,
      'featured_id': '',
    });
    isloading(false);
    VxToast.show(context, msg: "Product Uploaded Successfully");
  }

  editProduct

  (BuildContext context, 

  {
  category,
  subcategory,
  name,
  price,
  imgs,
  colors,

  }) async {
  var store =
  firestore.collection(vendorsCollection).doc(auth.currentUser!.uid);
  Map<String, dynamic> dataToUpdate = {};

  if (category != null) {
  dataToUpdate['p_category'] = category;
  }

  if (subcategory != null) {
  dataToUpdate['p_subcategory'] = subcategory;
  }

  if (name != null) {
  dataToUpdate['p_name'] = name;
  }

  if (price != null) {
  dataToUpdate['p_price'] = price;
  }

  if (imgs != null) {
  // Assuming imgs is a List<String>
  dataToUpdate['p_imgs'] = FieldValue.arrayUnion(imgs);
  }

  if (colors != null) {
  // Assuming colors is a List<int> representing color values
  dataToUpdate['p_colors'] = FieldValue.arrayUnion(colors);
  }

  // Add other fields as needed

  await store.set(dataToUpdate, SetOptions(merge: true));

  isloading(false);
  }

  addFeatured(docId) async {
  await firestore.collection(productsCollection).doc(docId).set({
  'featured_id': auth.currentUser!.uid,
  'is_featured': true,
  }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
  await firestore.collection(productsCollection).doc(docId).set({
  'featured_id': ' ',
  'is_featured': false,
  }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
  await firestore.collection(productsCollection).doc(docId).delete();
  }
}
