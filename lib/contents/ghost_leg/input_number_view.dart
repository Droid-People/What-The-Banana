import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_utils.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class InputNumberView extends StatefulWidget {
  const InputNumberView(this.focusNode, {required this.callback, super.key});

  final void Function(int) callback;

  final FocusNode focusNode;

  @override
  State<InputNumberView> createState() => _InputNumberViewState();
}

class _InputNumberViewState extends State<InputNumberView> {
  final TextEditingController inputNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        30.verticalSpace,
        const Text('input_participant_number', style: TextStyle(fontSize: 22),).tr(),
        const Text('(2~7)', style: TextStyle(fontSize: 22)),
        70.verticalSpace,
        SizedBox(
          width: 100,
          child: TextField(
            controller: inputNumberController,
            keyboardType: TextInputType.number,
            focusNode: widget.focusNode,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberRangeFormatter(min: 2, max: 7),
            ],
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide:  BorderSide(
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
              if (inputNumberController.text.isNotEmpty) {
                widget.focusNode.unfocus();
                widget.callback(int.parse(inputNumberController.text));
              }
            },
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
      ],
    );
  }
}
