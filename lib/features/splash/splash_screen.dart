import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../widgets/glass_container.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;

  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _backgroundFade;
  late final Animation<double> _cardFade;
  late final Animation<double> _cardScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineOffset;
  late final Animation<double> _glow;
  late final Animation<double> _progress;
  late final Animation<double> _exit;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _backgroundFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.25, curve: Curves.easeOut),
    );
    _cardFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.25, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.25, curve: Curves.easeOutCubic),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.125, 0.375, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.125, 0.375, curve: Curves.easeOutBack),
      ),
    );
    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3125, 0.469, curve: Curves.easeOut),
    );
    _taglineOffset = Tween<Offset>(
      begin: const Offset(0, 12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3125, 0.469, curve: Curves.easeOutCubic),
      ),
    );
    _glow = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.125, 0.375, curve: Curves.easeOut),
    );
    _progress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.84, curve: Curves.easeInOutCubic),
      ),
    );
    _exit = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.844, 1, curve: Curves.easeInCubic),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_done) {
        _done = true;
        widget.onDone();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final size = MediaQuery.sizeOf(context);
    final shortestSide = math.min(size.width, size.height);
    final cardSize = math.min(shortestSide * 0.82, 360).toDouble();
    final logoSize = math.min(cardSize * 0.72, 250).toDouble();
    final isSmall = size.height < 700;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final exitOpacity =
            disableAnimations ? 1.0 : (1 - _exit.value).toDouble();
        final exitScale =
            disableAnimations ? 1.0 : (1 + (_exit.value * 0.04)).toDouble();
        final breath = disableAnimations
            ? 1.0
            : (1 + (math.sin(_controller.value * math.pi * 4) * 0.01))
                .toDouble();
        final orbTime = disableAnimations ? 0.0 : _controller.value.toDouble();

        return FadeTransition(
          opacity: _backgroundFade,
          child: Transform.scale(
            scale: exitScale,
            child: Opacity(
              opacity: exitOpacity,
              child: ColoredBox(
                color: AppColors.splashNavy,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.splashRoyal,
                            AppColors.splashNavy,
                          ],
                        ),
                      ),
                    ),
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: _OrbPainter(time: orbTime),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: _cardFade,
                            child: ScaleTransition(
                              scale: _cardScale,
                              child: _SplashGlassCard(
                                cardSize: cardSize,
                                logoSize: logoSize,
                                logoFade: _logoFade,
                                logoScale: _logoScale,
                                breath: breath,
                                glow: _glow,
                                controller: _controller,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmall ? 22 : 30),
                          FadeTransition(
                            opacity: _taglineFade,
                            child: SlideTransition(
                              position: _taglineOffset,
                              child: Text(
                                'جامعتك... في طريق واحد',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  color:
                                      AppColors.white.withValues(alpha: 0.75),
                                  fontSize: isSmall ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isSmall ? 34 : 46),
                          _GlassProgressBar(progress: _progress.value),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SplashGlassCard extends StatelessWidget {
  final double cardSize;
  final double logoSize;
  final Animation<double> logoFade;
  final Animation<double> logoScale;
  final double breath;
  final Animation<double> glow;
  final Animation<double> controller;

  const _SplashGlassCard({
    required this.cardSize,
    required this.logoSize,
    required this.logoFade,
    required this.logoScale,
    required this.breath,
    required this.glow,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final sheen = (controller.value * 1.8 - 0.4).clamp(-0.4, 1.0).toDouble();
    return Semantics(
      label: 'UNIWAY',
      image: true,
      child: SizedBox(
        width: cardSize,
        height: cardSize,
        child: GlassContainer(
          blur: 20,
          opacity: 0.11,
          radius: 36,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Stack(
              alignment: Alignment.center,
              children: [
                FadeTransition(
                  opacity: glow,
                  child: Container(
                    width: logoSize * 0.9,
                    height: logoSize * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.splashBright
                              .withValues(alpha: 0.38 * glow.value),
                          AppColors.splashSky
                              .withValues(alpha: 0.22 * glow.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: logoFade,
                  child: ScaleTransition(
                    scale: logoScale,
                    child: Transform.scale(
                      scale: breath,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(cardSize * 0.12),
                        child: Image.asset(
                          'assets/images/uniway_logo.png',
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: Transform.translate(
                    offset: Offset(sheen * cardSize * 1.2, 0),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        width: cardSize * 0.16,
                        height: cardSize * 1.4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.16),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassProgressBar extends StatelessWidget {
  final double progress;

  const _GlassProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 4,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.02, 1),
          heightFactor: 1,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.splashSky,
                  AppColors.white,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double time;

  const _OrbPainter({required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    void drawOrb(
      Offset center,
      double radius,
      Color color,
      Offset drift,
    ) {
      final paint = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 54)
        ..color = color;
      canvas.drawCircle(center + drift, radius, paint);
    }

    final dx = math.sin(time * math.pi * 2) * 18;
    final dy = math.cos(time * math.pi * 2) * 12;
    drawOrb(
      Offset(size.width * 0.12, size.height * 0.18),
      size.shortestSide * 0.22,
      AppColors.splashBright.withValues(alpha: 0.20),
      Offset(dx, dy),
    );
    drawOrb(
      Offset(size.width * 0.88, size.height * 0.28),
      size.shortestSide * 0.18,
      AppColors.splashSky.withValues(alpha: 0.16),
      Offset(-dx * 0.7, dy),
    );
    drawOrb(
      Offset(size.width * 0.78, size.height * 0.82),
      size.shortestSide * 0.20,
      AppColors.splashBright.withValues(alpha: 0.14),
      Offset(dx * 0.5, -dy),
    );
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.time != time;
}
