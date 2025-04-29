import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_text_styles.dart';

class InputTextViews extends StatefulWidget {
  const InputTextViews(
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
  State<InputTextViews> createState() => _InputTextViewsState();
}

class _InputTextViewsState extends State<InputTextViews> {
  late List<TextEditingController> textEditingControllers;
  late List<FocusNode> focusNodes;
  late List<String> textList;

  @override
  void initState() {
    textEditingControllers = List.generate(widget.count, (index) => TextEditingController());
    focusNodes = List.generate(widget.count, (index) => FocusNode());
    textList = List.generate(widget.count, (index) => '');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
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
            100.verticalSpace,
            FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
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
                              if (index == widget.count - 1) {
                                widget.goNext(
                                  textEditingControllers.map((controller) => controller.text).toList(),
                                );
                              } else {
                                focusNodes[index + 1].requestFocus();
                              }
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
