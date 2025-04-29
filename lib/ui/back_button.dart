import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/gen/assets.gen.dart';

Widget BackImage(BuildContext context, {Color? color = Colors.black, void Function()? onTap}) {
  return GestureDetector(
    onTap: () {
      if (onTap != null) {
        onTap();
      } else {
        context.pop();
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SvgPicture.asset(
        Assets.images.backButton,
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
      ),
    ),
  );
}
