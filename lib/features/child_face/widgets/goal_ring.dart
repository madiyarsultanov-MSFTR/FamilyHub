import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';

/// Simple progress ring for the Jeo savings goal.
class GoalRing extends StatelessWidget {
  const GoalRing({super.key, required this.progress, this.size = 120});

  final double progress; // 0..1
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress.clamp(0.0, 1.0)),
        child: Center(
          child: Text('${(progress * 100).round()}%',
              style: const TextStyle(
                  color: HubColors.paperInk,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress);
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;
    const stroke = 12.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = HubColors.paperLine,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress * math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = HubColors.emerald,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
