import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'app_icon_paths.dart';

/// ويدجت رسم الأيقونات، يقابل مكوّن SvgIcon في الكود الأصلي.
/// يرسم مسار SVG (stroke فقط بدون تعبئة) بنفس أسلوب lucide-icons المستخدم في
/// التصميم الأصلي: viewBox 24x24، خط برأس وزاوية دائرية.
class AppIcon extends StatelessWidget {
  final String name;
  final double size;
  final double strokeWidth;
  final Color color;

  const AppIcon(
    this.name, {
    super.key,
    this.size = 20,
    this.strokeWidth = 1.8,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final d = appIconPaths[name];
    if (d == null) {
      return SizedBox(width: size, height: size);
    }
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SvgPathPainter(d, color, strokeWidth, size),
      ),
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  final String d;
  final Color color;
  final double strokeWidth;
  final double size;

  _SvgPathPainter(this.d, this.color, this.strokeWidth, this.size);

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final path = parseSvgPathData(d);
    // الأيقونات الأصلية مصممة على شبكة 24x24 (viewBox="0 0 24 24")
    final scale = size / 24.0;
    canvas.save();
    canvas.scale(scale, scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth / scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SvgPathPainter oldDelegate) {
    return oldDelegate.d != d ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.size != size;
  }
}
