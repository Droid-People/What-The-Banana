import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_provider.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_service.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';
import 'package:what_the_banana/ui/single_rotating_banana.dart';

class PaceCounterScreen extends ConsumerStatefulWidget {
  const PaceCounterScreen({super.key});

  @override
  ConsumerState<PaceCounterScreen> createState() => _PaceCounterScreen();
}

class _PaceCounterScreen extends ConsumerState<PaceCounterScreen> {
  var buttonText = 'start';

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _checkStepCountingAvailableInIOS();
    } else {
      _handlePermissionStatus();
    }
  }

  Future<void> _checkStepCountingAvailableInIOS() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final available = await isStepCountingAvailable();

      if (available) {
        // IOS의 경우 stepCountStream 사작될 때 권한을 요청함
        ref.read(paceCounterProvider.notifier).initialize();
      } else {
        _showDeviceNotSupportedDialog();
      }
    }
  }

  Future<void> _handlePermissionStatus() async {
    final granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      _showPermissionDialog();
    } else {
      ref.read(paceCounterProvider.notifier).initialize();
    }
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    var granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }

    return granted;
  }

  void _showPermissionDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PermissionTitle').tr(),
        content: const Text('PermissionContent').tr(),
        actions: <Widget>[
          TextButton(
            child: const Text('confirm').tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('cancel').tr(),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDeviceNotSupportedDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DeviceNotSupportedTitle').tr(),
        content: const Text('DeviceNotSupportedContent').tr(),
        actions: <Widget>[
          TextButton(
            child: const Text('confirm', style: TextStyle(color: Colors.black),).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stepCounterState = ref.watch(paceCounterProvider);

    return PopScope(
      onPopInvokedWithResult: (bool result, data) {
        if (result) {
          ref.read(paceCounterProvider.notifier).dispose();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('pace_counter').tr(),
          leading: BackImage(context),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleRotatingBanana(ref.read(paceCounterProvider.notifier).controller),
              100.verticalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'step_count',
                    style: TextStyle(fontSize: 24, height: 1, fontFamily: FontFamily.unkemptBold, fontFamilyFallback: [FontFamily.ssronet]),
                  ).tr(),
                  20.verticalSpace,
                  Text(
                    '${stepCounterState.steps}',
                    style: const TextStyle(fontSize: 60, height: 1),
                  ),
                  Text(
                    '${stepCounterState.distanceInKm.toStringAsFixed(2)} km',
                    style: const TextStyle(fontSize: 20, height: 1),
                  ),
                  16.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (buttonText == 'start') {
                          ref.read(paceCounterProvider.notifier).start();
                          buttonText = 'stop';
                        } else {
                          ref.read(paceCounterProvider.notifier).stop();
                          buttonText = 'start';
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child:
                          Text(buttonText, style: const TextStyle(fontSize: 30, fontFamily: FontFamily.unkemptBold, fontFamilyFallback: [FontFamily.ssronet]))
                              .tr(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
