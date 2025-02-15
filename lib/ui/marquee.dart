import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class MarqueeWidget extends StatefulWidget {
  const MarqueeWidget({super.key});

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: -1,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRect(
      child: Stack(
        children: [
          // 첫 번째 텍스트
          AnimatedMarqueeText(
            animation: _animation,
            screenWidth: screenWidth,
            key: const ValueKey(1), // ✅ Key 추가
          ),

          // 두 번째 텍스트 (첫 번째보다 반 텀 늦게 시작)
          AnimatedMarqueeText(
            animation: Tween<double>(begin: 1, end: 0).animate(_controller),
            screenWidth: screenWidth,
            key: const ValueKey(2), // ✅ Key 추가
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedMarqueeText extends StatelessWidget {
  const AnimatedMarqueeText({
    required this.animation,
    required this.screenWidth,
    super.key,
  });

  final Animation<double> animation;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(animation.value * screenWidth, 0),
          child: SizedBox(
            width: screenWidth,
            child: Column(
              children: [
                LongText(),
                LongText(),
                LongText(),
                LongText(),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget LongText() {
  return const Text(
    ' WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX ',
    style: TextStyle(
      color: Colors.black,
      fontSize: 8,
      fontFamily: FontFamily.inter,
      height: 9.5 / 8,
      overflow: TextOverflow.visible,
    ),
    softWrap: false,
  );
}
