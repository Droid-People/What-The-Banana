import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_provider.dart';
import 'package:what_the_banana/contents/pace_counter/pace_counter_service.dart';
import 'package:what_the_banana/gen/assets.gen.dart';
import 'package:what_the_banana/ui/back_button.dart';

class PaceCounterScreen extends ConsumerStatefulWidget {
  const PaceCounterScreen({super.key});

  @override
  ConsumerState<PaceCounterScreen> createState() => _PaceCounterScreen();
}

class _PaceCounterScreen extends ConsumerState<PaceCounterScreen> {

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _checkStepCountingAvailableInIOS();
    } else {
      _handlePermissionStatus();
    }
  }

  void _checkStepCountingAvailableInIOS() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      bool available = await isStepCountingAvailable();

      if (available) {
        // IOS의 경우 stepCountStream 사작될 때 권한을 요청함
        ref.read(paceCounterProvider.notifier).initialize();
      } else {
        _showDeviceNotSupportedDialog();
      }
    }
  }

  Future<void> _handlePermissionStatus() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      _showPermissionDialog();
    } else {
      ref.read(paceCounterProvider.notifier).initialize();
    }
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("권한 필요"),
            content: Text("이 앱은 활동 인식 권한이 필요합니다. 설정에서 권한을 허용해주세요."),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  void _showDeviceNotSupportedDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("이 기기로 걸음 수를 측정할 수 없습니다."),
            content: Text("걸음 수를 추적하려면 모션 칩이 내장된 단말이 필요합니다"),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Pace Counter'),
          leading: BackImage(context),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
              children: [
                Assets.images.bigBanana.image(width: 100, height: 100),
                const SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Today's Step Count",
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${stepCounterState.steps}',
                      style: TextStyle(fontSize: 60),
                    ),
                    Text(
                      '${stepCounterState.distanceInKm.toStringAsFixed(2)} km',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )
              ]),
        ),
    );
  }
}
