import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:what_the_banana/ui/back_button.dart';

class RouletteScreen extends StatelessWidget {
  const RouletteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette'),
        leading: BackImage(context),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'not_ready',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ).tr(),
        ),
      ),
    );
  }
}
