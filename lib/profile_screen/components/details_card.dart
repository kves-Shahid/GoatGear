import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:emart_app/consts/consts.dart';

Widget detailsCard({
  required double width,
  required String count,
  required String title,
  required Function onTap,
}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        count.text.fontFamily(bold).color(darkFontGrey).size(16).make(),
        5.heightBox,
        title.text.color(darkFontGrey).make(),
      ],
    ).box.white.rounded.width(width).height(80).padding(EdgeInsets.all(4)).make(),
  );
}
