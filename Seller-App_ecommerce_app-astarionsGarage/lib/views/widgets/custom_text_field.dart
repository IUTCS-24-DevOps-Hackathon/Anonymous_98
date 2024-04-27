
import '../../const/const.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  Icon? sIcon,
  Widget? eIcon,
  bool isObscured=false,
  TextInputType? keyboardType,
  bool isDesc=false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title!,
        style: const TextStyle(
          color: darkFontGrey,
          fontWeight:FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        maxLines: isDesc?4:1,
        obscureText: isObscured,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: sIcon,
          suffixIcon: eIcon,
          hintStyle: const TextStyle(
            fontWeight:FontWeight.bold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: whiteColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: redColor,
              width: 2.5,
            ),
          ),
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}
