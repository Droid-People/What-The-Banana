import 'package:flutter/material.dart';
import 'package:what_the_banana/contents/ghost_leg/input_number_view.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';

class GhostLegScreen extends StatefulWidget {
  const GhostLegScreen({super.key});

  @override
  State<GhostLegScreen> createState() => _GhostLegScreenState();
}

class _GhostLegScreenState extends State<GhostLegScreen> {
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();

  int _currentPage = 0;
  int number = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghost Leg'),
        leading: BackImage(context),
      ),
      body: GestureDetector(
        onTap: _focusNode.unfocus,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: screenHeight * 0.7,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      InputNumberView(
                        _focusNode,
                        callback: (number) {
                          setState(() {
                            this.number = number;
                          });
                        },
                      ),
                      InputNames(),
                      InputRewards(),
                      ShowResults(),
                    ],
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
                Assets.images.bananaOnPlate.image(width: 51),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ShowResults() {
    return ColoredBox(
      color: Colors.yellow,
      child: Center(
        child: Text(
          '화면 4',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  ColoredBox InputRewards() {
    return ColoredBox(
      color: Colors.red,
      child: Center(
        child: Text(
          '화면 3',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  ColoredBox InputNames() {
    return ColoredBox(
      color: Colors.green,
      child: Center(
        child: Text(
          '화면 2',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  // 다음 페이지로 이동
  void _nextPage() {
    if (_currentPage < 3) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }

  // 이전 페이지로 이동
  void _previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }
}
