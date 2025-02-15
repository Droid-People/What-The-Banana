import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_the_banana/ui/back_button.dart';

class RouletteScreen extends ConsumerWidget {
  const RouletteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette'),
        leading: BackImage(context),
      ),
      body: const Center(
        child: Text('Roulette'),
      ),
    );
  }
}
