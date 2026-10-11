import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';
import 'doc_grades_screen.dart' show DoctorCourseDropdown;

class _DocLecture {
  final String week, topic, type, date;
  const _DocLecture(this.week, this.topic, this.type, this.date);
}

const _docLectures = [
  _DocLecture('الأسبوع 8', 'أنماط التصميم', 'PDF', 'اليوم'),
  _DocLecture('الأسبوع 7', 'معمارية النظام', 'PPT', 'الاثنين'),
  _DocLecture('الأسبوع 6', 'نمذجة UML', 'PDF', 'الأسبوع الماضي'),
];

/// محاضرات مقرر الدكتور الحالي مع إمكانية إضافة محاضرة جديدة.
class DocLecturesScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  final VoidCallback onBack;
  const DocLecturesScreen({super.key, required this.onNav, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'المحاضرات',
              sub: 'هندسة البرمجيات',
              onBack: onBack,
              trailing: InkWell(
                onTap: () => onNav('doc-upload-lecture'),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: const AppIcon('plusCircle', size: 18, color: AppColors.blue),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: _docLectures.map((l) {
                  final isPdf = l.type == 'PDF';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: isPdf ? AppColors.dangerLight : AppColors.warningLight, borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: Text(l.type, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w900, color: isPdf ? AppColors.danger : AppColors.warning)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.topic, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                              Text('${l.week} · ${l.date}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        const AppIcon('trash', size: 15, strokeWidth: 1.8, color: AppColors.textMuted),
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

/// شاشة رفع محاضرة جديدة لمقرر محدد.
class DocUploadLectureScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onNav;
  const DocUploadLectureScreen({super.key, required this.onBack, required this.onNav});

  @override
  State<DocUploadLectureScreen> createState() => _DocUploadLectureScreenState();
}

class _DocUploadLectureScreenState extends State<DocUploadLectureScreen> {
  String _course = '';
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _file = '';
  final Map<String, String> _errors = {};
  int _progress = 0;
  bool _confirmLeave = false;
  bool _done = false;

  bool get _dirty => _course.isNotEmpty || _titleCtrl.text.isNotEmpty || _descCtrl.text.isNotEmpty || _file.isNotEmpty;

  void _leave() {
    if (_dirty && !_done) {
      setState(() => _confirmLeave = true);
    } else {
      widget.onBack();
    }
  }

  void _submit() {
    final errs = <String, String>{};
    if (_course.isEmpty) errs['course'] = 'اختر المقرر';
    if (_titleCtrl.text.trim().isEmpty) errs['title'] = 'عنوان المحاضرة مطلوب';
    if (_file.isEmpty) errs['file'] = 'ملف المحاضرة مطلوب';
    setState(() => _errors
      ..clear()
      ..addAll(errs));
    if (errs.isNotEmpty) return;
    setState(() => _progress = 35);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _progress = 72);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _progress = 100;
          _done = true;
        });
      }
    });
  }

  void _reset() {
    setState(() {
      _titleCtrl.clear();
      _descCtrl.clear();
      _file = '';
      _progress = 0;
      _done = false;
      _errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: 'رفع محاضرة', onBack: _leave),
                Expanded(
                  child: _done
                      ? ListView(
                          padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const AppIcon('checkCircle', size: 30, color: AppColors.success),
                            ),
                            const SizedBox(height: 16),
                            Center(child: Text('تم رفع المحاضرة بنجاح', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text))),
                            const SizedBox(height: 6),
                            Center(child: Text(docCourses.firstWhere((c) => c.code == _course, orElse: () => docCourses.first).name, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub))),
                            const SizedBox(height: 5),
                            Center(child: Text('تم الرفع في: 06 أكتوبر 2026 – 10:30 ص', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.blue))),
                            const SizedBox(height: 4),
                            Center(child: Text('تم إشعار جميع الطلاب المسجلين في المقرر.', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted))),
                            const SizedBox(height: 22),
                            Row(children: [
                              Expanded(child: SecondaryButton(label: 'رفع محاضرة أخرى', onPressed: _reset)),
                              const SizedBox(width: 8),
                              Expanded(child: PrimaryButton(label: 'عرض المحاضرات', onPressed: () => widget.onNav('doc-lectures'))),
                            ]),
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
                                children: [
                                  DoctorCourseDropdown(
                                    selected: _course,
                                    onSelect: (v) => setState(() {
                                      _course = v;
                                      _errors.remove('course');
                                    }),
                                  ),
                                  if (_errors['course'] != null) Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.only(top: 4), child: Text(_errors['course']!, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger)))),
                                  const SizedBox(height: 12),
                                  Align(alignment: Alignment.centerRight, child: Text('عنوان المحاضرة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: _course.isNotEmpty ? AppColors.textSub : AppColors.textMuted))),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _titleCtrl,
                                    enabled: _course.isNotEmpty,
                                    onChanged: (_) => setState(() => _errors.remove('title')),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.cairo(fontSize: 13),
                                    decoration: InputDecoration(hintText: 'مثال: اختبارات البرمجيات', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _errors['title'] != null ? AppColors.danger : AppColors.border))),
                                  ),
                                  if (_errors['title'] != null) Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.only(top: 4), child: Text(_errors['title']!, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger)))),
                                  const SizedBox(height: 12),
                                  Align(alignment: Alignment.centerRight, child: Text('وصف المحاضرة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: _course.isNotEmpty ? AppColors.textSub : AppColors.textMuted))),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _descCtrl,
                                    enabled: _course.isNotEmpty,
                                    maxLines: 3,
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.cairo(fontSize: 13),
                                    decoration: InputDecoration(hintText: 'وصف مختصر للمحتوى (اختياري)', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
                                  ),
                                ],
                              ),
                            ),
                            Opacity(
                              opacity: _course.isNotEmpty ? 1 : 0.65,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(color: _course.isNotEmpty ? AppColors.card : AppColors.bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: _errors['file'] != null ? AppColors.danger : AppColors.border, width: 2)),
                                child: Column(
                                  children: [
                                    const AppIcon('upload', size: 28, strokeWidth: 1.5, color: AppColors.textMuted),
                                    const SizedBox(height: 8),
                                    Text('PDF / PPT / PPTX / DOCX / MP4', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                                    Text('الحد الأقصى 100MB', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                    if (_file.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 7), child: Text(_file, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success))),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: ElevatedButton(
                                        onPressed: _course.isEmpty ? null : () => setState(() {
                                              _file = 'lecture-testing.pdf';
                                              _errors.remove('file');
                                            }),
                                        style: ElevatedButton.styleFrom(backgroundColor: _course.isNotEmpty ? AppColors.blueLight : AppColors.border, foregroundColor: _course.isNotEmpty ? AppColors.blue : AppColors.textMuted, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: Text(_file.isNotEmpty ? 'تغيير الملف' : 'اختيار ملف', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_errors['file'] != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_errors['file']!, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger))),
                            if (_progress > 0 && _progress < 100)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Text('جاري رفع المحاضرة...', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.blue)),
                                      Text('$_progress%', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.blue)),
                                    ]),
                                    const SizedBox(height: 4),
                                    ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: _progress / 100, minHeight: 6, backgroundColor: AppColors.blueLight, color: AppColors.blue)),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 14),
                            PrimaryButton(label: 'رفع المحاضرة', onPressed: (_course.isEmpty || _progress > 0) ? null : _submit),
                          ],
                        ),
                ),
              ],
            ),
            if (_confirmLeave)
              _ConfirmOverlay(
                title: 'لديك بيانات غير محفوظة، هل تريد المتابعة؟',
                body: 'سيتم فقدان بيانات المحاضرة والملف المختار عند مغادرة الشاشة.',
                confirmLabel: 'مغادرة',
                onCancel: () => setState(() => _confirmLeave = false),
                onConfirm: widget.onBack,
              ),
          ],
        ),
      ),
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

/// بحث في السجلات الأكاديمية لطلاب الدكتور.
class DocRecordsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const DocRecordsScreen({super.key, required this.onBack});

  @override
  State<DocRecordsScreen> createState() => _DocRecordsScreenState();
}

class _DocRecordsScreenState extends State<DocRecordsScreen> {
  String _query = '';
  static const _students = ['أحمد العمري', 'سارة الزهراني', 'خالد المطيري', 'نورة السبيعي', 'عمر الشهري'];

  @override
  Widget build(BuildContext context) {
    final filtered = _students.where((s) => s.contains(_query)).toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'السجلات الأكاديمية', onBack: widget.onBack),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(children: [
                  const AppIcon('search', size: 16, strokeWidth: 2, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontSize: 13),
                      decoration: InputDecoration(hintText: 'ابحث عن طالب...', hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(filtered.length, (i) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(filtered[i][0], style: GoogleFonts.cairo(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(filtered[i], style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('معدل تراكمي: ${(3.5 + i * 0.2).toStringAsFixed(2)} · مستوى ${7 - i}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                const AppIcon('chevronLeft', size: 14, strokeWidth: 2, color: AppColors.textMuted),
                              ]),
                            ),
                            if (i < filtered.length - 1) const Divider(height: 1, color: AppColors.border, indent: 66),
                          ],
                        );
                      }),
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
}
