import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/common/logger.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int left = 0;
  int right = 0;
  bool isHidden = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Offset dragStartOffset = Offset.zero;
  final leftTextController = TextEditingController();
  final rightTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isSpecial = getIsSpecial(context);
    if (isSpecial) {
      leftTextController.text = '아바드\n(27-)';
      rightTextController.text = '파카드\n(20-26)';
    }

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              GestureDetector(
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
                  if (dy > 0) {
                    setState(() {
                      left--;
                    });
                  } else {
                    setState(() {
                      left++;
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
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 64),
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
                              maxLines: isSpecial ? 2 : 1,
                              cursorColor: Colors.white,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Name 1',
                                hintStyle:
                                    TextStyle(fontSize: 24, color: Colors.white),
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
              ),
              GestureDetector(
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
                  if (dy > 0) {
                    setState(() {
                      right--;
                    });
                  } else {
                    setState(() {
                      right++;
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
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 64),
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
                              maxLines: isSpecial ? 2 : 1,
                              cursorColor: Colors.white,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Name 2',
                                hintStyle:
                                    TextStyle(fontSize: 24, color: Colors.white),
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
              ),
            ],
          ),
          Visibility(
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
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
