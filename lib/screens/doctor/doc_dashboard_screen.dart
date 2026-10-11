import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';

class _QuickAction {
  final String icon, label, nav;
  final Color color, bg;
  const _QuickAction(this.icon, this.color, this.bg, this.label, this.nav);
}

const _quickActions = [
  _QuickAction('upload', AppColors.blue, AppColors.blueLight, 'رفع الدرجات', 'doc-upload-grades'),
  _QuickAction('layers', AppColors.purple, AppColors.purpleLight, 'رفع محاضرة', 'doc-upload-lecture'),
  _QuickAction('users', AppColors.success, AppColors.successLight, 'السجلات الأكاديمية', 'doc-records'),
  _QuickAction('chat', AppColors.warning, AppColors.warningLight, 'رسائل الطلاب', 'doc-chats'),
];

/// الشاشة الرئيسية للدكتور: إحصائيات سريعة، مقررات الفصل، وإجراءات سريعة.
class DocDashboardScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const DocDashboardScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              color: AppColors.blue,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('مرحباً،', style: GoogleFonts.cairo(fontSize: 12, color: Colors.white.withValues(alpha: 0.65))),
                            Text('د. سارة القحطاني', style: GoogleFonts.cairo(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
                            Text('قسم علوم الحاسب وتقنية المعلومات', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.65))),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: const AppIcon('bell', size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _stat('3', 'مقررات')),
                    const SizedBox(width: 8),
                    Expanded(child: _stat('115', 'طلاب')),
                    const SizedBox(width: 8),
                    Expanded(child: _stat('8', 'رسائل')),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Text('مقرراتي هذا الفصل', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 10),
                  ...docCourses.map((c) {
                    return InkWell(
                      onTap: () => onNav('doc-course-detail'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                      Text('${c.code} · ${c.section} · ${c.students} طالباً', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: c.submitted ? AppColors.successLight : AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                                  child: Text(c.submitted ? 'درجات مرفوعة' : 'لم تُرفع', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: c.submitted ? AppColors.success : AppColors.warning)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(c.schedule, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 6),
                  Text('إجراءات سريعة', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.7,
                    children: _quickActions.map((q) {
                      return InkWell(
                        onTap: () => onNav(q.nav),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: q.bg, borderRadius: BorderRadius.circular(12)),
                                alignment: Alignment.center,
                                child: AppIcon(q.icon, size: 20, color: q.color),
                              ),
                              const SizedBox(height: 8),
                              Text(q.label, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(val, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
          Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}
