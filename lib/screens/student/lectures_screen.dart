import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

/// شاشة المحاضرات: قائمة مقررات الفصل الحالي مع عدد المحاضرات المرفوعة.
class LecturesScreen extends StatelessWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onSelect;
  const LecturesScreen({super.key, required this.onBack, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'المحاضرات', subtitle: 'مقررات الفصل الدراسي الحالي'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: studentLectureCourses.map((course) {
                  return InkWell(
                    onTap: () => onSelect(course.code),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            child: const AppIcon('library', size: 20, color: AppColors.blue),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(course.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                Text('${course.code} · ${course.doctor}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                const SizedBox(height: 4),
                                Text('${course.count} محاضرات · آخر محاضرة: ${course.latest}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.blue)),
                              ],
                            ),
                          ),
                          const AppIcon('chevronLeft', size: 15, strokeWidth: 2, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LectureFile {
  final String title, timestamp, type, size;
  const _LectureFile(this.title, this.timestamp, this.type, this.size);
}

final Map<String, List<_LectureFile>> _allLectures = {
  'CS401': [
    _LectureFile('اختبارات البرمجيات', '06 أكتوبر 2026 – 10:30 ص', 'PDF', '3.1 MB'),
    _LectureFile('أنماط التصميم', '29 سبتمبر 2026 – 11:00 ص', 'PDF', '2.4 MB'),
    _LectureFile('معمارية النظام', '22 سبتمبر 2026 – 10:45 ص', 'PPTX', '5.1 MB'),
  ],
  'CS415': [
    _LectureFile('بروتوكولات التوجيه', '05 أكتوبر 2026 – 01:15 م', 'PPTX', '4.3 MB'),
    _LectureFile('أمن الشبكات', '28 سبتمبر 2026 – 12:40 م', 'PDF', '2.8 MB'),
  ],
  'CS440': [
    _LectureFile('الشبكات العصبية', '04 أكتوبر 2026 – 09:00 ص', 'PDF', '3.8 MB'),
    _LectureFile('خوارزميات البحث', '27 سبتمبر 2026 – 09:20 ص', 'PPT', '4.2 MB'),
  ],
  'CS461': [],
};

/// محاضرات مقرر واحد محدد، مع بحث في العناوين.
class CourseLecturesScreen extends StatefulWidget {
  final String courseCode;
  final VoidCallback onBack;
  const CourseLecturesScreen({super.key, required this.courseCode, required this.onBack});

  @override
  State<CourseLecturesScreen> createState() => _CourseLecturesScreenState();
}

class _CourseLecturesScreenState extends State<CourseLecturesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final course = studentLectureCourses.firstWhere((c) => c.code == widget.courseCode, orElse: () => studentLectureCourses.first);
    final lectures = (_allLectures[course.code] ?? []).where((l) => l.title.contains(_query)).toList();

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'محاضرات ${course.name}', sub: '${course.code} · ${course.doctor}', onBack: widget.onBack),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Row(children: [
                  const AppIcon('search', size: 15, strokeWidth: 2, color: AppColors.textMuted),
                  const SizedBox(width: 7),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontSize: 11),
                      decoration: InputDecoration(hintText: 'ابحث في عناوين المحاضرات...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 9)),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: lectures.isEmpty
                  ? const EmptyState(icon: 'library', text: 'لا توجد محاضرات لهذا المقرر حاليًا')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: lectures.map((l) {
                        final isPdf = l.type == 'PDF';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: isPdf ? AppColors.dangerLight : AppColors.warningLight, borderRadius: BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                    child: Text(l.type, style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w900, color: isPdf ? AppColors.danger : AppColors.warning)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(l.title, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                        const SizedBox(height: 3),
                                        Text('تاريخ الرفع: ${l.timestamp}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                        Text(l.size, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.blue, side: const BorderSide(color: AppColors.blue), padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                    child: Text('عرض', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 8), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                    child: Text('تحميل', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
