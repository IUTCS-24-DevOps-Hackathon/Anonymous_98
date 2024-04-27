import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/views/home_screen/home.dart';
import 'package:ecommerce_app/widgets/dismiss_keyboard_on_tap.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';
import '../../widgets/applogo_widget.dart';
import '../../widgets/button.dart';
import '../../widgets/check_box.dart';
import '../../widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  bool isObscure = true;
  bool isObscure_rp = true;
  var controller = Get.put(AuthController());

  //Text controllers...

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardOnTap(
      child: Scaffold(
        backgroundColor: Vx.purple100,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Join to the  $appname"
                  .text
                  .fontFamily(bold)
                  .color(darkFontGrey)
                  .size(18)
                  .make(),
              25.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      keyboardType: TextInputType.name,
                      sIcon: Icon(
                        Icons.edit,
                        color: redColor,
                        size: 25,
                      ),
                      hint: nameHint,
                      title: name,
                      controller: nameController,
                    ),
                    customTextField(
                      keyboardType: TextInputType.emailAddress,
                      sIcon: Icon(
                        Icons.email,
                        color: redColor,
                        size: 25,
                      ),
                      hint: emailHint,
                      title: email,
                      controller: emailController,
                    ),
                    customTextField(
                      isObscured: isObscure,
                      eIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        child: Icon(
                          size: 25,
                          color: redColor,
                          isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                      sIcon: passwordController.text.isEmpty == true
                          ? Icon(
                              Icons.password,
                              color: redColor,
                              size: 25,
                            )
                          : passwordController.text.length < 6
                              ? Icon(
                                  Icons.warning,
                                  color: redColor,
                                  size: 25,
                                )
                              : Icon(
                                  Icons.password,
                                  color: redColor,
                                  size: 25,
                                ),
                      hint: passwordHint,
                      title: password,
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                    ),
                    customTextField(
                      sIcon: passwordRetypeController.text.isEmpty == true
                          ? Icon(
                              Icons.password,
                              color: redColor,
                              size: 25,
                            )
                          : passwordController.text ==
                                  passwordRetypeController.text
                              ? Icon(
                                  Icons.check,
                                  color: redColor,
                                  size: 25,
                                )
                              : Icon(
                                  Icons.close,
                                  color: redColor,
                                  size: 25,
                                ),
                      isObscured: isObscure_rp,
                      eIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isObscure_rp = !isObscure_rp;
                          });
                        },
                        child: Icon(
                          size: 25,
                          color: redColor,
                          isObscure_rp
                              ? (Icons.visibility)
                              : Icons.visibility_off,
                        ),
                      ),
                      hint: retypePasswordHint,
                      title: retypePassword,
                      controller: passwordRetypeController,
                      keyboardType: TextInputType.text,
                    ),
                    10.heightBox,
                    Row(
                      children: [
                        CustomCheckbox(
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue;
                            });
                          },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: const TextSpan(children: [
                            TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: termsAndConditions,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                )),
                            TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                )),
                            TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: redColor,
                                ))
                          ])),
                        )
                      ],
                    ),
                    15.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : button(
                            color: isCheck == true ? redColor : lightGrey,
                            title: signup,
                            textColor:
                                isCheck == false ? Colors.grey : whiteColor,
                            onPress: () async {
                              if (isCheck != false) {
                                if (nameController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    passwordRetypeController.text.isEmpty) {
                                  VxToast.show(context,
                                      msg: 'Please fill all fields',
                                      bgColor: Vx.black,
                                      textColor: whiteColor,
                                      textSize: 18,
                                      position: VxToastPosition.bottom,
                                      pdHorizontal: 40,
                                      pdVertical: 20);
                                } else if (passwordController.text !=
                                    passwordRetypeController.text) {
                                  VxToast.show(context,
                                      msg: 'Password does not match',
                                      bgColor: Vx.black,
                                      textColor: whiteColor,
                                      textSize: 18,
                                      position: VxToastPosition.bottom,
                                      pdHorizontal: 40,
                                      pdVertical: 20);
                                } else {
                                  controller.isloading(true);
                                  try {
                                    await controller
                                        .signupMethod(
                                      context: context,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    )
                                        .then((value) {
                                      return controller.storeUserData(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                      );
                                    }).then((value) {
                                      VxToast.show(context, msg: loggedin);
                                      Get.offAll(() => const Home());
                                    });
                                  } catch (e) {
                                    auth.signOut();
                                    VxToast.show(context,
                                        msg: e.toString(), bgColor: Vx.red900);
                                    controller.isloading(false);
                                  }
                                }
                              }
                            }).box.width(context.screenWidth - 15).make(),
                    10.heightBox,
                    RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: alreadyHaveAccount,
                          style:
                              TextStyle(fontFamily: bold, color: darkFontGrey)),
                      TextSpan(
                          text: login,
                          style: TextStyle(fontFamily: bold, color: redColor))
                    ])).onTap(() {
                      Get.back();
                    })
                  ],
                )
                    .box
                    .green50
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowMax
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
