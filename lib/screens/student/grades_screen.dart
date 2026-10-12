import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

/// سجل الدرجات: المعدل التراكمي وقوائم المقررات لكل فصل.
class GradesScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const GradesScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final graded = mockCourses.take(4).where((c) => c.grade != null).toList();
    final semesters = [
      {'name': 'الفصل الثاني 1446', 'gpa': '3.85'},
      {'name': 'الفصل الأول 1446', 'gpa': '4.05'},
    ];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              color: AppColors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سجل الدرجات', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _stat('4.21', 'المعدل التراكمي')),
                    const SizedBox(width: 10),
                    Expanded(child: _stat('112', 'ساعة منجزة')),
                    const SizedBox(width: 10),
                    Expanded(child: _stat('7', 'المستوى')),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: semesters.map((sem) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sem['name']!, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(20)),
                              child: Text('المعدل: ${sem['gpa']}', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.blue)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Column(
                            children: List.generate(graded.length, (i) {
                              final c = graded[i];
                              final isA = c.grade != null && c.grade!.startsWith('A');
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () => onNav('grade-detail'),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(c.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                                Text('${c.code} · ${c.credits} ساعات', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(color: (isA ? AppColors.success : AppColors.blue).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                                            child: Text(c.grade ?? '', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w900, color: isA ? AppColors.success : AppColors.blue)),
                                          ),
                                          const AppIcon('chevronLeft', size: 14, color: AppColors.textMuted),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (i < graded.length - 1) const Divider(height: 1, color: AppColors.border, indent: 16),
                                ],
                              );
                            }),
                          ),
                        ),
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

  Widget _stat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(val, style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
          Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}

class _GradeItem {
  final String label;
  final double weight, earned;
  const _GradeItem(this.label, this.weight, this.earned);
}

const _gradeItems = [
  _GradeItem('حضور وأنشطة', 10, 9.5),
  _GradeItem('واجبات', 10, 8.0),
  _GradeItem('مشروع', 20, 18.0),
  _GradeItem('اختبار منتصف', 25, 22.5),
  _GradeItem('اختبار نهائي', 35, 31.0),
];

/// تفاصيل درجة مقرر واحد: تفصيل كل عنصر تقييم مع إمكانية طلب تظلم.
class GradeDetailScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  final VoidCallback onBack;
  const GradeDetailScreen({super.key, required this.onNav, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final total = _gradeItems.fold(0.0, (s, i) => s + i.earned);
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'تفاصيل درجة المقرر',
              sub: 'هندسة البرمجيات · CS401',
              onBack: onBack,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)),
                child: Text('A', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.success)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: [
                        Text(total.toStringAsFixed(0), style: GoogleFonts.cairo(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.success)),
                        Text('المجموع الكلي من 100', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(value: total / 100, minHeight: 8, backgroundColor: AppColors.bg, color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_gradeItems.length, (i) {
                        final item = _gradeItems[i];
                        final ratio = item.earned / item.weight;
                        final good = ratio >= 0.9;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('${item.earned} / ${item.weight.toStringAsFixed(0)}', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: good ? AppColors.success : AppColors.blue)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(value: ratio.clamp(0, 1), minHeight: 6, backgroundColor: AppColors.bg, color: good ? AppColors.success : AppColors.blue),
                                  ),
                                ],
                              ),
                            ),
                            if (i < _gradeItems.length - 1) const Divider(height: 1, color: AppColors.border),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SecondaryButton(label: 'تقديم طلب تظلم', onPressed: () => onNav('appeal')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _appealTypes = ['خطأ في رصد الدرجة', 'عدم احتساب واجب', 'خطأ في التصحيح', 'درجة الحضور', 'أخرى'];

/// شاشة تقديم طلب تظلم على درجة.
class AppealScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AppealScreen({super.key, required this.onBack});

  @override
  State<AppealScreen> createState() => _AppealScreenState();
}

class _AppealScreenState extends State<AppealScreen> {
  String _type = '';
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'طلب التظلم', sub: 'هندسة البرمجيات · CS401', onBack: widget.onBack),
            Expanded(
              child: _sent
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const AppIcon('check', size: 30, strokeWidth: 2.5, color: AppColors.success),
                        ),
                        const SizedBox(height: 16),
                        Center(child: Text('تم إرسال طلب التظلم', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text))),
                        const SizedBox(height: 8),
                        Center(child: Text('سيتم مراجعة طلبك خلال 7 أيام عمل والرد عبر البريد الجامعي.', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub, height: 1.7))),
                        const SizedBox(height: 16),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                            child: Text('رقم الطلب: TZ-2025-4471', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.blue)),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('سبب التظلم', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: _appealTypes.map((t) {
                                  final active = _type == t;
                                  return InkWell(
                                    onTap: () => setState(() => _type = t),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: active ? AppColors.blueLight : AppColors.bg,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: active ? AppColors.blue : AppColors.border, width: 1.5),
                                      ),
                                      child: Text(t, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: active ? AppColors.blue : AppColors.textSub)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('تفاصيل إضافية', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                              const SizedBox(height: 10),
                              TextField(
                                maxLines: 4,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.cairo(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'اشرح سبب طلب التظلم بالتفصيل...',
                                  hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                                  filled: true,
                                  fillColor: AppColors.bg,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PrimaryButton(label: 'إرسال طلب التظلم', onPressed: _type.isEmpty ? null : () => setState(() => _sent = true)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
