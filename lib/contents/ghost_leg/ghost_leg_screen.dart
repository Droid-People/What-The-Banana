import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_result_view.dart';
import 'package:what_the_banana/contents/ghost_leg/input_number_view.dart';
import 'package:what_the_banana/contents/ghost_leg/input_text_view.dart';
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
            onBackPressed(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight * 0.75,
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
                    'input_name',
                    number,
                    goPrevious: () => _previousPage(),
                    goNext: (nameList) {
                      this.nameList = nameList;
                      _nextPage();
                    },
                  ),
                  InputTextView(
                    'input_reward',
                    number,
                    goPrevious: () => _previousPage(),
                    goNext: (rewardList) {
                      this.rewardList = rewardList;
                      _nextPage();
                    },
                  ),
                  GhostLegResultView(screenHeight: screenHeight),
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
    );
  }

  void onBackPressed(BuildContext context) {
    if (_pageController.page == 0) {
      context.pop();
    } else {
      _previousPage();
    }
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
}
