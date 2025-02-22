import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class CustomMarquee extends StatefulWidget {
  const CustomMarquee({super.key});

  @override
  State<CustomMarquee> createState() => _CustomMarqueeState();
}

class _CustomMarqueeState extends State<CustomMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  double textWidth = 0;

  static const String marqueeText =
      'WHAT THE BANXNX WHAT THE BANXNX WHAT THE BANXNX WHAT THE BANXNX ';

  @override
  void initState() {
    super.initState();

    // AnimationController 설정
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // 한 바퀴 스크롤 시간
    )..repeat(); // 무한 반복

    _scrollController = ScrollController();

    // 애니메이션과 스크롤 연결
    _controller.addListener(() {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final progress = _controller.value;
        _scrollController.jumpTo(progress * maxScroll);
      }
    });

    // 텍스트 너비 계산을 위해 위젯 빌드 후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextWidth();
    });
  }

  // 텍스트 너비 계산
  void _calculateTextWidth() {
    const textSpan = TextSpan(
      text: marqueeText,
      style: TextStyle(
        fontSize: 8,
        fontFamily: FontFamily.inter,
        overflow: TextOverflow.visible,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    setState(() {
      textWidth = textPainter.width;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Marquee 높이
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(), // 사용자 스크롤 비활성화
        child: Row(
          children: _buildInfiniteText(),
        ),
      ),
    );
  }

  // 텍스트를 반복하여 무한 루프처럼 보이게 만듦
  List<Widget> _buildInfiniteText() {
    if (textWidth == 0) {
      return [
        Column(
          children: [
            LongText(),
            LongText(),
            LongText(),
            LongText(),
          ],
        ),
      ]; // 초기 렌더링 시
    }

    final screenWidth = MediaQuery.of(context).size.width;
    // 화면 너비와 텍스트 너비를 기반으로 필요한 반복 횟수 계산
    final repeatCount = (screenWidth / textWidth).ceil() + 1;

    return List.generate(
      repeatCount * 2, // 충분히 많은 반복으로 끊김 방지
      (index) => Column(
        children: [
          LongText(),
          LongText(),
          LongText(),
          LongText(),
        ],
      ),
    );
  }

  Widget LongText() {
    return const Text(
      marqueeText,
      style: TextStyle(
        color: Colors.black,
        fontSize: 8,
        fontFamily: FontFamily.inter,
        height: 9.5 / 8,
        overflow: TextOverflow.visible,
      ),
    );
  }
}
