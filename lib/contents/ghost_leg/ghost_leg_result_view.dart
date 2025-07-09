import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_state_provider.dart';
import 'package:what_the_banana/contents/ghost_leg/ladder_painter.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
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
    final rewardImages = [
      Assets.images.ladderResultIcon1,
      Assets.images.ladderResultIcon2,
      Assets.images.ladderResultIcon3,
      Assets.images.ladderResultIcon4,
      Assets.images.ladderResultIcon5,
      Assets.images.ladderResultIcon6,
      Assets.images.ladderResultIcon7,
    ];
    final rewards = state.rewards;
    final longSide = MediaQuery.of(context).size.width * 0.7;

    return SingleChildScrollView(
      child: Column(
        children: [
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
                      return Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            _controller?.reset();
                            selectedStart = index;
                            calculatePath(index);
                          },
                          child: Container(
                            width: (longSide - 40) / (number - 1) - 8,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: colors[index % colors.length],
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  names[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: FontFamily.ssronet,
                                    fontFamilyFallback: [FontFamily.unkemptBold],
                                    fontWeight: FontWeight.w900,
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
                    width: longSide - 40 + 22,
                    height: widget.screenHeight / 2 - 50,
                    child: CustomPaint(
                      painter: LadderPainter(
                        ladder,
                        number,
                        showAnimation,
                        pathPoints,
                        selectedStart,
                        _animation?.value ?? 0.0,
                        flyImages,
                      ),
                      size: Size(longSide - 40, widget.screenHeight / 2),
                    ),
                  ),
                  30.verticalSpace,
                  Row(
                    children: List.generate(number, (index) {
                      return Container(
                        width: (longSide - 40) / (number - 1),
                        alignment: Alignment.center,
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.zero,
                                child: rewardImages[index].image(),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  rewards[index],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: FontFamily.ssronet,
                                    fontFamilyFallback: [FontFamily.unkemptBold],
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                                  // maxLines: 1,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
      ),
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
    loadFlyImages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(ghostLegStateProvider);
      generateLadder(state.number);
    });
  }

  void initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!);
  }

  List<ui.Image> flyImages = [];

  Future<void> loadFlyImages() async {
    Future<ui.Image> makeImage(Color c, int index) async {
      final flyLoader = SvgAssetLoader('assets/images/fly.svg', colorMapper: ColorMapperBase(index));
      final info = await vg.loadPicture(flyLoader, null);
      final img = await info.picture.toImage(22, 22);
      info.picture.dispose();
      return img;
    }

    // 여러 색을 병렬로 한꺼번에 로드
    final futures = List.generate(colors.length, (index) => makeImage(colors[index], index));
    flyImages = await Future.wait(futures);

    setState(() {});
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

const firstColor = Color(0xFFFF0000);
const secondColor = Color(0xFFFF7700);
const thirdColor = Color(0xFFF4CE23);
const fourthColor = Color(0xFF6CBA4F);
const fifthColor = Color(0xFF1363E3);
const sixthColor = Color(0xFF9000FF);
const seventhColor = Color(0xFF000000);

final colors = [
  firstColor,
  secondColor,
  thirdColor,
  fourthColor,
  fifthColor,
  sixthColor,
  seventhColor,
];

class ColorMapperBase extends ColorMapper {
  const ColorMapperBase(this.index);

  final int index;

  @override
  ui.Color substitute(String? id, String elementName, String attributeName, ui.Color color) {
    return colors[index];
  }
}
