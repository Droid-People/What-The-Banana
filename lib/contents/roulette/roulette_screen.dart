import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_the_banana/contents/roulette/input_number_view.dart';
import 'package:what_the_banana/contents/roulette/input_text_view.dart';
import 'package:what_the_banana/contents/roulette/roulette_result_view.dart';
import 'package:what_the_banana/contents/roulette/roulette_state_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rouletteProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Roulette'),
        leading: BackImage(
          context,
          onTap: () {
            onBackPressed(state, context);
          },
        ),
      ),
      body: Center(
        child: PageView(
          controller: state.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InputNumberView(
              goNext: (number) {
                this.number = number;
                _nextPage(state);
              },
            ),
            InputTextView(
              'input_reward',
              number,
              goNext: (rewards) {
                rewardList = rewards;
                _nextPage(state);
              },
              goPrevious: () {
                _previousPage(state);
              },
            ),
            RouletteResultView(rewardList),
          ],
        ),
      ),
    );
  }

  // 다음 페이지로 이동
  void _nextPage(RouletteState state) {
    if (_currentPage < 3) {
      _currentPage++;
      state.pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }

  // 이전 페이지로 이동
  void _previousPage(RouletteState state) {
    if (_currentPage > 0) {
      _currentPage--;
      state.pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {});
    }
  }

  void onBackPressed(RouletteState state, BuildContext context) {
    if (state.pageController.page == 0) {
      Navigator.pop(context);
    } else {
      _previousPage(state);
    }
  }
}
