import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/student_request.dart';
import '../../widgets/common.dart';

class _MyRequest {
  final String id, name, date, status;
  final Color color, bg;
  const _MyRequest(
      this.id, this.name, this.date, this.status, this.color, this.bg);
}

const _myRequests = [
  _MyRequest('REQ-2025-1048', 'طلب بيان حالة', '5 يناير 2025', 'قيد المراجعة',
      AppColors.warning, AppColors.warningLight),
  _MyRequest('REQ-2024-9874', 'طلب شهادة تخرج', '18 ديسمبر 2024', 'مكتمل',
      AppColors.success, AppColors.successLight),
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
            const SimpleAppBar(
                title: 'طلبات شئون الطلاب',
                subtitle: 'قدّم طلبك وتابع حالته',
                showNotif: true),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  PrimaryButton(
                      label: 'تقديم طلب جديد',
                      icon: 'plusCircle',
                      onPressed: () => onNav('student-request-types')),
                  const SizedBox(height: 16),
                  Text('طلباتي',
                      style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text)),
                  const SizedBox(height: 10),
                  ..._myRequests.map((r) {
                    return InkWell(
                      onTap: () => onNav('student-request-detail'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.name,
                                      style: GoogleFonts.cairo(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.text)),
                                  Text('${r.id} · ${r.date}',
                                      style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: r.bg,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(r.status,
                                  style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: r.color)),
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
  const StudentRequestTypesScreen(
      {super.key, required this.onSelect, required this.onBack});

  @override
  State<StudentRequestTypesScreen> createState() =>
      _StudentRequestTypesScreenState();
}

class _StudentRequestTypesScreenState extends State<StudentRequestTypesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = studentRequestTypes
        .where((t) =>
            t.titleAr.contains(_query) || t.descriptionAr.contains(_query))
        .toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'اختيار نوع الطلب',
                sub: 'حدد الخدمة المطلوبة',
                onBack: widget.onBack),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [
                  const AppIcon('search',
                      size: 17, strokeWidth: 2, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontSize: 13),
                      decoration: InputDecoration(
                          hintText: 'ابحث عن نوع الطلب...',
                          hintStyle: GoogleFonts.cairo(
                              fontSize: 12, color: AppColors.textMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 11)),
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
                            decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border)),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                      color: AppColors.blueLight,
                                      borderRadius: BorderRadius.circular(12)),
                                  alignment: Alignment.center,
                                  child: AppIcon(t.iconName,
                                      size: 20, color: AppColors.blue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t.titleAr,
                                          style: GoogleFonts.cairo(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.text)),
                                      Text(t.descriptionAr,
                                          style: GoogleFonts.cairo(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                              height: 1.5)),
                                      const SizedBox(height: 3),
                                      Builder(builder: (_) {
                                        final uploadCount = t.items
                                            .where((item) =>
                                                item.kind == 'upload' ||
                                                item.kind == 'payment_proof')
                                            .length;
                                        final stepCount = t.items
                                            .where((item) =>
                                                item.kind == 'physical_step')
                                            .length;
                                        final counts = <String>[
                                          if (uploadCount > 0)
                                            '$uploadCount مستندات',
                                          if (stepCount > 0) '$stepCount خطوات',
                                        ];
                                        return Text(counts.join(' • '),
                                            style: GoogleFonts.cairo(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.blue));
                                      }),
                                    ],
                                  ),
                                ),
                                const AppIcon('chevronLeft',
                                    size: 15,
                                    strokeWidth: 2,
                                    color: AppColors.textMuted),
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
  const StudentRequestRequirementsScreen(
      {super.key,
      required this.request,
      required this.onBack,
      required this.onSubmitted});

  @override
  State<StudentRequestRequirementsScreen> createState() =>
      _StudentRequestRequirementsScreenState();
}

class _StudentRequestRequirementsScreenState
    extends State<StudentRequestRequirementsScreen> {
  final Map<int, String> _fileStates = {};
  final Map<int, List<String>> _files = {};
  bool _confirm = false;

  bool get _stepsOnly =>
      widget.request.items.isNotEmpty &&
      widget.request.items.every((item) => item.kind == 'physical_step');

  List<RequestItem> get _uploadItems => widget.request.items
      .where((item) => item.kind == 'upload' || item.kind == 'payment_proof')
      .toList();

  int get _completed => _uploadItems.where((item) {
        final index = widget.request.items.indexOf(item);
        final files = _files[index] ?? const <String>[];
        return files.length >= item.maxFiles;
      }).length;

  bool get _ready {
    if (!widget.request.items.every(
        (item) => item.kind != 'condition' || mockMilitaryEducationPassed)) {
      return false;
    }
    for (final item in _uploadItems) {
      final index = widget.request.items.indexOf(item);
      final files = _files[index] ?? const <String>[];
      if (files.length < item.maxFiles) return false;
    }
    return _uploadItems.isNotEmpty;
  }

  void _upload(int index) {
    setState(() => _fileStates[index] = 'uploading');
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        final item = widget.request.items[index];
        final count = item.maxFiles;
        _files[index] =
            List<String>.generate(count, (i) => 'document-$index-${i + 1}.pdf');
        _fileStates[index] = 'uploaded';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reqs = widget.request.items;
    final progress =
        _uploadItems.isEmpty ? 0.0 : _completed / _uploadItems.length;
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(
                    title: widget.request.titleAr,
                    sub: 'متطلبات الطلب',
                    onBack: widget.onBack),
                if (!_stepsOnly)
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        border: Border(
                            bottom: BorderSide(color: AppColors.border))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'تم رفع $_completed من ${_uploadItems.length} مستندات مطلوبة',
                                style: GoogleFonts.cairo(
                                    fontSize: 11, color: AppColors.textSub)),
                            Text('${(progress * 100).round()}%',
                                style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blue)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: AppColors.border,
                                color: _ready
                                    ? AppColors.success
                                    : AppColors.blue)),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    children: [
                      if (!_stepsOnly)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.warning
                                      .withValues(alpha: 0.25))),
                          child: Row(children: [
                            const AppIcon('alert',
                                size: 17,
                                strokeWidth: 2,
                                color: AppColors.warning),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                    'يجب رفع جميع المستندات الإلزامية قبل إرسال الطلب.',
                                    style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warning))),
                          ]),
                        ),
                      ...List.generate(reqs.length, (i) {
                        final r = reqs[i];
                        final state = _fileStates[i] ?? 'empty';
                        if (r.kind == 'physical_step') {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: AppColors.blueLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.blue
                                        .withValues(alpha: 0.18))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                      color: AppColors.blue,
                                      shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text('${i + 1}',
                                      style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(r.labelAr,
                                            style: GoogleFonts.cairo(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.text)),
                                        if (r.hintAr != null) ...[
                                          const SizedBox(height: 4),
                                          Text(r.hintAr!,
                                              style: GoogleFonts.cairo(
                                                  fontSize: 11,
                                                  color: AppColors.textMuted)),
                                        ],
                                      ]),
                                ),
                              ],
                            ),
                          );
                        }
                        if (r.kind == 'condition') {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: mockMilitaryEducationPassed
                                  ? AppColors.successLight
                                  : AppColors.dangerLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: mockMilitaryEducationPassed
                                      ? AppColors.success
                                      : AppColors.danger),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    AppIcon(
                                        mockMilitaryEducationPassed
                                            ? 'checkCircle'
                                            : 'alert',
                                        size: 18,
                                        color: mockMilitaryEducationPassed
                                            ? AppColors.success
                                            : AppColors.danger),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Text(r.labelAr,
                                            style: GoogleFonts.cairo(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.text))),
                                  ]),
                                  if (!mockMilitaryEducationPassed) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                        'لا يمكنك تقديم هذا الطلب حاليًا لأنك لم تستوفِ هذا الشرط.',
                                        style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            color: AppColors.danger,
                                            height: 1.6)),
                                  ],
                                ]),
                          );
                        }
                        final files = _files[i] ?? const <String>[];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: state == 'uploaded'
                                      ? AppColors.success
                                          .withValues(alpha: 0.35)
                                      : AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(r.labelAr,
                                          style: GoogleFonts.cairo(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.text))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: AppColors.dangerLight,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text('إلزامي',
                                        style: GoogleFonts.cairo(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.danger)),
                                  ),
                                ],
                              ),
                              if (r.hintAr != null) ...[
                                const SizedBox(height: 5),
                                Text(r.hintAr!,
                                    style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        color: AppColors.textMuted)),
                              ],
                              if (r.copiesNote != null) ...[
                                const SizedBox(height: 5),
                                Text(r.copiesNote!,
                                    style: GoogleFonts.cairo(
                                        fontSize: 10,
                                        color: AppColors.textSub)),
                              ],
                              const SizedBox(height: 4),
                              Text('PDF / JPG / PNG – حتى 5MB',
                                  style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      color: AppColors.textMuted)),
                              const SizedBox(height: 10),
                              if (state == 'uploading')
                                Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('جاري رفع الملف...',
                                            style: GoogleFonts.cairo(
                                                fontSize: 10,
                                                color: AppColors.blue)),
                                        Text('68%',
                                            style: GoogleFonts.cairo(
                                                fontSize: 10,
                                                color: AppColors.blue)),
                                      ]),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: LinearProgressIndicator(
                                          value: 0.68,
                                          minHeight: 5,
                                          backgroundColor: AppColors.blueLight,
                                          color: AppColors.blue)),
                                ])
                              else if (state == 'uploaded')
                                ...files.map((file) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 8),
                                      margin: const EdgeInsets.only(bottom: 6),
                                      decoration: BoxDecoration(
                                          color: AppColors.successLight,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(children: [
                                        const AppIcon('checkCircle',
                                            size: 16,
                                            strokeWidth: 2,
                                            color: AppColors.success),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(file,
                                                style: GoogleFonts.cairo(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.success))),
                                        const AppIcon('eye',
                                            size: 14,
                                            strokeWidth: 2,
                                            color: AppColors.success),
                                        const SizedBox(width: 8),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                _files.remove(i);
                                                _fileStates[i] = 'empty';
                                              });
                                            },
                                            child: const AppIcon('trash',
                                                size: 14,
                                                strokeWidth: 2,
                                                color: AppColors.danger)),
                                      ]),
                                    )),
                              if (state != 'uploading')
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => _upload(i),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: state == 'uploaded'
                                          ? AppColors.success
                                          : AppColors.blue,
                                      backgroundColor: state == 'uploaded'
                                          ? Colors.white
                                          : AppColors.blueLight,
                                      side: BorderSide(
                                          color: state == 'uploaded'
                                              ? AppColors.success
                                              : AppColors.blue),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                        state == 'uploaded'
                                            ? 'تغيير الملف'
                                            : 'رفع الملف',
                                        style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                      if (_stepsOnly)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                              'هذا الطلب يتم ورقيًا، اتبع الخطوات أعلاه.',
                              style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warning)),
                        ),
                    ],
                  ),
                ),
                if (!_stepsOnly)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        border:
                            Border(top: BorderSide(color: AppColors.border))),
                    child: PrimaryButton(
                        label: 'إرسال الطلب',
                        onPressed: _ready
                            ? () => setState(() => _confirm = true)
                            : null),
                  ),
              ],
            ),
            if (_confirm)
              _ConfirmBox(
                title: 'هل أنت متأكد من إرسال الطلب؟',
                body:
                    'سيتم إرسال المستندات إلى شئون الطلاب للمراجعة، ويمكنك متابعة الحالة بعد الإرسال.',
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
  const _ConfirmBox(
      {required this.title,
      required this.body,
      required this.confirmLabel,
      required this.onCancel,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text)),
            const SizedBox(height: 8),
            Text(body,
                style: GoogleFonts.cairo(
                    fontSize: 13, color: AppColors.textSub, height: 1.6)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text(confirmLabel,
                      style: GoogleFonts.cairo(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.text,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: Text('إلغاء',
                      style: GoogleFonts.cairo(
                          fontSize: 13, fontWeight: FontWeight.w700)),
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
  const StudentRequestSuccessScreen(
      {super.key, required this.onTrack, required this.onBack});

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
                  child: const AppIcon('arrowRight',
                      size: 18, color: AppColors.blue),
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
                    decoration: const BoxDecoration(
                        color: AppColors.successLight, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const AppIcon('checkCircle',
                        size: 38, color: AppColors.success),
                  ),
                  const SizedBox(height: 18),
                  Text('تم إرسال طلبك بنجاح',
                      style: GoogleFonts.cairo(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text)),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(14)),
                    alignment: Alignment.center,
                    child: Column(children: [
                      Text('رقم الطلب',
                          style: GoogleFonts.cairo(
                              fontSize: 10, color: AppColors.textMuted)),
                      Text('REQ-2025-1052',
                          style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.blue)),
                    ]),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 22),
                    decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('جديد',
                        style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success)),
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

/// تفاصيل طلب شؤون الطلاب: خط زمني، حالة كل مستند، وتواصل مع شؤون الطلاب.
class StudentRequestDetailScreen extends StatelessWidget {
  final StudentRequestType request;
  final VoidCallback onBack;
  const StudentRequestDetailScreen(
      {super.key, required this.request, required this.onBack});

  @override
  Widget build(BuildContext context) {
    const steps = ['تم إرسال الطلب', 'مراجعة المستندات', 'اعتماد الطلب'];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'تفاصيل الطلب', sub: 'REQ-2025-1052', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(request.titleAr,
                                  style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.text)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: AppColors.warningLight,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text('قيد المراجعة',
                                    style: GoogleFonts.cairo(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warning)),
                              ),
                            ]),
                        const SizedBox(height: 8),
                        Text('رقم الطلب: REQ-2025-1052 · 8 يناير 2025',
                            style: GoogleFonts.cairo(
                                fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الخط الزمني',
                            style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text)),
                        const SizedBox(height: 12),
                        ...List.generate(steps.length, (i) {
                          final done = i < 2;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: done
                                        ? AppColors.success
                                        : AppColors.border,
                                    shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: done
                                    ? const AppIcon('check',
                                        size: 10,
                                        strokeWidth: 2.5,
                                        color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Text(steps[i],
                                  style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: done
                                          ? AppColors.text
                                          : AppColors.textMuted,
                                      fontWeight: FontWeight.w700)),
                            ]),
                          );
                        }),
                      ],
                    ),
                  ),
                  Text('المستندات والخطوات',
                      style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text)),
                  const SizedBox(height: 8),
                  ...request.items.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isUpload =
                        item.kind == 'upload' || item.kind == 'payment_proof';
                    final status = isUpload
                        ? (entry.key == 1
                            ? 'مرفوض'
                            : entry.key == 0
                                ? 'مقبول'
                                : 'قيد المراجعة')
                        : null;
                    final reason = entry.key == 1
                        ? 'الصورة غير واضحة، يرجى رفع المستند مرة أخرى.'
                        : '';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                              color: status == 'مرفوض'
                                  ? AppColors.danger.withValues(alpha: 0.35)
                                  : AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Text(item.labelAr,
                                      style: GoogleFonts.cairo(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.text))),
                              if (isUpload)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: status == 'مقبول'
                                        ? AppColors.successLight
                                        : status == 'مرفوض'
                                            ? AppColors.dangerLight
                                            : AppColors.warningLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(status!,
                                      style: GoogleFonts.cairo(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: status == 'مقبول'
                                              ? AppColors.success
                                              : status == 'مرفوض'
                                                  ? AppColors.danger
                                                  : AppColors.warning)),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: AppColors.blueLight,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                      item.kind == 'physical_step'
                                          ? 'خطوة ورقية'
                                          : 'شرط',
                                      style: GoogleFonts.cairo(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.blue)),
                                ),
                            ],
                          ),
                          if (reason.isNotEmpty)
                            Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(reason,
                                    style: GoogleFonts.cairo(
                                        fontSize: 10,
                                        color: AppColors.danger))),
                          if (status == 'مرفوض')
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.danger,
                                      side: const BorderSide(
                                          color: AppColors.danger),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(9))),
                                  child: Text('إعادة رفع المستند',
                                      style: GoogleFonts.cairo(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                        ],
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
