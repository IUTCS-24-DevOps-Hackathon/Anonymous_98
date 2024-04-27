import 'dart:io';

import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/widgets/background_widget.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:ecommerce_app/widgets/custom_textfield.dart';
import 'package:ecommerce_app/widgets/dismiss_keyboard_on_tap.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isObscure_op = true;
  bool isObscure_np = true;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return DismissKeyboardOnTap(
      child: backgroundWidget(
          child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: purpleColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: DismissKeyboardOnTap(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.data['imageUrl'] == '' &&
                          controller.profileImgPath.isEmpty
                      ? Image.asset(imgProfile2, width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                      : widget.data['imageUrl'] != '' &&
                              controller.profileImgPath.isEmpty
                          ? Image.network(
                              widget.data['imageUrl'],
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
                  button(
                      color: purpleColor,
                      onPress: () {
                        controller.changeImage(context);
                      },
                      textColor: whiteColor,
                      title: "Change"),
                  const Divider(),
                  customTextField(
                      hint: nameHint,
                      title: name,
                      sIcon: Icon(
                        Icons.edit,
                        color: redColor,
                        size: 25,
                      ),
                      controller: controller.nameController),
                  5.heightBox,
                  "Reset Password"
                      .text
                      .tight
                      .color(darkFontGrey)
                      .size(18)
                      .fontFamily(semibold)
                      .makeCentered(),
                  customTextField(
                    keyboardType: TextInputType.text,
                      hint: passwordHint,
                      title: oldpass,
                      sIcon: Icon(
                        Icons.password,
                        color: redColor,
                        size: 25,
                      ),
                      isObscured: isObscure_op,
                      eIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure_op = !isObscure_op;
                          });
                        },
                        child: Icon(
                          size: 25,
                          color: redColor,
                          isObscure_op ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      controller: controller.oldpassController),
                  10.heightBox,
                  customTextField(
                      isObscured: isObscure_np,
                      hint: passwordHint,
                      title: newpass,
                      sIcon: Icon(
                        Icons.password,
                        color: redColor,
                        size: 25,
                      ),
                      eIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure_np = !isObscure_np;
                          });
                        },
                        child: Icon(
                          size: 25,
                          color: redColor,
                          isObscure_np
                              ? (Icons.visibility)
                              : Icons.visibility_off,
                        ),
                      ),
                      controller: controller.newpassController),
                  20.heightBox,
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : SizedBox(
                          width: context.screenWidth - 60,
                          child: button(
                            color: purpleColor,
                            onPress: () async {
                              controller.isloading(true);
        
                              //If image is not selected..
                              if (controller.profileImgPath.value.isNotEmpty) {
                                await controller.uploadProfileImage();
                              } else {
                                controller.profileImageLink =
                                    widget.data['imageUrl'];
                              }
        
                              // Check if the new password is provided
                              if (controller.newpassController.text.isNotEmpty) {
                                // Check if the old password matches the database
                                if (widget.data['password'] ==
                                    controller.oldpassController.text) {
                                  await controller.changeAuthPassword(
                                      email: widget.data['email'],
                                      password: controller.oldpassController.text,
                                      newpassword:
                                          controller.newpassController.text);
        
                                  // Update the profile information with the new password
                                  await controller.updateProfile(
                                      imgUrl: controller.profileImageLink,
                                      name: controller.nameController.text,
                                      password:
                                          controller.newpassController.text);
                                } else {
                                  // Show error message if old password is provided and doesn't match
                                  // ignore: use_build_context_synchronously
                                  VxToast.show(context,
                                      msg:
                                          "Old password does not match! Enter valid one.");
                                  controller.isloading(false);
                                  return;
                                }
                              } else {
                                // No need to enter old password for changing image and name
                                await controller.updateProfile(
                                    imgUrl: controller.profileImageLink,
                                    name: controller.nameController.text,
                                    password: (controller
                                            .newpassController.text.isNotEmpty)
                                        ? controller.newpassController.text
                                        : widget.data['password']);
                              }
        
                              // ignore: use_build_context_synchronously
                              VxToast.show(context, msg: "Update Successfully");
                            },
                            textColor: whiteColor,
                            title: "Save",
                          ),
                        )
                ],
              )
                  .box
                  .white
                  .shadow
                  .padding(const EdgeInsets.all(16))
                  .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                  .rounded
                  .make(),
            ),
          ),
        ),
      )),
    );
  }
}
