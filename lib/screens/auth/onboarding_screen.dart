import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';

/// شاشة التعريف بالتطبيق (onboarding) بثلاث شرائح قابلة للتمرير.
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
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const AppIcon('grad', size: 18, color: AppColors.blue),
                  ),
                  const SizedBox(width: 8),
                  Text('UNIWAY', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text)),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onDone,
                    child: Text('تخطي', style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textMuted)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardSlides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final s = onboardSlides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(color: s.accent.withValues(alpha: 0.1), shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Icon(Icons.school_outlined, size: 64, color: s.accent),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: s.badgeBg, borderRadius: BorderRadius.circular(20)),
                          child: Text(s.badge, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: s.badgeColor)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          s.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.body,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub, height: 1.6),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardSlides.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.blue : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    _index == onboardSlides.length - 1 ? 'بدء الاستخدام' : 'التالي',
                    style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
