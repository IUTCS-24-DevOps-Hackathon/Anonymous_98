import 'package:ecommerce_app/consts/consts.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  Icon? sIcon,
  Widget? eIcon,
  bool isObscured=false,
  TextInputType? keyboardType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title!,
        style: TextStyle(
          color: darkFontGrey,
          fontFamily: semibold,
          fontSize: 16,
        ),
      ),
      SizedBox(height: 5),
      TextFormField(
        obscureText: isObscured,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: sIcon,
          suffixIcon: eIcon,
          hintStyle: TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: whiteColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: redColor,
              width: 2.5,
            ),
          ),
        ),
      ),
      SizedBox(height: 5),
    ],
  );
}
