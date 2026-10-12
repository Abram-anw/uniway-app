import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index < onboardSlides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
    } else {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final slide = onboardSlides[_index];
        return ColoredBox(
          color: slide.bg,
          child: SafeArea(
            child: Column(
              children: [
                _OnboardingHeader(onSkip: widget.onDone),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: onboardSlides.length,
                    onPageChanged: (index) => setState(() => _index = index),
                    itemBuilder: (context, index) => _OnboardingPage(slide: onboardSlides[index], index: index),
                  ),
                ),
                _PageIndicator(index: _index, color: slide.accent),
                const SizedBox(height: 15),
                _NavigationButtons(index: _index, color: slide.accent, onNext: _next),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _OnboardingHeader extends StatelessWidget {
  final VoidCallback onSkip;
  const _OnboardingHeader({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(27, 10, 18, 0),
        child: Row(
          children: [
            TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 29),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Color(0xFFD8E3ED)),
                ),
              ),
              child: Text('تخطي', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted, height: 1)),
            ),
            const Spacer(),
            Text('UNIWAY', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.text)),
            const SizedBox(width: 6),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(7)),
              alignment: Alignment.center,
              child: const AppIcon('grad', size: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardSlide slide;
  final int index;
  const _OnboardingPage({required this.slide, required this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationHeight = constraints.maxHeight * 0.47;
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: illustrationHeight.clamp(230.0, 330.0),
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, 30),
                    child: Transform.scale(
                      scale: 0.88,
                      child: CustomPaint(
                        size: const Size(250, 220),
                        painter: _OnboardingIllustrationPainter(index: index),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: slide.badgeBg, borderRadius: BorderRadius.circular(15)),
                  child: Text(slide.badge, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: slide.badgeColor, height: 1.2)),
                ),
              ),
              const SizedBox(height: 13),
              Text(
                slide.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.text, height: 1.42),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 27),
                child: Text(
                  slide.body,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(fontSize: 11.5, color: AppColors.textSub, height: 1.75),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int index;
  final Color color;
  const _PageIndicator({required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (item) {
        final active = item == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 24 : 7,
          height: 7,
          decoration: BoxDecoration(color: active ? color : const Color(0xFFD8E1EB), borderRadius: BorderRadius.circular(5)),
        );
      }),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final int index;
  final Color color;
  final VoidCallback onNext;
  const _NavigationButtons({required this.index, required this.color, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(isFirst ? 39 : 30, 0, isFirst ? 25 : 15, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.only(left: isFirst ? 24 : 16, right: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: isFirst ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isFirst) const Icon(Icons.chevron_left, size: 21),
                    Text(index == 2 ? 'ابدأ الاستخدام' : isFirst ? 'التالي' : 'التالي', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800)),
                    if (isFirst) const Icon(Icons.chevron_left, size: 21),
                  ],
                ),
              ),
            ),
          ),
          if (!isFirst) ...[
            const SizedBox(width: 9),
            SizedBox(
              width: 42,
              height: 36,
              child: OutlinedButton(
                onPressed: onNext,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSub,
                  padding: EdgeInsets.zero,
                  side: const BorderSide(color: Color(0xFFD7E1EA)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Icon(Icons.chevron_right, size: 22),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OnboardingIllustrationPainter extends CustomPainter {
  final int index;
  const _OnboardingIllustrationPainter({required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    switch (index) {
      case 1:
        _paintCalendar(canvas, size);
        break;
      case 2:
        _paintAssistant(canvas, size);
        break;
      default:
        _paintUniversityCard(canvas, size);
    }
  }

  void _paintUniversityCard(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 99);
    _circle(canvas, center, 79, const Color(0xFFEAF4FF));
    _circle(canvas, center, 59, const Color(0xFFD5E9FF));
    _roundRect(canvas, const Rect.fromLTWH(95, 28, 74, 124), 15, Colors.white, const Color(0xFF216596), 2);
    _roundRect(canvas, const Rect.fromLTWH(104, 44, 56, 78), 7, const Color(0xFFF2F5F8), null, 0);
    _line(canvas, const Offset(112, 55), const Offset(150, 55), const Color(0xFFD8E1EA), 4);
    _line(canvas, const Offset(112, 66), const Offset(146, 66), const Color(0xFFD8E1EA), 4);
    _line(canvas, const Offset(112, 77), const Offset(138, 77), const Color(0xFFD8E1EA), 4);
    _roundRect(canvas, const Rect.fromLTWH(112, 91, 39, 21), 5, const Color(0xFF216596), null, 0);
    _line(canvas, const Offset(119, 99), const Offset(142, 99), Colors.white, 3);
    _line(canvas, const Offset(119, 105), const Offset(134, 105), const Color(0xFFB8D1E5), 2);
    _roundRect(canvas, const Rect.fromLTWH(115, 142, 34, 5), 3, const Color(0xFFD8E1EA), null, 0);
    _speechCard(canvas, const Rect.fromLTWH(24, 61, 61, 30), true);
    _speechCard(canvas, const Rect.fromLTWH(163, 97, 62, 30), false);
  }

  void _paintCalendar(Canvas canvas, Size size) {
    _circle(canvas, const Offset(125, 100), 68, const Color(0xFFFFF8E5));
    _roundRect(canvas, const Rect.fromLTWH(67, 37, 116, 108), 12, Colors.white, const Color(0xFFF0E4BF), 1);
    _roundRect(canvas, const Rect.fromLTWH(67, 37, 116, 32), 10, const Color(0xFF216596), null, 0);
    canvas.drawRect(const Rect.fromLTWH(67, 56, 116, 13), Paint()..color = const Color(0xFF216596));
    _text(canvas, 'يناير 2025', const Offset(125, 48), Colors.white, 10, FontWeight.w800, TextAlign.center);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 7; col++) {
        final value = row * 7 + col + 1;
        final point = Offset(80 + col * 14.5, 80 + row * 15);
        if (value == 5 || value == 12) {
          canvas.drawCircle(point, 7, Paint()..color = value == 5 ? const Color(0xFFE52636) : const Color(0xFFE78500));
          _text(canvas, '$value', point, Colors.white, 6, FontWeight.w700, TextAlign.center);
        } else {
          _text(canvas, '$value', point, const Color(0xFF8CA1B4), 6, FontWeight.w500, TextAlign.center);
        }
      }
    }
    canvas.drawCircle(const Offset(185, 39), 8, Paint()..color = const Color(0xFFE52636));
    _text(canvas, '3', const Offset(185, 39), Colors.white, 7, FontWeight.w800, TextAlign.center);
    _roundRect(canvas, const Rect.fromLTWH(163, 130, 18, 18), 5, const Color(0xFFFFDDE2), null, 0);
    _text(canvas, '♟', const Offset(172, 139), const Color(0xFFE52636), 10, FontWeight.w700, TextAlign.center);
  }

  void _paintAssistant(Canvas canvas, Size size) {
    _circle(canvas, const Offset(125, 100), 69, const Color(0xFFC9F7D9));
    _roundRect(canvas, const Rect.fromLTWH(48, 37, 124, 35), 11, const Color(0xFF216596), null, 0);
    _triangle(canvas, const Offset(61, 69), const Offset(75, 69), const Offset(61, 84), const Color(0xFF216596));
    canvas.drawCircle(const Offset(42, 54), 15, Paint()..color = const Color(0xFF216596));
    canvas.drawCircle(const Offset(42, 54), 5, Paint()..color = const Color(0xFFBBD3E2));
    _line(canvas, const Offset(82, 48), const Offset(144, 48), const Color(0xFFC2D8E6), 4);
    _line(canvas, const Offset(82, 59), const Offset(123, 59), const Color(0xFF9FC0D5), 4);
    _roundRect(canvas, const Rect.fromLTWH(80, 92, 123, 36), 11, Colors.white, const Color(0xFFE0E6EB), 1);
    _triangle(canvas, const Offset(185, 124), const Offset(196, 124), const Offset(196, 136), Colors.white);
    _line(canvas, const Offset(98, 104), const Offset(168, 104), const Color(0xFFD8E1EA), 4);
    _line(canvas, const Offset(98, 115), const Offset(154, 115), const Color(0xFFE5EBF0), 4);
    canvas.drawCircle(const Offset(218, 109), 15, Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5..color = const Color(0xFF216596));
    _text(canvas, 'i', const Offset(218, 109), const Color(0xFF216596), 13, FontWeight.w700, TextAlign.center);
    _roundRect(canvas, const Rect.fromLTWH(68, 148, 68, 24), 9, Colors.white, const Color(0xFFD7E1EA), 1);
    canvas.drawCircle(const Offset(89, 160), 4, Paint()..color = const Color(0xFFD7E1EA));
    canvas.drawCircle(const Offset(102, 160), 4, Paint()..color = const Color(0xFFB2C7D7));
    canvas.drawCircle(const Offset(115, 160), 4, Paint()..color = const Color(0xFF216596));
  }

  void _circle(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(center, radius, Paint()..color = color);
  }

  void _roundRect(Canvas canvas, Rect rect, double radius, Color fill, Color? stroke, double strokeWidth) {
    final paint = Paint()..color = fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)), paint);
    if (stroke != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
        Paint()..style = PaintingStyle.stroke..strokeWidth = strokeWidth..color = stroke,
      );
    }
  }

  void _line(Canvas canvas, Offset start, Offset end, Color color, double width) {
    canvas.drawLine(start, end, Paint()..color = color..strokeWidth = width..strokeCap = StrokeCap.round);
  }

  void _speechCard(Canvas canvas, Rect rect, bool check) {
    _roundRect(canvas, rect, 8, Colors.white, const Color(0xFFD5E1EB), 1);
    if (check) {
      canvas.drawCircle(Offset(rect.left + 12, rect.top + 15), 6, Paint()..color = const Color(0xFFD8F9E6));
      _text(canvas, '✓', Offset(rect.left + 12, rect.top + 15), const Color(0xFF43BE77), 8, FontWeight.w800, TextAlign.center);
    } else {
      canvas.drawCircle(Offset(rect.left + 12, rect.top + 15), 6, Paint()..color = const Color(0xFFFFF2C8));
      _text(canvas, '!', Offset(rect.left + 12, rect.top + 15), const Color(0xFFE8AC21), 8, FontWeight.w800, TextAlign.center);
    }
    _line(canvas, Offset(rect.left + 23, rect.top + 11), Offset(rect.right - 8, rect.top + 11), const Color(0xFFD8E1EA), 3);
    _line(canvas, Offset(rect.left + 23, rect.top + 19), Offset(rect.right - 18, rect.top + 19), const Color(0xFFE5EBF0), 3);
  }

  void _triangle(Canvas canvas, Offset a, Offset b, Offset c, Color color) {
    canvas.drawPath(Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy)..lineTo(c.dx, c.dy)..close(), Paint()..color = color);
  }

  void _text(Canvas canvas, String text, Offset center, Color color, double size, FontWeight weight, TextAlign align) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: weight)),
      textDirection: TextDirection.rtl,
      textAlign: align,
    )..layout();
    painter.paint(canvas, Offset(center.dx - painter.width / 2, center.dy - painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _OnboardingIllustrationPainter oldDelegate) => oldDelegate.index != index;
}
