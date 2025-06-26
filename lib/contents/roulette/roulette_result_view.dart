import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class RouletteResultView extends StatefulWidget {
  const RouletteResultView(this.items, {super.key});

  final List<String> items;

  @override
  State<RouletteResultView> createState() => _RouletteResultViewState();
}

class _RouletteResultViewState extends State<RouletteResultView> {
  StreamController<int> selected = StreamController<int>();
  List<FortuneItem> items = [];

  // 8개의 랜덤 색깔
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    const Color(0xFF4A2DFA),
    Colors.black,
  ];

  @override
  void initState() {
    items = widget.items
        .asMap()
        .entries
        .map(
          (entry) => FortuneItem(
            child: Text(
              entry.value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: FontFamily.inter,
              ),
            ),
            style: FortuneItemStyle(
              color: colors[entry.key % colors.length],
              borderWidth: 2,
            ),
          ),
        )
        .toList();

    super.initState();
  }

  var result = '';

  void rotate() {
    selected.add(
      Fortune.randomInt(0, items.length),
    ); // 초기 선택 인덱스 설정
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;
    final wheelSize = isLandscape ? screenHeight * 0.8 : screenWidth * 0.8;

    const resultTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1, fontFamily: FontFamily.inter);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: SizedBox(
              width: wheelSize,
              height: wheelSize,
              child: FortuneWheel(
                selected: selected.stream,
                items: items,
                onFocusItemChanged: (index) {
                  if (index >= 0 && index < items.length) {
                    result = widget.items[index];
                  }
                },
                onAnimationEnd: () {
                  setState(() {});
                },
                animateFirst: false,
                indicators: const [
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: TriangleIndicator(color: Colors.black, width: 50, height: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
          30.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('result', style: resultTextStyle).tr(),
              Text(': $result', style: resultTextStyle),
            ],
          ),
          30.verticalSpace,
          GestureDetector(
            onTap: rotate,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: const Text(
                'start',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ).tr(),
            ),
          ),
        ],
      ),
    );
  }
}
