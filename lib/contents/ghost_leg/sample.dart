import 'dart:math';

import 'package:flutter/material.dart';
import 'package:what_the_banana/common/logger.dart';

void main() {
  runApp(const LadderGameApp());
}

class LadderGameApp extends StatelessWidget {
  const LadderGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LadderGameScreen(),
    );
  }
}

class LadderGameScreen extends StatefulWidget {
  const LadderGameScreen({super.key});

  @override
  State<LadderGameScreen> createState() => _LadderGameScreenState();
}

class _LadderGameScreenState extends State<LadderGameScreen> with SingleTickerProviderStateMixin {
  int numberOfLines = 7;
  List<List<int>> ladder = [];
  List<String> players = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  List<String> results = ['1', '2', '3', '4', '5', '6', '7'];
  bool showResult = false;
  int? selectedStart;
  AnimationController? _controller;
  Animation<double>? _animation;
  List<List<int>> pathPoints = []; // [col, row] for animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!);
    generateLadder();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  static const ladderRowCount = 12;

  void generateLadder() {
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
    // print ladder
    for (var row in ladder) {
      Log.i(row);
    }

    setState(() {
      showResult = false;
      selectedStart = null;
      pathPoints = [];
      _controller?.reset();
    });
  }

  void calculatePath(int start) {
    pathPoints = [];
    final current = [start, 0];
    pathPoints.add([start, 0]);
    Log.i('first: ${pathPoints}');
    // Main ladder
    var hasLeft = false;
    while (current[1] != ladderRowCount) {
      // 연결된 선이 없으면 아래로 내려간다.
      // 아래로 내려가면서 연결된 선이 있는지 확인한다.
      // 연결된 선이 있으면 그 선을 따라 이동한다.
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
      showResult = true;
      _controller?.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('사다리 게임'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Start point selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    numberOfLines,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStart = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedStart == index ? Colors.blue : null,
                        ),
                        child: Text('시작 ${index + 1}'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Player input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    numberOfLines,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: players[index]),
                          onChanged: (value) {
                            setState(() {
                              players[index] = value.isEmpty ? '플레이어 ${index + 1}' : value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Ladder
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 600,
                height: screenHeight / 2,
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  painter: LadderPainter(
                    ladder,
                    numberOfLines,
                    showResult,
                    pathPoints,
                    selectedStart,
                    _animation?.value ?? 0.0,
                  ),
                  size: Size(600, screenHeight / 2),
                ),
              ),
            ),
            // Results
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    numberOfLines,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 50,
                        child: Text(
                          results[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: generateLadder,
                    child: const Text('리셋'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showResult = false;
                        // selectedStart = null;
                        pathPoints = [];
                        _controller?.reset();
                      });
                    },
                    child: const Text('경로 지우기'),
                  ),
                  ElevatedButton(
                    onPressed: selectedStart != null ? () => calculatePath(selectedStart!) : null,
                    child: const Text('시작'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LadderPainter extends CustomPainter {
  LadderPainter(
      this.ladder,
      this.numberOfLines,
      this.showResult,
      this.pathPoints,
      this.selectedStart,
      this.animationValue,
      );

  final List<List<int>> ladder;
  final int numberOfLines;
  final bool showResult;
  final List<List<int>> pathPoints;
  final int? selectedStart;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final pathPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;
    final lineSpacing = width / (numberOfLines - 1);
    final rowHeight = height / 12;

    // Draw vertical lines
    for (var i = 0; i < numberOfLines; i++) {
      canvas.drawLine(
        Offset(i * lineSpacing, 0),
        Offset(i * lineSpacing, height),
        paint,
      );
    }

    for (var row = 0; row < ladder.length; row++) {
      for (var col = 0; col < ladder[row].length; col++) {
        final y = row * rowHeight;
        if (ladder[row][col] == 1) {
          canvas.drawLine(
            Offset(col * lineSpacing, y),
            Offset((col + 1) * lineSpacing, y),
            paint,
          );
        } else if (ladder[row][col] == 2 && col < numberOfLines - 1) {
          canvas.drawLine(
            Offset(col * lineSpacing, y),
            Offset((col + 1) * lineSpacing, y - rowHeight),
            paint,
          );
        } else if (ladder[row][col] == 3 && col < numberOfLines - 1) {
          canvas.drawLine(
            Offset(col * lineSpacing, y),
            Offset((col + 1) * lineSpacing, y + rowHeight),
            paint,
          );
        }
      }
    }

    // Draw animated path
    if (showResult && selectedStart != null && pathPoints.isNotEmpty) {
      final path = Path();
      final maxSteps = pathPoints.length.toDouble();
      final steps = (maxSteps * animationValue).ceil();
      if (steps > 0) {
        path.moveTo(pathPoints[0][0] * lineSpacing, pathPoints[0][1] * rowHeight);
        for (var i = 1; i < steps && i < pathPoints.length; i++) {
          path.lineTo(pathPoints[i][0] * lineSpacing, pathPoints[i][1] * rowHeight);
        }
        canvas.drawPath(path, pathPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
