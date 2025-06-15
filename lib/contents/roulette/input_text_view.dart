import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_text_styles.dart';
import 'package:what_the_banana/contents/roulette/roulette_state_provider.dart';
import 'package:what_the_banana/gen/assets.gen.dart';

class InputTextView extends ConsumerStatefulWidget {
  const InputTextView(
    this.title,
    this.count, {
    required this.goPrevious,
    required this.goNext,
    super.key,
  });

  final String title;
  final int count;
  final void Function() goPrevious;
  final void Function(List<String>) goNext;

  @override
  ConsumerState<InputTextView> createState() => _InputTextViewsState();
}

class _InputTextViewsState extends ConsumerState<InputTextView> with WidgetsBindingObserver {
  late List<TextEditingController> textEditingControllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    textEditingControllers = List.generate(widget.count, (index) => TextEditingController());
    focusNodes = List.generate(widget.count, (index) => FocusNode());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
      for (var i = 0; i < widget.count; i++) {
        textEditingControllers[i].text = ref.read(rouletteProvider).rewards[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {
          for (final focusNode in focusNodes) {
            focusNode.unfocus();
          }
        },
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              30.verticalSpace,
              Text(widget.title, style: ghostLegTitleTextStyle).tr(),
              40.verticalSpace,
              Column(
                children: List.generate(
                  widget.count,
                  (index) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${index + 1}',
                          style: ghostLegTitleTextStyle.copyWith(fontSize: 36),
                        ),
                        20.horizontalSpace,
                        SizedBox(
                          width: screenWidth / 2,
                          child: TextField(
                            controller: textEditingControllers[index],
                            focusNode: focusNodes[index],
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onSubmitted: (value) {
                              goNext(index);
                            },
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 3),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 3),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ],
                    ),
                  ),
                )..addAll(
                  [
                    40.verticalSpace,
                    GestureDetector(
                      onTap: () {
                        if (textEditingControllers.any((controller) => controller.text.isEmpty)) {
                          return;
                        }
                        goNext(widget.count - 1);
                      },
                      child: SvgPicture.asset(Assets.images.next, width: 50),
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void goNext(int index) {
    if (index == widget.count - 1) {
      final textList = textEditingControllers.map((controller) => controller.text).toList();
      ref.read(rouletteProvider.notifier).setRewards(textList);
      widget.goNext(textList);
    } else {
      focusNodes[index + 1].requestFocus();
    }
  }
}
