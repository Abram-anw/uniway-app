import 'package:flutter/material.dart';

/// نفس لوحة الألوان المستخدمة في التصميم الأصلي (ثابت P في الكود الأصلي).
class AppColors {
  AppColors._();

  static const Color blue = Color(0xFF1F5C8B);
  static const Color blueDark = Color(0xFF174A72);
  static const Color blueMid = Color(0xFF2E72A8);
  static const Color blueLight = Color(0xFFEBF4FF);

  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEE2E2);

  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFF3E8FF);

  static const Color bg = Color(0xFFF4F7FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDDE3EC);

  static const Color text = Color(0xFF0D1B2A);
  static const Color textSub = Color(0xFF4A6278);
  static const Color textMuted = Color(0xFF8FA3B8);

  static const Color white = Color(0xFFFFFFFF);

  /// لون بحسب درجة الإلحاح، يطابق منطق UrgencyBadge الأصلي.
  static Color urgencyColor(String urgency) {
    switch (urgency) {
      case 'danger':
        return danger;
      case 'warning':
        return warning;
      default:
        return success;
    }
  }

  static Color urgencyBg(String urgency) {
    switch (urgency) {
      case 'danger':
        return dangerLight;
      case 'warning':
        return warningLight;
      default:
        return successLight;
    }
  }
}
