import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/routes.dart';

class SentSuccessScreen extends StatefulWidget {
  const SentSuccessScreen({super.key});

  @override
  State<SentSuccessScreen> createState() => _SentSuccessScreenState();
}

class _SentSuccessScreenState extends State<SentSuccessScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      context.go(Routes.home);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.homeMainBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'feedback_sent_success',
              style: Theme.of(context).textTheme.bodyLarge,
            ).tr(),
            const SizedBox(height: 20),
            Assets.images.checked.image(
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
