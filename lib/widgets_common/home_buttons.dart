import 'package:emart_app/consts/consts.dart';

Widget homeButtons(double width, double height, String icon, String title, VoidCallback onPress) {
  return GestureDetector(
    onTap: onPress,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon, width: 26),
        10.heightBox,
        title.text.fontFamily(semibold).color(fontGrey).make(),
      ],
    ).box.rounded.white.size(width, height).shadow.make(),
  );
}