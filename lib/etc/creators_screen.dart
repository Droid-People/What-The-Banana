import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/ui/banana_background.dart';

class CreatorsScreen extends ConsumerWidget {
  const CreatorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creators = [
      Creator(
        name: 'boring-km',
        description: 'Developer',
        image: Assets.images.starButterfly.path,
      ),
      Creator(
        name: 'whk06061',
        description: 'Developer',
        image: Assets.images.hyegyeongProfile.path,
      ),
      Creator(
        name: 'yewon-yw',
        description: 'Developer',
        image: Assets.images.yewonProfile.path,
      ),
      Creator(
        name: 'SnowBun',
        description: 'Developer',
        image: Assets.images.snowbun.path,
      ),
      Creator(
        name: 'salt_bread',
        description: 'Developer',
        image: Assets.images.saltBread.path,
      ),
      Creator(
        name: 'hhhannahhh',
        description: 'Designer',
        image: Assets.images.hanna.path,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creators'),
        backgroundColor: ColorName.yellowBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      backgroundColor: ColorName.yellowBackground,
      body: Stack(
        children: [
          const BananaBackground(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              padding: EdgeInsets.zero,
              itemCount: creators.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.black.withAlpha(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: AssetImage(creators[index].image),
                        ),
                        8.verticalSpace,
                        Text(
                          creators[index].name,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontFamily: FontFamily.pixelFont,
                            height: 1,
                          ),
                        ),
                        Text(
                          creators[index].description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: FontFamily.pixelFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Creator {
  Creator({
    required this.name,
    required this.description,
    required this.image,
  });

  final String name;
  final String description;
  final String image;
}
