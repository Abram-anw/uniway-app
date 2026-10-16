import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/student_request.dart';
import '../../widgets/common.dart';

class _MyRequest {
  final String id, name, date, status;
  final Color color, bg;
  const _MyRequest(this.id, this.name, this.date, this.status, this.color, this.bg);
}

const _myRequests = [
  _MyRequest('REQ-2025-1048', 'إفادة قيد', '5 يناير 2025', 'قيد المراجعة', AppColors.warning, AppColors.warningLight),
  _MyRequest('REQ-2024-9874', 'كشف درجات رسمي', '18 ديسمبر 2024', 'مكتمل', AppColors.success, AppColors.successLight),
];

/// بوابة طلبات شؤون الطلاب: تقديم طلب جديد ومتابعة الطلبات الحالية.
class StudentAffairsPortalScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const StudentAffairsPortalScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'طلبات شئون الطلاب', subtitle: 'قدّم طلبك وتابع حالته', showNotif: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  PrimaryButton(label: 'تقديم طلب جديد', icon: 'plusCircle', onPressed: () => onNav('student-request-types')),
                  const SizedBox(height: 16),
                  Text('طلباتي', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 10),
                  ..._myRequests.map((r) {
                    return InkWell(
                      onTap: () => onNav('student-request-detail'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                  Text('${r.id} · ${r.date}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: r.bg, borderRadius: BorderRadius.circular(20)),
                              child: Text(r.status, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: r.color)),
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
      ),
    );
  }
}

/// اختيار نوع الطلب المطلوب تقديمه مع بحث.
class StudentRequestTypesScreen extends StatefulWidget {
  final ValueChanged<StudentRequestType> onSelect;
  final VoidCallback onBack;
  const StudentRequestTypesScreen({super.key, required this.onSelect, required this.onBack});

  @override
  State<StudentRequestTypesScreen> createState() => _StudentRequestTypesScreenState();
}

class _StudentRequestTypesScreenState extends State<StudentRequestTypesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = studentRequestTypes.where((t) => t.name.contains(_query) || t.description.contains(_query)).toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'اختيار نوع الطلب', sub: 'حدد الخدمة المطلوبة', onBack: widget.onBack),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [
                  const AppIcon('search', size: 17, strokeWidth: 2, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontSize: 13),
                      decoration: InputDecoration(hintText: 'ابحث عن نوع الطلب...', hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 11)),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const EmptyState(icon: 'file', text: 'لا توجد طلبات مطابقة')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: filtered.map((t) {
                        return InkWell(
                          onTap: () => widget.onSelect(t),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                                  alignment: Alignment.center,
                                  child: AppIcon(t.iconName, size: 20, color: AppColors.blue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(t.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                      Text(t.description, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted, height: 1.5)),
                                      const SizedBox(height: 3),
                                      Text('${t.requirements.length} مستندات وبيانات مطلوبة', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.blue)),
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

/// نموذج رفع مستندات وبيانات طلب شؤون الطلاب المختار.
class StudentRequestRequirementsScreen extends StatefulWidget {
  final StudentRequestType request;
  final VoidCallback onBack;
  final VoidCallback onSubmitted;
  const StudentRequestRequirementsScreen({super.key, required this.request, required this.onBack, required this.onSubmitted});

  @override
  State<StudentRequestRequirementsScreen> createState() => _StudentRequestRequirementsScreenState();
}

class _StudentRequestRequirementsScreenState extends State<StudentRequestRequirementsScreen> {
  final Map<int, String> _fileStates = {};
  final Map<int, String> _values = {};
  bool _confirm = false;

  int get _completed {
    final reqs = widget.request.requirements;
    int c = 0;
    for (var i = 0; i < reqs.length; i++) {
      if (reqs[i].kind == 'file') {
        if (_fileStates[i] == 'uploaded') c++;
      } else if ((_values[i] ?? '').trim().isNotEmpty) {
        c++;
      }
    }
    return c;
  }

  bool get _ready {
    final reqs = widget.request.requirements;
    for (var i = 0; i < reqs.length; i++) {
      if (!reqs[i].mandatory) continue;
      if (reqs[i].kind == 'file') {
        if (_fileStates[i] != 'uploaded') return false;
      } else if ((_values[i] ?? '').trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _upload(int index) {
    setState(() => _fileStates[index] = 'uploading');
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() => _fileStates[index] = 'uploaded');
    });
  }

  @override
  Widget build(BuildContext context) {
    final reqs = widget.request.requirements;
    final progress = reqs.isEmpty ? 0.0 : _completed / reqs.length;
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: widget.request.name, sub: 'متطلبات الطلب', onBack: widget.onBack),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('تم رفع $_completed من ${reqs.length} مستندات مطلوبة', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
                          Text('${(progress * 100).round()}%', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.blue)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: AppColors.border, color: _ready ? AppColors.success : AppColors.blue)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withValues(alpha: 0.25))),
                        child: Row(children: [
                          const AppIcon('alert', size: 17, strokeWidth: 2, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Expanded(child: Text('يجب رفع جميع المستندات الإلزامية قبل إرسال الطلب.', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning))),
                        ]),
                      ),
                      ...List.generate(reqs.length, (i) {
                        final r = reqs[i];
                        final state = _fileStates[i] ?? 'empty';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: state == 'uploaded' ? AppColors.success.withValues(alpha: 0.35) : AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(r.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(color: r.mandatory ? AppColors.dangerLight : AppColors.bg, borderRadius: BorderRadius.circular(20)),
                                    child: Text(r.mandatory ? 'إلزامي' : 'اختياري', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: r.mandatory ? AppColors.danger : AppColors.textMuted)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(r.hint, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                              if (r.kind == 'file') ...[
                                const SizedBox(height: 4),
                                Text('PDF / JPG / PNG – حتى 5MB', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                const SizedBox(height: 10),
                                if (state == 'uploading')
                                  Column(
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text('جاري رفع الملف...', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.blue)),
                                        Text('68%', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.blue)),
                                      ]),
                                      const SizedBox(height: 4),
                                      ClipRRect(borderRadius: BorderRadius.circular(5), child: LinearProgressIndicator(value: 0.68, minHeight: 5, backgroundColor: AppColors.blueLight, color: AppColors.blue)),
                                    ],
                                  )
                                else if (state == 'uploaded')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                    child: Row(children: [
                                      const AppIcon('checkCircle', size: 16, strokeWidth: 2, color: AppColors.success),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text('document-${i + 1}.pdf', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success))),
                                      const AppIcon('eye', size: 14, strokeWidth: 2, color: AppColors.success),
                                      const SizedBox(width: 8),
                                      InkWell(onTap: () => setState(() => _fileStates[i] = 'empty'), child: const AppIcon('trash', size: 14, strokeWidth: 2, color: AppColors.danger)),
                                    ]),
                                  ),
                                if (state != 'uploading')
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: () => _upload(i),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: state == 'uploaded' ? AppColors.success : AppColors.blue,
                                        backgroundColor: state == 'uploaded' ? Colors.white : AppColors.blueLight,
                                        side: BorderSide(color: state == 'uploaded' ? AppColors.success : AppColors.blue),
                                        padding: const EdgeInsets.symmetric(vertical: 9),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: Text(state == 'uploaded' ? 'تغيير الملف' : 'رفع الملف', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                              ] else if (r.kind == 'text') ...[
                                const SizedBox(height: 8),
                                TextField(
                                  maxLines: 3,
                                  textAlign: TextAlign.right,
                                  onChanged: (v) => setState(() => _values[i] = v),
                                  style: GoogleFonts.cairo(fontSize: 12),
                                  decoration: InputDecoration(hintText: r.hint, hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
                                ),
                              ] else if (r.kind == 'select') ...[
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                                  child: DropdownButton<String>(
                                    value: _values[i]?.isEmpty ?? true ? null : _values[i],
                                    hint: Text('اختر المقرر', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: (r.options ?? []).map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.cairo(fontSize: 12)))).toList(),
                                    onChanged: (v) => setState(() => _values[i] = v ?? ''),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 4),
                      Text('ملاحظات إضافية', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                      const SizedBox(height: 6),
                      TextField(
                        maxLines: 3,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(fontSize: 12),
                        decoration: InputDecoration(hintText: 'أي تفاصيل تساعد في مراجعة الطلب...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.card, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border))),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
                  child: PrimaryButton(label: 'إرسال الطلب', onPressed: _ready ? () => setState(() => _confirm = true) : null),
                ),
              ],
            ),
            if (_confirm)
              _ConfirmBox(
                title: 'هل أنت متأكد من إرسال الطلب؟',
                body: 'سيتم إرسال المستندات إلى شئون الطلاب للمراجعة، ويمكنك متابعة الحالة بعد الإرسال.',
                confirmLabel: 'إرسال الطلب',
                onCancel: () => setState(() => _confirm = false),
                onConfirm: widget.onSubmitted,
              ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmBox extends StatelessWidget {
  final String title, body, confirmLabel;
  final VoidCallback onCancel, onConfirm;
  const _ConfirmBox({required this.title, required this.body, required this.confirmLabel, required this.onCancel, required this.onConfirm});

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

/// شاشة نجاح إرسال الطلب مع رقم المتابعة.
class StudentRequestSuccessScreen extends StatelessWidget {
  final VoidCallback onTrack;
  final VoidCallback onBack;
  const StudentRequestSuccessScreen({super.key, required this.onTrack, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 16,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: const AppIcon('arrowRight', size: 18, color: AppColors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const AppIcon('checkCircle', size: 38, color: AppColors.success),
              ),
              const SizedBox(height: 18),
              Text('تم إرسال طلبك بنجاح', style: GoogleFonts.cairo(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.text)),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                child: Column(children: [
                  Text('رقم الطلب', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                  Text('REQ-2025-1052', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.blue)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20)),
                child: Text('جديد', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
              ),
              PrimaryButton(label: 'تتبع الطلب', onPressed: onTrack),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReqDoc {
  final String name, status, reason;
  final Color color, bg;
  const _ReqDoc(this.name, this.status, this.color, this.bg, this.reason);
}

const _reqDocs = [
  _ReqDoc('صورة بطاقة الرقم القومي', 'مقبول', AppColors.success, AppColors.successLight, ''),
  _ReqDoc('إيصال سداد مصروفات الفصل الحالي', 'مرفوض', AppColors.danger, AppColors.dangerLight, 'الصورة غير واضحة، يرجى رفع الإيصال كاملًا.'),
  _ReqDoc('جهة تقديم الإفادة', 'قيد المراجعة', AppColors.warning, AppColors.warningLight, ''),
];

/// تفاصيل طلب شؤون الطلاب: خط زمني، حالة كل مستند، وتواصل مع شؤون الطلاب.
class StudentRequestDetailScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onChat;
  const StudentRequestDetailScreen({super.key, required this.onBack, required this.onChat});

  @override
  Widget build(BuildContext context) {
    const steps = ['تم إرسال الطلب', 'مراجعة المستندات', 'اعتماد الطلب'];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'تفاصيل الطلب', sub: 'REQ-2025-1052', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('إفادة قيد', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.text)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                            child: Text('قيد المراجعة', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warning)),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Text('رقم الطلب: REQ-2025-1052 · 8 يناير 2025', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الخط الزمني', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 12),
                        ...List.generate(steps.length, (i) {
                          final done = i < 2;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(color: done ? AppColors.success : AppColors.border, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: done ? const AppIcon('check', size: 10, strokeWidth: 2.5, color: Colors.white) : null,
                              ),
                              const SizedBox(width: 10),
                              Text(steps[i], style: GoogleFonts.cairo(fontSize: 11, color: done ? AppColors.text : AppColors.textMuted, fontWeight: FontWeight.w700)),
                            ]),
                          );
                        }),
                      ],
                    ),
                  ),
                  Text('المستندات والبيانات', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 8),
                  ..._reqDocs.map((d) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(13), border: Border.all(color: d.status == 'مرفوض' ? AppColors.danger.withValues(alpha: 0.35) : AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text(d.name, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                decoration: BoxDecoration(color: d.bg, borderRadius: BorderRadius.circular(20)),
                                child: Text(d.status, style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: d.color)),
                              ),
                            ],
                          ),
                          if (d.reason.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(d.reason, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger))),
                          if (d.status == 'مرفوض')
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger), padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                  child: Text('إعادة رفع المستند', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SecondaryButton(label: 'محادثة شئون الطلاب', onPressed: onChat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
