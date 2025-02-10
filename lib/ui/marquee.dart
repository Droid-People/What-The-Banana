import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
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
    )..repeat(reverse: false);

    _animation = Tween<double>(
      begin: 1,
      end: -1.5,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorName.homeTopBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    _animation.value * MediaQuery.of(context).size.width, 0),
                child: child,
              );
            },
            child: const SingleChildScrollView(
              child: Text(
                'WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX WHAT TH BXNXNX',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  fontFamily: FontFamily.inter,
                  height: 9.5/8,
                  overflow: TextOverflow.visible,
                ),
                softWrap: false,
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
