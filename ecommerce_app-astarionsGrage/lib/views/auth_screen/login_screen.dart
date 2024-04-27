import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/views/auth_screen/signup_screen.dart';
import 'package:ecommerce_app/widgets/applogo_widget.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:ecommerce_app/widgets/custom_textfield.dart';
import 'package:ecommerce_app/widgets/dismiss_keyboard_on_tap.dart';
import 'package:get/get.dart';

import '../home_screen/home.dart';

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
    return DismissKeyboardOnTap(
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Login to  $appname"
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
                          Icons.password,
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
                            onPressed: () {},
                            child: forgetPassword.text.make())),
                    5.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : button(
                            color: redColor,
                            title: login,
                            textColor: whiteColor,
                            onPress: () async {
                              controller.isloading(true);
                              await controller
                                  .loginMethod(context: context)
                                  .then((value) {
                                if (value != null) {
                                  VxToast.show(context, msg: loggedin);
                                  Get.offAll(() => const Home());
                                } else {
                                  controller.isloading(false);
                                }
                              });
                            },
                          ).box.width(context.screenWidth - 15).make(),
                    10.heightBox,
                    createNewAccount.text.color(Vx.black).make(),
                    5.heightBox,
                    button(
                        color: Vx.black,
                        title: signup,
                        textColor: whiteColor,
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        }).box.width(context.screenWidth - 15).make(),
                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircleAvatar(
                                  backgroundColor: whiteColor,
                                  radius: 25,
                                  child: Image.asset(
                                    socialIconList[index],
                                    width: 30,
                                  ),
                                ),
                              )),
                    )
                  ],
                )
                    .box
                    .green50
                    .shadowMax
                    .rounded
                    .padding(EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .makeCentered(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
