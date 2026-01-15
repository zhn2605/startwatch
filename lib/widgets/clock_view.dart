import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  const ClockView({super.key});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var size = mq.size;
    var clockSize = 0.4;

    return SizedBox(
      width: size.width * clockSize,
      height: size.height * clockSize,
      child: CustomPaint(
        painter: ClockPainter(),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = size.width / 2;

    var fillBrush = Paint()
      ..color = const Color(0xFFEAECFF);

    var outlineBrush = Paint()
      ..color = const Color(0xFF444974)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 20;

    var minHandBrush = Paint()
      ..color = const Color(0xFF444974)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 30
      ..strokeCap = StrokeCap.round;

    var secHandBrush = Paint()
      ..color = const Color(0xFFEA74AB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 60
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - outlineBrush.strokeWidth / 2, fillBrush);
    canvas.drawCircle(center, radius - outlineBrush.strokeWidth / 2, outlineBrush);
    canvas.drawLine(center, Offset(centerX, centerY - radius / 2), minHandBrush);
    canvas.drawLine(center, Offset(centerX + radius / 2, centerY), secHandBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}