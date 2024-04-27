import 'package:ecommerce_seller_app/controllers/auth_controller.dart';
import 'package:ecommerce_seller_app/views/auth_screen/forgotPassword_screen.dart';
import 'package:ecommerce_seller_app/views/home_screen/home.dart';
import 'package:ecommerce_seller_app/views/widgets/text_style.dart';
import 'package:get/get.dart';

import '../../const/const.dart';
import '../widgets/app_logo.dart';
import '../widgets/button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/dismiss_keyboard_on_tap.dart';
import '../widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure_lp = true;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return DismissKeyboardOnTap(
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Login to  $appname".text.bold.color(Vx.black).size(18).make(),
                25.heightBox,
                Obx(
                  () => Column(
                    children: [
                      customTextField(
                          keyboardType: TextInputType.emailAddress,
                          sIcon: Icon(
                            Icons.email,
                            color: redColor,
                            size: 25,
                          ),
                          hint: emailHint,
                          title: email,
                          controller: controller.emailController),
                      customTextField(
                          keyboardType: TextInputType.text,
                          sIcon: Icon(
                            Icons.lock,
                            color: redColor,
                            size: 25,
                          ),
                          isObscured: isObscure_lp,
                          eIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isObscure_lp = !isObscure_lp;
                              });
                            },
                            child: Icon(
                              size: 25,
                              color: redColor,
                              isObscure_lp
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hint: passwordHint,
                          title: password,
                          controller: controller.passwordController),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                              onPressed: () {
                                Get.offAll(() => ForgotPasswordScreen());
                              },
                              child: forgotPassword.text.make())),
                      5.heightBox,
                      controller.isloading.value
                          ? loadingIndicator()
                          : button(
                              color: purpleColor,
                              title: login,
                              textColor: whiteColor,
                              onPress: () async {
                                controller.isloading(true);
                                await controller
                                    .loginMethod(context: context)
                                    .then((value) {
                                  if (value != null) {
                                    VxToast.show(context,
                                        msg: "Log in successfully");
                                    controller.isloading(false);
                                    Get.offAll(() => Home());
                                  } else {
                                    controller.isloading(false);
                                  }
                                });
                              },
                            ).box.width(context.screenWidth - 15).make(),
                    ],
                  )
                      .box
                      .green50
                      .shadow
                      .rounded
                      .padding(EdgeInsets.all(16))
                      .width(context.screenWidth - 70)
                      .makeCentered(),
                ),
                30.heightBox,
                Center(
                        child: boldText(
                            text: anyProblem, color: Vx.white, size: 16.0))
                    .box
                    .color(redColor)
                    .roundedSM
                    .shadowSm
                    .width(width - 70)
                    .height(50)
                    .make(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
