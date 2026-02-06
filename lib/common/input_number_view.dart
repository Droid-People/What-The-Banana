import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_text_styles.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_utils.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class InputNumberView extends StatefulWidget {
  const InputNumberView({
    required this.title,
    required this.rangeLabel,
    required this.min,
    required this.max,
    required this.readCurrentNumber,
    required this.onSubmit,
    required this.goNext,
    super.key,
  });

  final String title;
  final String rangeLabel;
  final int min;
  final int max;
  final int Function() readCurrentNumber;
  final void Function(int) onSubmit;
  final void Function(int) goNext;

  @override
  State<InputNumberView> createState() => _InputNumberViewState();
}

class _InputNumberViewState extends State<InputNumberView> {
  final TextEditingController inputNumberController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
      final number = widget.readCurrentNumber();
      if (number == 0) return;
      inputNumberController.text = number.toString();
    });
  }

  @override
  void dispose() {
    inputNumberController.dispose();
    focusNode.dispose();
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
            Text(
              widget.title,
              style: ghostLegTitleTextStyle,
            ).tr(),
            Text(
              widget.rangeLabel,
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
                  NumberRangeFormatter(min: widget.min, max: widget.max),
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
                  _goNext();
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
              onTap: _goNext,
              child: SvgPicture.asset(Assets.images.next, width: 50),
            ),
          ],
        ),
      ),
    );
  }

  void _goNext() {
    if (inputNumberController.text.isNotEmpty) {
      final number = int.parse(inputNumberController.text);
      widget.onSubmit(number);
      widget.goNext(number);
    }
  }
}
