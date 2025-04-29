import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_state_provider.dart';
import 'package:what_the_banana/contents/ghost_leg/input_number_view.dart';
import 'package:what_the_banana/contents/ghost_leg/input_text_views.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';

class GhostLegScreen extends ConsumerStatefulWidget {
  const GhostLegScreen({super.key});

  @override
  ConsumerState<GhostLegScreen> createState() => _GhostLegScreenState();
}

class _GhostLegScreenState extends ConsumerState<GhostLegScreen> {

  int _currentPage = 0;
  int number = 0;
  List<String> nameList = [];
  List<String> rewardList = [];

  @override
  void dispose() {
    ref.read(ghostLegStateProvider.notifier).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ghostLegStateProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ghost_leg_title',
          textAlign: TextAlign.center,
        ).tr(),
        leading: BackImage(
          context,
          onTap: () {
            if (state.pageController.page == 0) {
              Navigator.pop(context);
            } else {
              _previousPage(state);
            }
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight * 0.7,
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
                  InputTextViews(
                    'input_name',
                    number,
                    goPrevious: () => _previousPage(state),
                    goNext: (nameList) {
                      this.nameList = nameList;
                      _nextPage(state);
                    },
                  ),
                  InputTextViews(
                    'input_reward',
                    number,
                    goPrevious: () => _previousPage(state),
                    goNext: (rewardList) {
                      this.rewardList = rewardList;
                      _nextPage(state);
                    },
                  ),
                  ShowResults(),
                ],
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 31),
              child: Assets.images.bananaOnPlate.image(width: 51),
            ),
          ],
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

  // 다음 페이지로 이동
  void _nextPage(GhostLegState state) {
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
  void _previousPage(GhostLegState state) {
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
}
