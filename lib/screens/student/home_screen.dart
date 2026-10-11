import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../models/procedure.dart';
import '../../widgets/common.dart';

/// الشاشة الرئيسية للطالب: ترحيب، بحث سريع، شبكة التصنيفات،
/// المواعيد النهائية القريبة، وإجراءات سريعة.
class HomeScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  final ValueChanged<Procedure> onSelectProc;
  const HomeScreen({super.key, required this.onNav, required this.onSelectProc});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('صباح الخير،', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                        Text('أحمد العمري 👋', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.text)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => onNav('notifications'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                      alignment: Alignment.center,
                      child: const AppIcon('bell', size: 18, color: AppColors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => onNav('search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      const AppIcon('search', size: 17, color: AppColors.textMuted),
                      const SizedBox(width: 10),
                      Text('ابحث عن إجراء، خدمة، أو قسم...', style: GoogleFonts.cairo(fontSize: 12.5, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ),
            SectionHeader(title: 'استكشف الخدمات', action: 'عرض الكل', onAction: () => onNav('search')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: homeCategories.map((c) {
                  return InkWell(
                    onTap: () => onNav(c.nav),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: c.bg, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            child: AppIcon(c.iconName, size: 18, color: c.color),
                          ),
                          const SizedBox(height: 8),
                          Text(c.label, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.text), maxLines: 2),
                          const SizedBox(height: 2),
                          Text('${c.count} إجراء', style: GoogleFonts.cairo(fontSize: 9.5, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SectionHeader(title: 'المواعيد النهائية', action: 'عرض الكل', onAction: () => onNav('reminders')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: homeDeadlines.map((d) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.title, style: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.text)),
                              const SizedBox(height: 4),
                              Text('${d.dept} · ${d.date}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        UrgencyBadge(urgency: d.urgency, days: d.daysLeft),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SectionHeader(title: 'إجراءات سريعة'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: 'chat',
                      label: 'المحادثات',
                      color: AppColors.blue,
                      bg: AppColors.blueLight,
                      onTap: () => onNav('doctor-chat-list'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quickAction(
                      icon: 'alert',
                      label: 'التظلم من الدرجة',
                      color: AppColors.warning,
                      bg: AppColors.warningLight,
                      onTap: () => onNav('grades'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quickAction(
                      icon: 'award',
                      label: 'طلب شهادة',
                      color: AppColors.success,
                      bg: AppColors.successLight,
                      onTap: () => onNav('documents'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction({required String icon, required String label, required Color color, required Color bg, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: AppIcon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.text)),
          ],
        ),
      ),
    );
  }
}
