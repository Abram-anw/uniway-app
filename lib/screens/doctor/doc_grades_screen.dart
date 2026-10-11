import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

/// قائمة مقررات الدكتور وحالة تسليم درجاتها.
class DocGradesScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const DocGradesScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'الدرجات', subtitle: 'إدارة وتسليم الدرجات'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: docCourses.map((c) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                Text('${c.code} · ${c.students} طالباً', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: c.submitted ? AppColors.successLight : AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                              child: Text(c.submitted ? 'مُسلَّمة' : 'معلقة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: c.submitted ? AppColors.success : AppColors.warning)),
                            ),
                          ],
                        ),
                        if (!c.submitted) ...[
                          const SizedBox(height: 8),
                          PrimaryButton(label: 'رفع الدرجات', onPressed: () => onNav('doc-upload-grades')),
                        ],
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

/// قائمة منسدلة لاختيار مقرر الدكتور مع بحث (يقابل DoctorCourseDropdown).
class DoctorCourseDropdown extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  final bool disabled;
  const DoctorCourseDropdown({super.key, required this.selected, required this.onSelect, this.disabled = false});

  @override
  State<DoctorCourseDropdown> createState() => _DoctorCourseDropdownState();
}

class _DoctorCourseDropdownState extends State<DoctorCourseDropdown> {
  bool _open = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final selectedCourse = docCourses.where((c) => c.code == widget.selected).toList();
    final filtered = docCourses.where((c) => c.code.toLowerCase().contains(_query.toLowerCase()) || c.name.contains(_query)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اختر المقرر', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: widget.disabled ? AppColors.textMuted : AppColors.textSub)),
        const SizedBox(height: 6),
        InkWell(
          onTap: widget.disabled ? null : () => setState(() => _open = !_open),
          borderRadius: BorderRadius.circular(11),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(color: widget.disabled ? AppColors.bg : AppColors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: _open ? AppColors.blue : AppColors.border)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCourse.isNotEmpty ? '${selectedCourse.first.code} – ${selectedCourse.first.name} – ${selectedCourse.first.students} طالب' : 'اختر المقرر',
                    style: GoogleFonts.cairo(fontSize: 12, color: selectedCourse.isNotEmpty ? AppColors.text : AppColors.textMuted),
                  ),
                ),
                const AppIcon('chevronLeft', size: 14, strokeWidth: 2, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        if (_open)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 10))]),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(9)),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    const AppIcon('search', size: 14, strokeWidth: 2, color: AppColors.textMuted),
                    const SizedBox(width: 7),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(fontSize: 11),
                        decoration: InputDecoration(hintText: 'ابحث عن مقرر...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 8)),
                      ),
                    ),
                  ]),
                ),
                ...filtered.map((c) {
                  final isSel = widget.selected == c.code;
                  return InkWell(
                    onTap: () {
                      widget.onSelect(c.code);
                      setState(() {
                        _open = false;
                        _query = '';
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      decoration: BoxDecoration(color: isSel ? AppColors.blueLight : Colors.transparent, borderRadius: BorderRadius.circular(8)),
                      child: Text('${c.code} – ${c.name} – ${c.students} طالب', textAlign: TextAlign.right, style: GoogleFonts.cairo(fontSize: 11, color: isSel ? AppColors.blue : AppColors.text)),
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}

const Map<String, List<Map<String, String>>> _studentsByCourse = {
  'CS401': [
    {'id': '4410112345', 'name': 'أحمد العمري'},
    {'id': '4410112346', 'name': 'سارة الزهراني'},
    {'id': '4410112347', 'name': 'خالد المطيري'},
    {'id': '4410112348', 'name': 'نورة السبيعي'},
  ],
  'CS415': [
    {'id': '4410211021', 'name': 'ريم الغامدي'},
    {'id': '4410211022', 'name': 'عمر الشهري'},
    {'id': '4410211023', 'name': 'محمد السالم'},
  ],
  'CS440': [
    {'id': '4410314011', 'name': 'ليان القحطاني'},
    {'id': '4410314012', 'name': 'عبدالله الشمري'},
    {'id': '4410314013', 'name': 'فاطمة الحربي'},
  ],
};

/// شاشة رفع الدرجات: إدخال يدوي أو عبر ملف Excel، مع التحقق من الحد الأقصى.
class DocUploadGradesScreen extends StatefulWidget {
  final VoidCallback onBack;
  const DocUploadGradesScreen({super.key, required this.onBack});

  @override
  State<DocUploadGradesScreen> createState() => _DocUploadGradesScreenState();
}

class _DocUploadGradesScreenState extends State<DocUploadGradesScreen> {
  String _course = '';
  String _pendingCourse = '';
  String _method = 'manual';
  String _semester = 'الفصل الأول 2025/2026';
  String _gradeType = 'ميدتيرم';
  final Map<int, String> _grades = {};
  bool _saved = false;
  bool _reviewed = false;
  bool _confirmSend = false;
  bool _confirmCourse = false;
  bool _done = false;

  int get _maxGrade => _gradeType == 'ميدتيرم' ? 30 : _gradeType == 'أعمال سنة' ? 40 : 60;
  List<Map<String, String>> get _students => _studentsByCourse[_course] ?? [];
  bool get _dirty => _grades.values.any((v) => v.isNotEmpty) && !_saved;
  bool get _invalid => _grades.values.any((v) => v.isNotEmpty && (double.tryParse(v) == null || double.parse(v) < 0 || double.parse(v) > _maxGrade));

  void _chooseCourse(String code) {
    if (_course.isNotEmpty && code != _course && _dirty) {
      setState(() {
        _pendingCourse = code;
        _confirmCourse = true;
      });
      return;
    }
    setState(() {
      _course = code;
      _grades.clear();
      _saved = false;
      _reviewed = false;
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
                BackHeader(title: 'رفع الدرجات', sub: 'إدخال ومراجعة درجات الطلاب', onBack: widget.onBack),
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
                            Center(child: Text('تم إرسال الدرجات بنجاح', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text))),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'تم إشعار كل طالب بدرجته في ${docCourses.firstWhere((c) => c.code == _course, orElse: () => docCourses.first).name}.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                              child: Column(
                                children: [
                                  DoctorCourseDropdown(selected: _course, onSelect: _chooseCourse),
                                  const SizedBox(height: 12),
                                  Align(alignment: Alignment.centerRight, child: Text('الفصل الدراسي', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub))),
                                  const SizedBox(height: 6),
                                  _dropdownField(_semester, ['الفصل الأول 2025/2026', 'الفصل الثاني 2025/2026'], (v) => setState(() => _semester = v)),
                                  const SizedBox(height: 12),
                                  Align(alignment: Alignment.centerRight, child: Text('نوع الدرجات', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub))),
                                  const SizedBox(height: 6),
                                  _dropdownField(_gradeType, ['ميدتيرم', 'أعمال سنة', 'فاينال'], (v) => setState(() {
                                        _gradeType = v;
                                        _grades.clear();
                                        _saved = false;
                                      })),
                                ],
                              ),
                            ),
                            Row(children: [
                              Expanded(child: _methodBtn('manual', 'إدخال يدوي')),
                              const SizedBox(width: 8),
                              Expanded(child: _methodBtn('file', 'رفع ملف Excel')),
                            ]),
                            const SizedBox(height: 16),
                            if (_course.isEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 38),
                                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, style: BorderStyle.solid)),
                                alignment: Alignment.center,
                                child: Column(children: [
                                  const AppIcon('users', size: 34, strokeWidth: 1.5, color: AppColors.border),
                                  const SizedBox(height: 10),
                                  Text('اختر المقرر لعرض قائمة الطلاب', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                                ]),
                              )
                            else if (_method == 'manual')
                              Container(
                                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                                      decoration: const BoxDecoration(color: AppColors.blueLight),
                                      child: Row(children: [
                                        Expanded(flex: 11, child: Text('الرقم الجامعي', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.blue))),
                                        Expanded(flex: 14, child: Text('اسم الطالب', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.blue))),
                                        Expanded(flex: 8, child: Text('الدرجة', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.blue))),
                                        Expanded(flex: 7, child: Text('الحالة', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.blue))),
                                      ]),
                                    ),
                                    ...List.generate(_students.length, (i) {
                                      final value = _grades[i] ?? '';
                                      final error = value.isNotEmpty && (double.tryParse(value) == null || double.parse(value) < 0 || double.parse(value) > _maxGrade);
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(flex: 11, child: Text(_students[i]['id']!, style: GoogleFonts.cairo(fontSize: 9, color: AppColors.textMuted))),
                                            Expanded(flex: 14, child: Text(_students[i]['name']!, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.text))),
                                            Expanded(
                                              flex: 8,
                                              child: SizedBox(
                                                height: 30,
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  onChanged: (v) => setState(() {
                                                    _grades[i] = v;
                                                    _saved = false;
                                                    _reviewed = false;
                                                  }),
                                                  style: GoogleFonts.cairo(fontSize: 10),
                                                  decoration: InputDecoration(filled: true, fillColor: AppColors.bg, contentPadding: const EdgeInsets.symmetric(vertical: 5), border: OutlineInputBorder(borderRadius: BorderRadius.circular(7), borderSide: BorderSide(color: error ? AppColors.danger : AppColors.border))),
                                                ),
                                              ),
                                            ),
                                            Expanded(flex: 7, child: Text(error ? 'خطأ' : value.isNotEmpty ? 'مدخل' : 'فارغ', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: error ? AppColors.danger : value.isNotEmpty ? AppColors.success : AppColors.textMuted))),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 2)),
                                alignment: Alignment.center,
                                child: Column(children: [
                                  const AppIcon('upload', size: 32, strokeWidth: 1.5, color: AppColors.textMuted),
                                  const SizedBox(height: 12),
                                  Text('اسحب ملف Excel هنا أو', style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.blueLight, foregroundColor: AppColors.blue, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    child: Text('اختر ملفاً', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('قم بتنزيل قالب Excel أولاً', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                ]),
                              ),
                            if (_reviewed)
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                child: Text('تمت مراجعة الدرجات ولا توجد أخطاء.', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                              ),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: (_course.isEmpty || _invalid) ? null : () => setState(() => _saved = true),
                                  style: OutlinedButton.styleFrom(foregroundColor: _course.isNotEmpty ? AppColors.blue : AppColors.textMuted, side: BorderSide(color: _course.isNotEmpty ? AppColors.blue : AppColors.border), padding: const EdgeInsets.symmetric(vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                                  child: Text('حفظ', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: (_course.isEmpty || _invalid) ? null : () => setState(() => _reviewed = true),
                                  style: OutlinedButton.styleFrom(foregroundColor: _course.isNotEmpty ? AppColors.blue : AppColors.textMuted, side: BorderSide(color: _course.isNotEmpty ? AppColors.blue : AppColors.border), padding: const EdgeInsets.symmetric(vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                                  child: Text('مراجعة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: (_course.isEmpty || _invalid) ? null : () => setState(() => _confirmSend = true),
                                  style: ElevatedButton.styleFrom(backgroundColor: (_course.isNotEmpty && !_invalid) ? AppColors.blue : AppColors.border, foregroundColor: (_course.isNotEmpty && !_invalid) ? Colors.white : AppColors.textMuted, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                                  child: Text('إرسال الدرجات', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ]),
                          ],
                        ),
                ),
              ],
            ),
            if (_confirmCourse)
              _ConfirmOverlay(
                title: 'لديك درجات غير محفوظة، هل تريد المتابعة؟',
                body: 'سيؤدي تغيير المقرر إلى فقدان الدرجات التي لم يتم حفظها.',
                confirmLabel: 'متابعة',
                onCancel: () => setState(() => _confirmCourse = false),
                onConfirm: () => setState(() {
                  _course = _pendingCourse;
                  _grades.clear();
                  _saved = false;
                  _reviewed = false;
                  _confirmCourse = false;
                }),
              ),
            if (_confirmSend)
              _ConfirmOverlay(
                title: 'هل أنت متأكد من إرسال الدرجات؟',
                body: 'سيتم نشر درجات $_gradeType وإرسال إشعار لكل طالب مسجل في المقرر.',
                confirmLabel: 'إرسال الدرجات',
                onCancel: () => setState(() => _confirmSend = false),
                onConfirm: () => setState(() {
                  _confirmSend = false;
                  _done = true;
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _methodBtn(String id, String label) {
    final active = _method == id;
    return InkWell(
      onTap: () => setState(() => _method = id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: active ? AppColors.blueLight : AppColors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: active ? AppColors.blue : AppColors.border, width: 1.5)),
        child: Text(label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: active ? AppColors.blue : AppColors.textSub)),
      ),
    );
  }

  Widget _dropdownField(String value, List<String> options, ValueChanged<String> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.cairo(fontSize: 12)))).toList(),
        onChanged: (v) => onChanged(v!),
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
