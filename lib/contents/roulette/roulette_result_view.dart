import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

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
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
  ];

  @override
  void initState() {
    items = widget.items
        .asMap()
        .entries
        .map(
          (entry) => FortuneItem(
        child: Text(entry.value, style: const TextStyle(fontSize: 20)),
        style: FortuneItemStyle(
          color: colors[entry.key % colors.length],
          borderWidth: 2,
        ),
      ),
    )
        .toList();
    rotate(); // 초기 선택 인덱스 설정
    super.initState();
  }

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

    return Center(
      child: GestureDetector(
        onTap: rotate,
        child: SizedBox(
          width: wheelSize,
          height: wheelSize,
          child: FortuneWheel(
            selected: selected.stream,
            items: items,
          ),
        ),
      ),
    );
  }
}
