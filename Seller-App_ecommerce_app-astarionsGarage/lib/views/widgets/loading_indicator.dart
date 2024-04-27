import '../../const/const.dart';

Widget loadingIndicator({Color? color}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(color ?? purpleColor),
  );
}


