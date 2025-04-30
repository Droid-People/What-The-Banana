import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_state_provider.dart';
import 'package:what_the_banana/contents/ghost_leg/ghost_leg_text_styles.dart';

class GhostLegResultView extends ConsumerStatefulWidget {
  const GhostLegResultView({required this.screenHeight, super.key});

  final double screenHeight;

  @override
  ConsumerState<GhostLegResultView> createState() => _GhostLegResultViewState();
}

class _GhostLegResultViewState extends ConsumerState<GhostLegResultView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ghostLegStateProvider);
    final number = state.number;
    final names = state.names;
    final rewards = state.rewards;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text('result', style: ghostLegTitleTextStyle).tr(),
        SizedBox(
          height: widget.screenHeight * 0.5,
          child: ListView.builder(
            itemCount: number,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${names[index]} - ${rewards[index]}'),
              );
            },
          ),
        ),
        Column(
          children: [
            Text('start', style: ghostLegTitleTextStyle.copyWith(fontWeight: FontWeight.bold)).tr(),
            4.verticalSpace,
            Container(color: Colors.black, height: 2, width: 80.w),
          ],
        ),
      ],
    );
  }
}
