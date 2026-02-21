import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';

class DonutChartWidget extends StatelessWidget {
  final Map<String, AssetCategory> data;
  final double size;
  final String? activeSlice;
  final Function(String) onSliceTap;

  const DonutChartWidget({
    super.key,
    required this.data,
    this.size = 160,
    this.activeSlice,
    required this.onSliceTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final center = Offset(size / 2, size / 2);
        final dx = details.localPosition.dx - center.dx;
        final dy = details.localPosition.dy - center.dy;
        final distance = sqrt(dx * dx + dy * dy);
        final outerR = size / 2 - 10;
        final innerR = outerR * 0.6;

        if (distance < innerR || distance > outerR) return;

        var angle = atan2(dy, dx) * 180 / pi;
        angle = (angle + 90) % 360;
        if (angle < 0) angle += 360;

        final total = data.values.fold(0, (sum, d) => sum + d.value);
        double cumAngle = 0;

        for (final entry in data.entries) {
          final sliceAngle = (entry.value.value / total) * 360;
          if (angle >= cumAngle && angle < cumAngle + sliceAngle) {
            onSliceTap(entry.key);
            return;
          }
          cumAngle += sliceAngle;
        }
      },
      child: CustomPaint(
        size: Size(size, size),
        painter: _DonutPainter(
          data: data,
          activeSlice: activeSlice,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final Map<String, AssetCategory> data;
  final String? activeSlice;

  _DonutPainter({required this.data, this.activeSlice});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 10;
    final innerRadius = outerRadius * 0.6;
    final total = data.values.fold(0, (sum, d) => sum + d.value);

    double startAngle = -pi / 2;

    for (final entry in data.entries) {
      final sweepAngle = (entry.value.value / total) * 2 * pi;
      final isActive = activeSlice == entry.key;
      final opacity = activeSlice != null && !isActive ? 0.4 : 0.85;

      final midAngle = startAngle + sweepAngle / 2;
      final offset = isActive ? Offset(cos(midAngle) * 6, sin(midAngle) * 6) : Offset.zero;

      final paint = Paint()
        ..color = entry.value.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(
          center.dx + offset.dx + innerRadius * cos(startAngle),
          center.dy + offset.dy + innerRadius * sin(startAngle),
        )
        ..lineTo(
          center.dx + offset.dx + outerRadius * cos(startAngle),
          center.dy + offset.dy + outerRadius * sin(startAngle),
        )
        ..arcTo(
          Rect.fromCircle(center: center + offset, radius: outerRadius),
          startAngle,
          sweepAngle,
          false,
        )
        ..lineTo(
          center.dx + offset.dx + innerRadius * cos(startAngle + sweepAngle),
          center.dy + offset.dy + innerRadius * sin(startAngle + sweepAngle),
        )
        ..arcTo(
          Rect.fromCircle(center: center + offset, radius: innerRadius),
          startAngle + sweepAngle,
          -sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);
      startAngle += sweepAngle;
    }

    // Inner circle
    canvas.drawCircle(
      center,
      innerRadius - 2,
      Paint()..color = const Color(0xFF050505).withOpacity(0.8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}