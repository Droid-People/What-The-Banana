import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:what_the_banana/gen/colors.gen.dart';
import 'package:what_the_banana/gen/fonts.gen.dart';

/// 커스텀 바나나 상단바 — 시스템 상태바를 숨기고 앱 톤(바나나 옐로우)으로
/// 시계·배터리를 직접 그림. main에서 시스템 상태바 숨김 처리와 함께 사용.
class BananaStatusBar extends StatefulWidget {
  const BananaStatusBar({super.key});

  static const double barHeight = 30;

  @override
  State<BananaStatusBar> createState() => _BananaStatusBarState();
}

class _BananaStatusBarState extends State<BananaStatusBar> {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batterySub;
  Timer? _clockTimer;
  Timer? _batteryTimer;

  DateTime _now = DateTime.now();
  int? _level;
  bool _charging = false;

  @override
  void initState() {
    super.initState();
    // 시계 — 분 단위 표시라 20초마다 갱신이면 충분(경계 오차 최소).
    _clockTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    unawaited(_refreshBattery());
    _batteryTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => unawaited(_refreshBattery()),
    );
    _batterySub = _battery.onBatteryStateChanged.listen((s) {
      if (!mounted) return;
      setState(() => _charging = s == BatteryState.charging);
      unawaited(_refreshBattery());
    });
  }

  Future<void> _refreshBattery() async {
    try {
      final lv = await _battery.batteryLevel;
      // iOS 시뮬레이터 등 미지원 환경은 -1 반환 → 폴백.
      if (mounted) setState(() => _level = lv >= 0 ? lv : 100);
    } on Exception catch (_) {
      // 에뮬/미지원 → 디자인 일관성 위해 100%로 폴백 표시.
      if (mounted) setState(() => _level = 100);
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _batteryTimer?.cancel();
    unawaited(_batterySub?.cancel());
    super.dispose();
  }

  String get _timeText {
    final h = _now.hour.toString().padLeft(2, '0');
    final m = _now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    // 노치/다이나믹아일랜드 높이 = 상태바 영역. 이 영역 안에서 세로 중앙 정렬해야
    // 시계·배터리가 아일랜드 옆에 나란히 앉음(아래로 밀리지 않음).
    final topInset = MediaQuery.of(context).viewPadding.top;
    final barH = topInset > 0 ? topInset : BananaStatusBar.barHeight;

    return Material(
      color: ColorName.homeTopBackground,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 18),
        height: barH,
        alignment: Alignment.center,
        child: Row(
          children: [
            Text(
              _timeText,
              style: const TextStyle(
                fontFamily: FontFamily.hannah,
                fontFamilyFallback: [FontFamily.unkemptBold],
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: Colors.black,
                height: 1,
              ),
            ),
            const Spacer(),
            if (_level != null) ...[
              Text(
                '$_level',
                style: const TextStyle(
                  fontFamily: FontFamily.hannah,
                  fontFamilyFallback: [FontFamily.unkemptBold],
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              CustomPaint(
                size: const Size(24, 12),
                painter: _BatteryPainter(level: _level!, charging: _charging),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 손그림 톤 배터리 — 검정 외곽 라인 + 잔량만큼 채움, 충전 중엔 바나나빛 표시.
class _BatteryPainter extends CustomPainter {
  _BatteryPainter({required this.level, required this.charging});

  final int level;
  final bool charging;

  static const _ink = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..isAntiAlias = true;

    // 본체(오른쪽 꼭지 공간 남김)
    final bodyW = size.width - 3;
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.7, 0.7, bodyW - 1.4, size.height - 1.4),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(body, stroke);

    // 꼭지
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyW, size.height * 0.3, 2.6, size.height * 0.4),
        const Radius.circular(1),
      ),
      Paint()..color = _ink,
    );

    // 잔량 채움
    final pct = level.clamp(0, 100) / 100.0;
    final innerW = (bodyW - 4) * pct;
    if (innerW > 0.5) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(2, 2, innerW, size.height - 4),
          const Radius.circular(1.2),
        ),
        Paint()..color = _ink,
      );
    }

    // 충전 표시 — 바나나빛 점
    if (charging) {
      canvas.drawCircle(
        Offset(bodyW / 2, size.height / 2),
        1.6,
        Paint()..color = ColorName.homeTopBackground,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter old) =>
      old.level != level || old.charging != charging;
}
