import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:what_the_banana/ui/back_button.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Donation'),
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
