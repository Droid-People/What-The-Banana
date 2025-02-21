import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int left = 0;
  int right = 0;
  bool isHidden = false;

  Offset dragStartOffset = Offset.zero;
  final leftTextController = TextEditingController();
  final rightTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final isSpecial = getIsSpecial(context);
    final maxLines = isSpecial ? 2 : 1;
    if (isSpecial) {
      leftTextController.text = '아바드\n(27-)';
      rightTextController.text = '파카드\n(20-26)';
    }

    if (isPortrait) {
      return VerticalView(context, maxLines);
    } else {
      return HorizontalView(context, maxLines);
    }
  }

  Scaffold HorizontalView(BuildContext context, int maxLines) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dual Counter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: BackImage(context, color: Colors.white),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              FirstCounter(context, maxLines),
              SecondCounter(context, maxLines),
            ],
          ),
          SpecialView(context),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BackImage(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget VerticalView(BuildContext context, int maxLines) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dual Counter'),
        leading: BackImage(context),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                FirstVerticalCounter(context, maxLines),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      left = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text('Clear', style: TextStyle(fontSize: 24.sp)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SecondVerticalCounter(context, maxLines),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      right = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text('Clear', style: TextStyle(fontSize: 24.sp)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding SecondVerticalCounter(BuildContext context, int maxLines) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            right++;
          });
        },
        onHorizontalDragDown: (details) {
          Log.i('onHorizontalDragDown');
          dragStartOffset = details.localPosition;
        },
        onHorizontalDragEnd: (details) {
          final changedOffset = details.localPosition;
          final dy = changedOffset.dy - dragStartOffset.dy;
          if (dy > 150) {
            setState(() {
              if (right > 0) {
                right--;
              }
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: rightTextController,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      maxLines: maxLines,
                      cursorColor: Colors.black,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: context.tr('tap_description'),
                        hintStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          height: 1,
                        ),
                        focusColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      right.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const Icon(
                      Icons.touch_app,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding FirstVerticalCounter(BuildContext context, int maxLines) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            left++;
          });
        },
        onHorizontalDragDown: (details) {
          Log.i('onHorizontalDragDown');
          dragStartOffset = details.localPosition;
        },
        onHorizontalDragEnd: (details) {
          final changedOffset = details.localPosition;
          final dy = changedOffset.dy - dragStartOffset.dy;
          if (dy > 150) {
            setState(() {
              if (left > 0) {
                left--;
              }
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 24, right: 24, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: leftTextController,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      maxLines: maxLines,
                      cursorColor: Colors.black,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: context.tr('tap_description'),
                        hintStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          height: 1,
                        ),
                        focusColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      left.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const Icon(
                      Icons.touch_app,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector SecondCounter(BuildContext context, int maxLines) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          right++;
        });
      },
      onHorizontalDragDown: (details) {
        Log.i('onHorizontalDragDown');
        dragStartOffset = details.localPosition;
      },
      onHorizontalDragEnd: (details) {
        final changedOffset = details.localPosition;
        final dy = changedOffset.dy - dragStartOffset.dy;
        if (dy > 150) {
          setState(() {
            if (right > 0) {
              right--;
            }
          });
        }
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      right.toString(),
                      style: const TextStyle(
                        fontSize: 140,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const Icon(
                      Icons.swipe_vertical_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
              child: Column(
                children: [
                  TextField(
                    controller: rightTextController,
                    style: const TextStyle(
                      fontSize: 90,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                    maxLines: maxLines,
                    cursorColor: Colors.white,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: context.tr('tap_description'),
                      hintStyle: const TextStyle(fontSize: 24, color: Colors.white),
                      focusColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                  8.verticalSpace,
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector FirstCounter(BuildContext context, int maxLines) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          left++;
        });
      },
      onHorizontalDragDown: (details) {
        Log.i('onHorizontalDragDown');
        dragStartOffset = details.localPosition;
      },
      onHorizontalDragEnd: (details) {
        final changedOffset = details.localPosition;
        final dy = changedOffset.dy - dragStartOffset.dy;
        if (dy > 150) {
          setState(() {
            if (left > 0) {
              left--;
            }
          });
        }
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      left.toString(),
                      style: const TextStyle(
                        fontSize: 140,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const Icon(
                      Icons.swipe_vertical_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.only(left: 24, right: 24, top: 64),
              child: Column(
                children: [
                  TextField(
                    controller: leftTextController,
                    style: const TextStyle(
                      fontSize: 90,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                    maxLines: maxLines,
                    cursorColor: Colors.white,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: context.tr('tap_description'),
                      hintStyle: const TextStyle(fontSize: 24, color: Colors.white),
                      focusColor: Colors.white,
                      border: InputBorder.none,
                    ),
                  ),
                  8.verticalSpace,
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Visibility SpecialView(BuildContext context) {
    final isSpecial = getIsSpecial(context);
    return Visibility(
      visible: isSpecial,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              showGuideDialog(context);
            },
            onLongPress: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    '처음 왔어요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool getIsSpecial(BuildContext context) =>
      GoRouterState.of(context).extra as bool? ?? false;

  void showGuideDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            '평화교회 청년부(4부) 예배에 오신 것을 환영합니다!',
            style: TextStyle(fontFamily: FontFamily.pixelFont, fontSize: 30),
          ),
          backgroundColor: Colors.white,
          content: Text(
            '교회 등록과 모임 참여에 관심이 있으시면\n'
            '앞쪽의 안내위원에게 말씀해 주세요!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
