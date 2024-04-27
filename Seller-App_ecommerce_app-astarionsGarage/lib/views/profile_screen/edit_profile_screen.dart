// import 'dart:io';
//
// import 'package:ecommerce_seller_app/const/const.dart';
// import 'package:ecommerce_seller_app/controllers/profile_controller.dart';
// import 'package:ecommerce_seller_app/views/widgets/custom_text_field.dart';
// import 'package:ecommerce_seller_app/views/widgets/dismiss_keyboard_on_tap.dart';
// import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
// import 'package:get/get.dart';
//
// import '../widgets/text_style.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   final String? username;
//   const EditProfileScreen({super.key, this.username});
//
//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   var controller = Get.find<ProfileController>();
//   @override
//   void initState() {
//     controller.nameController.text = widget.username ?? '';
//     super.initState();
//   }
//
//   bool isObscure = true;
//   bool isObscure_rp = true;
//
//   var passwordController = TextEditingController();
//   var passwordRetypeController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         backgroundColor: bgColor,
//         appBar: AppBar(
//           backgroundColor: purpleColor,
//           title: boldText(text: editProfile, color: whiteColor, size: 18.0),
//           iconTheme: IconThemeData(color: Colors.white),
//           actions: [
//             controller.isloading.value
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(child: loadingIndicator(color: whiteColor)),
//                   )
//                 : TextButton(
//                     onPressed: () async {
//                       controller.isloading(true);
//
//                       //If image is not selected..
//                       if (controller.profileImgPath.value.isNotEmpty) {
//                         await controller.uploadProfileImage();
//                       } else {
//                         controller.profileImageLink =
//                             controller.snapshotData['imageUrl'];
//                       }
//
//                       // Check if the new password is provided
//                       if (controller.snapshotData['password'] ==
//                           controller.oldpassController.text) {
//                         // Check if the old password matches the database
//                         await controller.changeAuthPassword(
//                           email: controller.snapshotData['email'],
//                           password: controller.oldpassController.text,
//                           newpassword: controller.newpassController.text,
//                         );
//
//                         // Update the profile information with the new password
//                         await controller.updateProfile(
//                           imgUrl: controller.profileImageLink,
//                           name: controller.nameController.text,
//                           password: controller.newpassController.text,
//                         );
//
//                         VxToast.show(context,
//                             msg: "Profile Updated Successfully");
//                       } else if (controller
//                               .oldpassController.text.isEmptyOrNull &&
//                           controller.newpassController.text.isEmptyOrNull) {
//                         await controller.updateProfile(
//                           imgUrl: controller.profileImageLink,
//                           name: controller.nameController.text,
//                           password: controller.snapshotData['password'],
//                         );
//                         // No need to enter the old password for changing image and name
//
//                         VxToast.show(context,
//                             msg: "Profile Updated Successfully");
//                       } else {
//                         VxToast.show(context,
//                             msg: "Error occurred, try again!");
//                       }
//
//                       controller.isloading(false);
//                     },
//                     child: Icon(
//                       Icons.save,
//                       size: 25,
//                       color: whiteColor,
//                     ),
//                   )
//           ],
//         ),
//         body: DismissKeyboardOnTap(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(children: [
//                 controller.snapshotData['imageUrl'] == '' &&
//                         controller.profileImgPath.isEmpty
//                     ? Image.asset(icProduct, width: 100, fit: BoxFit.cover)
//                         .box
//                         .roundedFull
//                         .clip(Clip.antiAlias)
//                         .make()
//                     : controller.snapshotData['imageUrl'] != '' &&
//                             controller.profileImgPath.isEmpty
//                         ? Image.network(
//                             controller.snapshotData['imageUrl'],
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ).box.roundedFull.clip(Clip.antiAlias).make()
//                         : Image.file(
//                             File(controller.profileImgPath.value),
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ).box.roundedFull.clip(Clip.antiAlias).make(),
//                 10.heightBox,
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
//                   onPressed: () {
//                     controller.changeImage(context);
//                   },
//                   child: normalText(text: changeImage, color: whiteColor),
//                 ),
//                 10.heightBox,
//                 Divider(
//                   color: darkFontGrey,
//                 ),
//                 customTextField(
//                   keyboardType: TextInputType.text,
//                   hint: "Change your user name",
//                   title: "User Name",
//                   controller: controller.nameController,
//                   sIcon: Icon(
//                     Icons.edit,
//                     color: redColor,
//                     size: 25,
//                   ),
//                 ),
//                 10.heightBox,
//                 boldText(
//                     text: "Change Your Password",
//                     color: darkFontGrey,
//                     size: 18.0),
//                 10.heightBox,
//                 customTextField(
//                   isObscured: isObscure,
//                   controller: controller.oldpassController,
//                   eIcon: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isObscure = !isObscure;
//                       });
//                     },
//                     child: Icon(
//                       size: 25,
//                       color: redColor,
//                       isObscure ? Icons.visibility : Icons.visibility_off,
//                     ),
//                   ),
//                   sIcon: Icon(
//                     Icons.lock,
//                     color: redColor,
//                     size: 25,
//                   ),
//                   hint: "Enter your old password",
//                   title: "Old Password",
//                   keyboardType: TextInputType.text,
//                 ),
//                 10.heightBox,
//                 customTextField(
//                   controller: controller.newpassController,
//                   sIcon: Icon(
//                     Icons.lock,
//                     color: redColor,
//                     size: 25,
//                   ),
//                   isObscured: isObscure_rp,
//                   eIcon: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isObscure_rp = !isObscure_rp;
//                       });
//                     },
//                     child: Icon(
//                       size: 25,
//                       color: redColor,
//                       isObscure_rp ? (Icons.visibility) : Icons.visibility_off,
//                     ),
//                   ),
//                   hint: "Enter your new password",
//                   title: "New Password",
//                   keyboardType: TextInputType.text,
//                 ),
//               ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:ecommerce_seller_app/const/const.dart';
import 'package:ecommerce_seller_app/controllers/profile_controller.dart';
import 'package:ecommerce_seller_app/views/widgets/custom_text_field.dart';
import 'package:ecommerce_seller_app/views/widgets/dismiss_keyboard_on_tap.dart';
import 'package:ecommerce_seller_app/views/widgets/loading_indicator.dart';
import 'package:get/get.dart';

import '../widgets/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;

  const EditProfileScreen({super.key, this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username ?? '';
    super.initState();
  }

  bool isObscure = true;
  bool isObscure_rp = true;

  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: purpleColor,
          title: boldText(text: editProfile, color: whiteColor, size: 18.0),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            controller.isloading.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: loadingIndicator(color: whiteColor)),
                  )
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      // If image is not selected..
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      // Update the profile information without changing the password
                      await controller.updateProfile(
                        imgUrl: controller.profileImageLink,
                        name: controller.nameController.text,
                      );

                      VxToast.show(context,
                          msg: "Profile Updated Successfully");

                      controller.isloading(false);
                    },
                    child: Icon(
                      Icons.save,
                      size: 25,
                      color: whiteColor,
                    ),
                  )
          ],
        ),
        body: DismissKeyboardOnTap(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(children: [
                controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImgPath.isEmpty
                    ? Image.asset(icProduct, width: 100, fit: BoxFit.cover)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(
                            controller.snapshotData['imageUrl'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.file(
                            File(controller.profileImgPath.value),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: changeImage, color: whiteColor),
                ),
                10.heightBox,
                Divider(
                  color: darkFontGrey,
                ),
                customTextField(
                  keyboardType: TextInputType.text,
                  hint: "Change your user name",
                  title: "User Name",
                  controller: controller.nameController,
                  sIcon: Icon(
                    Icons.edit,
                    color: redColor,
                    size: 25,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
