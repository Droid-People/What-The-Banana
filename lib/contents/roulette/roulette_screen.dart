import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/roulette/input_number_view.dart';
import 'package:what_the_banana/contents/roulette/input_text_view.dart';
import 'package:what_the_banana/contents/roulette/roulette_result_view.dart';
import 'package:what_the_banana/ui/back_button.dart';

class RouletteScreen extends ConsumerStatefulWidget {
  const RouletteScreen({super.key});

  @override
  ConsumerState<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends ConsumerState<RouletteScreen> {
  int _currentPage = 0;
  int number = 0;
  List<String> rewardList = [];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Roulette'),
        leading: BackImage(
          context,
          onTap: () {
            onBackPressed(context);
          },
        ),
      ),
      body: Center(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InputNumberView(
              goNext: (number) {
                this.number = number;
                _nextPage();
              },
            ),
            InputTextView(
              'input_reward',
              number,
              goNext: (rewards) {
                rewardList = rewards;
                _nextPage();
              },
              goPrevious: () {
                _previousPage();
              },
            ),
            RouletteResultView(rewardList),
          ],
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
        duration: const Duration(milliseconds: 300),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }

  void onBackPressed(BuildContext context) {
    if (_pageController.page == 0) {
      context.pop();
    } else {
      _previousPage();
    }
  }
}
