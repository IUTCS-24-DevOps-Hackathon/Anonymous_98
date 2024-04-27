import 'package:ecommerce_seller_app/controllers/auth_controller.dart';
import 'package:ecommerce_seller_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_seller_app/views/home_screen/home.dart';
import 'package:ecommerce_seller_app/views/widgets/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../const/const.dart';
import '../widgets/app_logo.dart';
import '../widgets/button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/dismiss_keyboard_on_tap.dart';
import '../widgets/loading_indicator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Password reset link is sent. Check you email!!"),
        );
      });
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: "${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return DismissKeyboardOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reset Password"),
          backgroundColor: purpleColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.offAll(() => LoginScreen());
            },
          ),
        ),
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                25.heightBox,
                Column(
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
                        controller: _emailController),
                    5.heightBox,
                    button(
                      color: purpleColor,
                      title: "Reset Password",
                      textColor: whiteColor,
                      onPress: passwordReset,
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
