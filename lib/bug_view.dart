import 'dart:math';
import 'package:flutter/widgets.dart';

class _BugPainter extends CustomPainter {
  const _BugPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final lineWidth = 1.0;
    final bugSize = Size(size.width * 0.8, size.height * 0.8);

    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    final center = Offset(size.width / 2, size.height / 2);

    final cx = center.dx;
    final cy = center.dy + bugSize.height / 10;
    final r = bugSize.width * 3 / 8 - lineWidth / 2;
    final hr = r / 2;
    final a = r / 5;
    final f = r / 3;

    final path = Path();

    // body
    final bodyCenter = Offset(cx, cy);
    path.addArc(Rect.fromCircle(center: bodyCenter, radius: r), -pi / 3, pi * 5 / 3);
    path.close();

    // head
    final headCenter = Offset(cx, cy - sin(pi / 3) * r);
    path.addArc(Rect.fromCircle(center: headCenter, radius: hr), pi, pi);

    // body connection
    path.moveTo(cx, cy - sin(pi / 3) * r);
    path.lineTo(cx, cy + r);

    // antennae
    path.moveTo(headCenter.dx + cos(pi / 5 * 2) * hr, headCenter.dy + sin(-pi / 5 * 2) * hr);
    path.lineTo(headCenter.dx + cos(pi / 5 * 2) * hr + a, headCenter.dy - sin(pi / 5 * 2) * hr - a);

    path.moveTo(headCenter.dx - cos(pi / 5 * 2) * hr, headCenter.dy + sin(-pi / 5 * 2) * hr);
    path.lineTo(headCenter.dx - cos(pi / 5 * 2) * hr - a, headCenter.dy - sin(pi / 5 * 2) * hr - a);

    // feet
    path.moveTo(cx + r, cy);
    path.lineTo(cx + r + f, cy);

    path.moveTo(cx + cos(pi / 6) * r, cy - sin(pi / 6) * r);
    path.lineTo(cx + cos(pi / 6) * (r + f), cy - sin(pi / 6) * (r + f));

    path.moveTo(cx + cos(pi / 6) * r, cy + sin(pi / 6) * r);
    path.lineTo(cx + cos(pi / 6) * (r + f), cy + sin(pi / 6) * (r + f));

    path.moveTo(cx - r, cy);
    path.lineTo(cx - r - f, cy);

    path.moveTo(cx - cos(pi / 6) * r, cy - sin(pi / 6) * r);
    path.lineTo(cx - cos(pi / 6) * (r + f), cy - sin(pi / 6) * (r + f));

    path.moveTo(cx - cos(pi / 6) * r, cy + sin(pi / 6) * r);
    path.lineTo(cx - cos(pi / 6) * (r + f), cy + sin(pi / 6) * (r + f));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BugView extends CustomPaint {
  const BugView({super.key}) : super(painter: const _BugPainter());
}
