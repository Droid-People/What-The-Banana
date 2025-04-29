import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/data/firestore_provider.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/routes.dart';
import 'package:what_the_banana/ui/back_button.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorName.yellowBackground,
          leading: BackImage(context),
        ),
        backgroundColor: ColorName.yellowBackground,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'feedback_title',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: FontFamily.hannah,
                      fontSize: 60,
                    ),
                  ).tr(),
                  Text(
                    'feedback_description',
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ).tr(),
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: TextField(
                      controller: _feedbackController,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 2,
                          ),
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: sendFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'send_feedback',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ).tr(),
                  ),
                ],
              ),
              Assets.images.smallBananaOnPlate.image(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendFeedback() async {
    final result = await ref
        .read(addFeedbackProvider.notifier)
        .addFeedback(_feedbackController.text);
    if (result) {
      if (!mounted) return;
      context.go(Routes.feedback + Routes.sentSuccess);
    }
  }
}
