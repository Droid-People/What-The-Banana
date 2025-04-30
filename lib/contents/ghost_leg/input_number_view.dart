import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_state_provider.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_text_styles.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_utils.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class InputNumberView extends ConsumerStatefulWidget {
  const InputNumberView({required this.goNext, super.key});

  final void Function(int) goNext;

  @override
  ConsumerState<InputNumberView> createState() => _InputNumberViewState();
}

class _InputNumberViewState extends ConsumerState<InputNumberView> with WidgetsBindingObserver {
  final TextEditingController inputNumberController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
      final number = ref.read(ghostLegStateProvider).number;
      if (number == 0) return;
      inputNumberController.text = number.toString();
    });
    super.initState();
  }

  @override
  void dispose() {
    inputNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: focusNode.unfocus,
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          children: [
            30.verticalSpace,
            const Text(
              'input_participant_number',
              style: ghostLegTitleTextStyle,
            ).tr(),
            const Text(
              '(2~7)',
              style: ghostLegTitleTextStyle,
            ),
            70.verticalSpace,
            SizedBox(
              width: 100,
              child: TextField(
                controller: inputNumberController,
                keyboardType: TextInputType.number,
                focusNode: focusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  NumberRangeFormatter(min: 2, max: 7),
                ],
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                    ),
                  ),
                ),
                onSubmitted: (text) {
                  goNext();
                },
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontSize: 96,
                  fontFamily: FontFamily.ssronet,
                  fontFamilyFallback: [FontFamily.unkemptBold, FontFamily.inter],
                  height: 1,
                ),
                textAlign: TextAlign.center,
                cursorColor: const Color(0x77000000),
              ),
            ),
            40.verticalSpace,
            GestureDetector(
              onTap: goNext,
              child: SvgPicture.asset(Assets.images.next, width: 50),
            ),
          ],
        ),
      ),
    );
  }

  void goNext() {
    if (inputNumberController.text.isNotEmpty) {
      ref.read(ghostLegStateProvider.notifier).setNumber(int.parse(inputNumberController.text));
      widget.goNext(int.parse(inputNumberController.text));
    }
  }
}
