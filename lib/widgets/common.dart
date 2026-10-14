import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_icon.dart';

/// رأس شاشة عام مع زر رجوع، عنوان، وعنصر اختياري على الجانب الآخر
/// (يقابل BackHeader في الكود الأصلي).
class BackHeader extends StatelessWidget {
  final String title;
  final String? sub;
  final VoidCallback onBack;
  final Widget? trailing;

  const BackHeader({super.key, required this.title, this.sub, required this.onBack, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(18)),
              alignment: Alignment.center,
              child: const AppIcon('arrowRight', size: 18, color: AppColors.blue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
                if (sub != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(sub!, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// شريط علوي بسيط بعنوان وزر إشعارات اختياري (يقابل AppBar الأصلي).
class SimpleAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showNotif;
  final VoidCallback? onNotif;

  const SimpleAppBar({super.key, required this.title, this.subtitle, this.showNotif = false, this.onNotif});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      color: AppColors.card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text)),
                if (subtitle != null)
                  Text(subtitle!, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
              ],
            ),
          ),
          if (showNotif)
            InkWell(
              onTap: onNotif,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(19)),
                alignment: Alignment.center,
                child: const AppIcon('bell', size: 18, color: AppColors.blue),
              ),
            ),
        ],
      ),
    );
  }
}

/// شارة الإلحاح (يقابل UrgencyBadge).
class UrgencyBadge extends StatelessWidget {
  final String urgency;
  final int days;
  const UrgencyBadge({super.key, required this.urgency, required this.days});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.urgencyColor(urgency);
    final bg = AppColors.urgencyBg(urgency);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        days <= 0 ? 'اليوم' : 'متبقي $days يوم',
        style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

/// عنصر قائمة قابل لإعادة الاستخدام: أيقونة + عنوان + نص فرعي + شارة اختيارية
/// (يقابل RowItem الأصلي).
class RowItem extends StatelessWidget {
  final String icon;
  final Color color;
  final Color bg;
  final String title;
  final String? sub;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final bool divider;

  const RowItem({
    super.key,
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
    this.sub,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          border: divider ? const Border(bottom: BorderSide(color: AppColors.border)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: AppIcon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
                  if (sub != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(sub!, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                    ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: (badgeColor ?? AppColors.blue).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(badge!, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: badgeColor ?? AppColors.blue)),
              )
            else
              const AppIcon('chevronLeft', size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

/// بطاقة إحصائية صغيرة (يقابل DashStat).
class DashStat extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final Color bg;
  const DashStat({super.key, required this.label, required this.value, required this.icon, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: AppIcon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(value, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
        ],
      ),
    );
  }
}

/// عنوان قسم مع رابط "عرض الكل" اختياري.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text))),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blue)),
            ),
        ],
      ),
    );
  }
}

/// شارة نصية صغيرة ملوّنة (Chip بسيط).
class AppChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const AppChip({super.key, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

/// زر أساسي عريض بلون موحّد.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final String? icon;

  const PrimaryButton({super.key, required this.label, required this.onPressed, this.color = AppColors.blue, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 18, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(label, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

/// زر ثانوي بحدود بدون تعبئة.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const SecondaryButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blue,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// حاوية بطاقة عامة بزوايا دائرية وحد خفيف.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return InkWell(borderRadius: BorderRadius.circular(16), onTap: onTap, child: card);
  }
}

/// مربع نص تسمية صغيرة فوق القيمة (لنماذج الإدخال).
class LabeledField extends StatelessWidget {
  final String label;
  final String? hint;
  final int maxLines;
  final TextEditingController? controller;
  const LabeledField({super.key, required this.label, this.hint, this.maxLines = 1, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.cairo(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.blue)),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

/// حالة فراغ عامة (لا توجد عناصر لعرضها).
class EmptyState extends StatelessWidget {
  final String icon;
  final String text;
  const EmptyState({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          AppIcon(icon, size: 36, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub)),
        ],
      ),
    );
  }
}
