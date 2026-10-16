import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

class _AvailableCourse {
  final String code, name, dr, prereq, level;
  final int credits, seats;
  final bool eligible;
  final String reason;
  const _AvailableCourse(this.code, this.name, this.dr, this.credits, this.seats, this.prereq, this.level, this.eligible, this.reason);
}

const _available = [
  _AvailableCourse('CS480', 'تعلم الآلة', 'د. نورة السبيعي', 3, 12, 'الذكاء الاصطناعي', 'السابع', true, ''),
  _AvailableCourse('CS490', 'قواعد البيانات المتقدمة', 'د. عمر المطيري', 3, 5, 'قواعد البيانات', 'السابع', true, ''),
  _AvailableCourse('MATH401', 'الرياضيات التطبيقية', 'د. هند الشهري', 2, 20, 'الإحصاء والاحتمالات', 'السادس', true, ''),
  _AvailableCourse('CS471', 'معالجة اللغات الطبيعية', 'د. رياض العسيري', 3, 8, 'الذكاء الاصطناعي', 'الثامن', true, ''),
  _AvailableCourse('CS495', 'الحوسبة السحابية', 'د. سارة القحطاني', 3, 0, 'شبكات الحاسب', 'الثامن', false, 'لا توجد مقاعد متاحة'),
  _AvailableCourse('CS499', 'مشروع التخرج 2', 'د. أحمد الزهراني', 3, 15, 'مشروع التخرج 1', 'الثامن', false, 'يتطلب اجتياز مقرر مشروع التخرج 1'),
];

/// شاشة المقررات: "مقرراتي" الحالية أو "تسجيل المقررات" الجديدة مع حد الساعات.
class CoursesScreen extends StatefulWidget {
  final ValueChanged<String> onNav;
  const CoursesScreen({super.key, required this.onNav});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _tab = 'mine';
  String _semester = 'الفصل الأول';
  String _query = '';
  String _level = 'الكل';
  final Set<String> _selected = {};
  bool _confirm = false;
  bool _success = false;

  int get _hours => _selected.fold(0, (sum, code) => sum + _available.firstWhere((c) => c.code == code).credits);
  bool get _overLimit => _hours > 18;

  List<_AvailableCourse> get _shown => _available.where((c) {
        final matchLevel = _level == 'الكل' || c.level == _level;
        final matchQuery = _query.isEmpty || c.name.contains(_query) || c.code.toLowerCase().contains(_query.toLowerCase());
        return matchLevel && matchQuery;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                  color: AppColors.blue,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('المقررات', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                                Text('إدارة مقررات الفصل الدراسي', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                            child: Column(children: [
                              Text('17', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                              Text('ساعة معتمدة', style: GoogleFonts.cairo(fontSize: 9, color: Colors.white.withValues(alpha: 0.7))),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(11)),
                        child: Row(
                          children: [
                            Expanded(child: _tabBtn('mine', 'مقرراتي')),
                            Expanded(child: _tabBtn('register', 'تسجيل المقررات')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _tab == 'mine' ? _buildMine() : (_success ? _buildSuccess() : _buildRegister()),
                ),
              ],
            ),
            if (_confirm)
              _ConfirmOverlay(
                title: 'هل أنت متأكد من تسجيل المقررات المختارة؟',
                body: 'سيتم تسجيل ${_selected.length} مقررات بإجمالي $_hours ساعة معتمدة في $_semester.',
                confirmLabel: 'تأكيد التسجيل',
                onCancel: () => setState(() => _confirm = false),
                onConfirm: () => setState(() {
                  _confirm = false;
                  _success = true;
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String id, String label) {
    final active = _tab == id;
    return InkWell(
      onTap: () => setState(() {
        _tab = id;
        _success = false;
      }),
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(9)),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w700, color: active ? AppColors.blue : Colors.white)),
      ),
    );
  }

  Widget _buildMine() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        InkWell(
          onTap: () => widget.onNav('course-withdraw'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.danger.withValues(alpha: 0.2))),
            alignment: Alignment.center,
            child: Text('الانسحاب من مقرر', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.danger)),
          ),
        ),
        ...mockCourses.map((c) {
          return Container(
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
                          Text('${c.code} · ${c.dr}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20)),
                      child: Text('مسجل', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.success)),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(children: [
                  Text('${c.credits} ساعات', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(width: 12),
                  Text(c.schedule, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                ]),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSuccess() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const AppIcon('checkCircle', size: 32, strokeWidth: 2, color: AppColors.success),
          ),
          const SizedBox(height: 14),
          Text('تم تسجيل المقررات بنجاح', style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.text)),
          const SizedBox(height: 18),
          PrimaryButton(
            label: 'عرض مقرراتي',
            onPressed: () => setState(() {
              _tab = 'mine';
              _selected.clear();
              _success = false;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRegister() {
    final shown = _shown;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                child: DropdownButton<String>(
                  value: _semester,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: ['الفصل الأول', 'الفصل الثاني'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.cairo(fontSize: 12)))).toList(),
                  onChanged: (v) => setState(() => _semester = v!),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        const AppIcon('search', size: 14, strokeWidth: 2, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _query = v),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(fontSize: 11),
                            decoration: InputDecoration(hintText: 'ابحث عن مقرر...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                    child: DropdownButton<String>(
                      value: _level,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: ['الكل', 'السادس', 'السابع', 'الثامن'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.cairo(fontSize: 10)))).toList(),
                      onChanged: (v) => setState(() => _level = v!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: shown.isEmpty
              ? const EmptyState(icon: 'search', text: 'لا توجد مقررات مطابقة')
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 92),
                  children: shown.map((c) {
                    final checked = _selected.contains(c.code);
                    return Opacity(
                      opacity: c.eligible ? 1 : 0.6,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(13), border: Border.all(color: checked ? AppColors.success : AppColors.border)),
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
                                      Text(c.name, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.text)),
                                      Text('${c.code} · ${c.dr}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: !c.eligible
                                      ? null
                                      : () => setState(() {
                                            if (checked) {
                                              _selected.remove(c.code);
                                            } else {
                                              _selected.add(c.code);
                                            }
                                          }),
                                  borderRadius: BorderRadius.circular(9),
                                  child: Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(horizontal: 11),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: !c.eligible ? AppColors.border : (checked ? AppColors.successLight : AppColors.blue),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Text(checked ? 'تمت الإضافة' : 'إضافة',
                                        style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: !c.eligible ? AppColors.textMuted : (checked ? AppColors.success : Colors.white))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Wrap(spacing: 8, runSpacing: 4, children: [
                              Text('${c.credits} ساعات', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                              Text('${c.seats} مقعد متاح', style: GoogleFonts.cairo(fontSize: 10, color: c.seats < 10 ? AppColors.warning : AppColors.success)),
                              Text('المتطلب: ${c.prereq}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                            ]),
                            if (!c.eligible)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(c.reason, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger)),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('عدد المقررات المختارة: ${_selected.length} – إجمالي الساعات: $_hours',
                        style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w800, color: _overLimit ? AppColors.danger : AppColors.text)),
                    if (_overLimit) Text('تم تجاوز الحد الأقصى للساعات', style: GoogleFonts.cairo(fontSize: 9, color: AppColors.danger)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (_selected.isEmpty || _overLimit) ? null : () => setState(() => _confirm = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_selected.isNotEmpty && !_overLimit) ? AppColors.blue : AppColors.border,
                  foregroundColor: (_selected.isNotEmpty && !_overLimit) ? Colors.white : AppColors.textMuted,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('تأكيد التسجيل', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfirmOverlay extends StatelessWidget {
  final String title, body, confirmLabel;
  final VoidCallback onCancel, onConfirm;
  const _ConfirmOverlay({required this.title, required this.body, required this.confirmLabel, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
            const SizedBox(height: 8),
            Text(body, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub, height: 1.6)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(confirmLabel, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.text, side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text('إلغاء', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

/// شاشة الانسحاب من مقرر.
class CourseWithdrawScreen extends StatefulWidget {
  final VoidCallback onBack;
  const CourseWithdrawScreen({super.key, required this.onBack});

  @override
  State<CourseWithdrawScreen> createState() => _CourseWithdrawScreenState();
}

class _CourseWithdrawScreenState extends State<CourseWithdrawScreen> {
  String? _confirm;
  final Set<String> _withdrawn = {};

  @override
  Widget build(BuildContext context) {
    final courses = mockCourses.take(4).toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: 'الانسحاب من مقرر', sub: 'آخر موعد: 28 يناير 2025', onBack: widget.onBack),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withValues(alpha: 0.25))),
                        child: Text('تنبيه: الانسحاب بعد الأسبوع الثاني سيُسجَّل بدرجة W في السجل الأكاديمي',
                            style: GoogleFonts.cairo(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w600, height: 1.6)),
                      ),
                      ...courses.map((c) {
                        final isW = _withdrawn.contains(c.code);
                        return Opacity(
                          opacity: isW ? 0.5 : 1,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                      Text('${c.code} · ${c.credits} ساعات', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                isW
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                                        child: Text('تم الانسحاب', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning)),
                                      )
                                    : InkWell(
                                        onTap: () => setState(() => _confirm = c.code),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                          decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(10)),
                                          child: Text('انسحاب', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.danger)),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            if (_confirm != null)
              _ConfirmOverlay(
                title: 'تأكيد الانسحاب',
                body: 'هل أنت متأكد من الانسحاب من ${courses.firstWhere((c) => c.code == _confirm).name}؟',
                confirmLabel: 'تأكيد',
                onCancel: () => setState(() => _confirm = null),
                onConfirm: () => setState(() {
                  _withdrawn.add(_confirm!);
                  _confirm = null;
                }),
              ),
          ],
        ),
      ),
    );
  }
}
