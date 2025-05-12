import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_state_provider.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_text_styles.dart';
import 'package:what_the_banana/contents/ghost_leg/ladder_painter.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

class GhostLegResultView extends ConsumerStatefulWidget {
  const GhostLegResultView({required this.screenHeight, super.key});

  final double screenHeight;

  @override
  ConsumerState<GhostLegResultView> createState() => _GhostLegResultViewState();
}

class _GhostLegResultViewState extends ConsumerState<GhostLegResultView> with SingleTickerProviderStateMixin {
  List<List<int>> ladder = [];
  static const ladderRowCount = 12;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ghostLegStateProvider);
    final number = state.number;
    final names = state.names;
    final rewards = state.rewards;
    final width = number * 70;

    return Column(
      children: [
        30.verticalSpace,
        const Text('result', style: ghostLegTitleTextStyle).tr(),
        30.verticalSpace,
        AnimatedOpacity(
          opacity: showLadder ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: List.generate(number, (index) {
                    return GestureDetector(
                      onTap: () {
                        _controller?.reset();
                        selectedStart = index;
                        calculatePath(index);
                      },
                      child: Container(
                        width: (width - 40) / (number - 1),
                        alignment: Alignment.center,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                names[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: FontFamily.ssronet,
                                  fontFamilyFallback: [FontFamily.unkemptBold],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  width: width - 40,
                  height: widget.screenHeight / 2,
                  child: CustomPaint(
                    painter: LadderPainter(
                      ladder,
                      number,
                      showAnimation,
                      pathPoints,
                      selectedStart,
                      _animation?.value ?? 0.0,
                    ),
                    size: Size(width - 40, widget.screenHeight / 2),
                  ),
                ),
                8.verticalSpace,
                Row(
                  children: List.generate(number, (index) {
                    return Container(
                      width: (width - 40) / (number - 1),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          rewards[index],
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: FontFamily.ssronet,
                            fontFamilyFallback: [FontFamily.unkemptBold],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool showLadder = false;
  bool showAnimation = false;
  int? selectedStart;
  AnimationController? _controller;
  Animation<double>? _animation;
  List<List<int>> pathPoints = [];

  @override
  void initState() {
    super.initState();
    initializeAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(ghostLegStateProvider);
      generateLadder(state.number);
    });
  }

  void initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void generateLadder(int numberOfLines) {
    final colCount = numberOfLines - 1;
    ladder = List.generate(ladderRowCount, (row) => List.generate(numberOfLines, (_) => 0));

    for (var y = 0; y < ladderRowCount; y++) {
      for (var x = 0; x < colCount; x++) {
        final randoms = <int>{};
        if (x == 0) {
          if (y == 0) {
            randoms.add(0);
          } else if (ladder[y - 1][0] != 3) {
            randoms.addAll([0, 1]);
            if (ladder[y - 1][0] != 1 && ladder[y - 1][1] == 0) {
              if (y != 1) {
                randoms.add(2);
              }
            }
          }
        } else if (x < colCount) {
          if (y == 0) {
            randoms.add(0);
          } else if (y == 1) {
            if (ladder[y - 1][x - 1] == 3 || ladder[y][x - 1] == 1) {
              randoms.add(0);
              continue;
            }
            if (ladder[0][x] != 3) {
              randoms.addAll([0, 1, 3]);
            } else {
              randoms.add(0);
            }
          } else {
            if (ladder[y - 1][x - 1] == 3 || ladder[y][x - 1] == 1) {
              randoms.add(0);
              continue;
            }
            if (ladder[y - 1][x] != 1 && ladder[y - 1][x] != 3 && ladder[y - 2][x] != 3) {
              if (x == colCount - 1) {
                randoms.add(0);
              } else if (ladder[y - 1][x + 1] == 0) {
                randoms.add(2);
              }
            }
            if (ladder[y - 1][x] != 3) {
              if (y < ladderRowCount - 1) {
                randoms.addAll([1, 3]);
              } else {
                randoms.add(1);
              }
            } else {
              randoms.add(0);
            }
          }
        }

        // ramdoms 중에 하나를 선택하여 선을 그린다.
        if (randoms.isNotEmpty) {
          final randomIndex = Random().nextInt(randoms.length);
          final randomValue = randoms.toList()[randomIndex];
          ladder[y][x] = randomValue;
        }
      }
    }

    setState(() {
      showLadder = true;
      showAnimation = false;
      selectedStart = null;
      pathPoints = [];
      _controller?.reset();
    });
  }

  void calculatePath(int start) {
    pathPoints = [];
    final current = [start, 0];
    pathPoints.add([start, 0]);

    var hasLeft = false;
    while (current[1] != ladderRowCount) {
      final x = current[0];
      final y = current[1];

      final temp = ladder[y][x];

      if (temp == 0 || hasLeft) {
        hasLeft = false;
        current[1]++;
        pathPoints.add([current[0], current[1]]);

        final movedY = current[1];
        if (0 < x && movedY < ladderRowCount) {
          if (ladder[movedY][x - 1] == 1) {
            current[0]--;
            pathPoints.add([current[0], current[1]]);
            hasLeft = true;
          }
          if (movedY < ladderRowCount - 1) {
            if (ladder[movedY + 1][x - 1] == 2) {
              current[0]--;
              current[1]++;
              pathPoints.add([current[0], current[1]]);
              hasLeft = true;
            }
          }
          if (movedY > 0) {
            if (ladder[movedY - 1][x - 1] == 3) {
              current[0]--;
              current[1]--;
              pathPoints.add([current[0], current[1]]);
              hasLeft = true;
            }
          }
        }
      } else if (temp == 1) {
        current[0]++;
        pathPoints.add([current[0], current[1]]);
      } else if (temp == 2) {
        current[0]++;
        current[1]--;
        pathPoints.add([current[0], current[1]]);
      } else if (temp == 3) {
        current[0]++;
        current[1]++;
        pathPoints.add([current[0], current[1]]);
      }
    }

    setState(() {
      showAnimation = true;
      _controller?.forward();
    });
  }
}
