import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

class _DocDef {
  final String icon, title, sub, badge;
  final Color color, bg, badgeColor;
  const _DocDef(this.icon, this.color, this.bg, this.title, this.sub,
      this.badge, this.badgeColor);
}

const _docs = [
  _DocDef('file', AppColors.blue, AppColors.blueLight, 'كشف الدرجات الرسمي',
      'متاح · آخر طلب منذ أسبوع', 'مجاناً', AppColors.success),
  _DocDef('award', AppColors.purple, AppColors.purpleLight, 'شهادة التخرج',
      'تقديم إلكتروني بعد استيفاء الشروط', 'طلب', AppColors.purple),
  _DocDef('grad', AppColors.success, AppColors.successLight, 'شهادة قيد',
      'متاحة فوراً', '10 ريال', AppColors.blue),
  _DocDef('star', AppColors.warning, AppColors.warningLight, 'شهادة إجادة لغة',
      'مشروطة باجتياز الاختبار', '25 ريال', AppColors.blue),
  _DocDef('clipboard', Color(0xFFE11D48), Color(0xFFFFF1F2), 'خطاب تعريفي',
      'فوري · باللغتين', 'مجاناً', AppColors.success),
  _DocDef('shield', Color(0xFF15803D), Color(0xFFF0FDF4),
      'السجل الأكاديمي الكامل', 'متاح بطلب رسمي', '15 ريال', AppColors.blue),
];

/// شاشة طلب المستندات والشهادات الرسمية.
class DocumentsScreen extends StatelessWidget {
  final ValueChanged<String>? onNav;
  const DocumentsScreen({super.key, this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(
                title: 'المستندات', subtitle: 'طلب الوثائق الرسمية'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_docs.length, (i) {
                        final d = _docs[i];
                        return RowItem(
                          icon: d.icon,
                          color: d.color,
                          bg: d.bg,
                          title: d.title,
                          sub: d.sub,
                          badge: d.badge,
                          badgeColor: d.badgeColor,
                          divider: i < _docs.length - 1,
                          onTap: () {
                            if (d.title == 'شهادة التخرج') {
                              onNav?.call('graduation');
                            }
                          },
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

class _GradReq {
  final String label;
  final String? hint;
  final bool needsProof;
  const _GradReq(this.label, {this.hint, this.needsProof = false});
}

const _gradReqs = [
  _GradReq('صورة بطاقة الرقم القومي',
      hint: 'صورة واضحة للوجهين.', needsProof: true),
  _GradReq('صورة شخصية حديثة بخلفية بيضاء',
      hint: 'صورة رسمية حديثة.', needsProof: true),
  _GradReq(
    'شهادة إتمام الخدمة العسكرية أو الإعفاء',
    hint: 'أرفق مستندًا رسميًا يوضح الموقف من الخدمة العسكرية.',
    needsProof: true,
  ),
  _GradReq(
    'إفادة اجتياز التدريب الميداني',
    hint: 'أرفق إفادة مختومة من جهة التدريب.',
    needsProof: true,
  ),
  _GradReq(
    'استمارة إخلاء الطرف',
    hint: 'أرفق إخلاء طرف معتمدًا من جميع الجهات.',
    needsProof: true,
  ),
  _GradReq(
    'إفادة إتمام 132 ساعة معتمدة بنجاح',
    hint: 'أرفق كشفًا أو إفادة رسمية بإتمام ساعات النجاح المطلوبة.',
    needsProof: true,
  ),
];

/// شاشة التقدم لطلب شهادة التخرج، مع التحقق من متطلبات التخرج أولاً.
class GraduationScreen extends StatefulWidget {
  final VoidCallback onBack;
  const GraduationScreen({super.key, required this.onBack});

  @override
  State<GraduationScreen> createState() => _GraduationScreenState();
}

class _GraduationScreenState extends State<GraduationScreen> {
  int _step = 0;
  final Map<int, String> _proofs = {};

  Future<void> _pickProof(int index) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (!mounted || result.isEmpty) return;
    setState(() => _proofs[index] = result.single.name);
  }

  void _removeProof(int index) {
    setState(() => _proofs.remove(index));
  }

  @override
  Widget build(BuildContext context) {
    final allDone = _gradReqs.asMap().entries.every((entry) {
      final requirement = entry.value;
      return !requirement.needsProof || _proofs.containsKey(entry.key);
    });
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'طلب شهادة التخرج', onBack: widget.onBack),
            Expanded(
              child: _step == 0
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.warningLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color:
                                    AppColors.warning.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  size: 18, color: AppColors.warning),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'يجب رفع جميع المستندات الإلزامية قبل إرسال الطلب.',
                                  style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.warning),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('شروط استخراج شهادة التخرج',
                                  style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.text)),
                              const SizedBox(height: 4),
                              Text(
                                'راجع الشروط وأرفق ما يثبت استيفاءها قبل تقديم الطلب.',
                                style: GoogleFonts.cairo(
                                    fontSize: 11, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 14),
                              ..._gradReqs.asMap().entries.map((entry) {
                                final index = entry.key;
                                final requirement = entry.value;
                                final hasProof = _proofs.containsKey(index);
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    color: hasProof
                                        ? AppColors.successLight
                                            .withValues(alpha: 0.45)
                                        : AppColors.bg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: hasProof
                                          ? AppColors.success
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              color: hasProof
                                                  ? AppColors.success
                                                  : AppColors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: hasProof
                                                    ? AppColors.success
                                                    : AppColors.textMuted,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: hasProof
                                                ? const AppIcon('check',
                                                    size: 12,
                                                    strokeWidth: 2.5,
                                                    color: Colors.white)
                                                : Text('${index + 1}',
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 10,
                                                        color: AppColors
                                                            .textMuted)),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              requirement.label,
                                              style: GoogleFonts.cairo(
                                                  fontSize: 12.5,
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.text),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (requirement.hint != null) ...[
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 32),
                                          child: Text(
                                            requirement.hint!,
                                            style: GoogleFonts.cairo(
                                                fontSize: 10.5,
                                                height: 1.5,
                                                color: AppColors.textSub),
                                          ),
                                        ),
                                      ],
                                      if (requirement.needsProof) ...[
                                        const SizedBox(height: 8),
                                        if (hasProof)
                                          Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: AppColors.successLight,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.check_circle,
                                                        size: 18,
                                                        color:
                                                            AppColors.success),
                                                    const SizedBox(width: 7),
                                                    Expanded(
                                                      child: Text(
                                                        _proofs[index]!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.cairo(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: AppColors
                                                                    .success),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.visibility,
                                                          size: 18),
                                                      color: AppColors.success,
                                                      tooltip: 'عرض الملف',
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          _removeProof(index),
                                                      icon: const Icon(
                                                          Icons.delete_outline,
                                                          size: 18),
                                                      color: AppColors.danger,
                                                      tooltip: 'حذف الملف',
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              OutlinedButton(
                                                onPressed: () =>
                                                    _pickProof(index),
                                                child: Text('تغيير الملف',
                                                    style: GoogleFonts.cairo(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                            ],
                                          )
                                        else
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton.icon(
                                              onPressed: () => _pickProof(index),
                                              icon: const Icon(
                                                  Icons.upload_file_outlined,
                                                  size: 17),
                                              label: Text('رفع المستند',
                                                  style: GoogleFonts.cairo(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        if (!allDone)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color: AppColors.warningLight,
                                borderRadius: BorderRadius.circular(14)),
                            child: Text(
                                'يجب رفع جميع المستندات المطلوبة لتفعيل تقديم الطلب.',
                                style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    height: 1.6,
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600)),
                          )
                        else
                          PrimaryButton(
                              label: 'تقديم الطلب',
                              onPressed: () => setState(() => _step = 1)),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                              color: AppColors.successLight,
                              shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const AppIcon('award',
                              size: 30, color: AppColors.success),
                        ),
                        const SizedBox(height: 16),
                        Center(
                            child: Text('تم استلام طلبك',
                                style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.text))),
                        const SizedBox(height: 8),
                        Center(
                            child: Text(
                                'سيتم مراجعة طلبك وإشعارك باستلام الشهادة خلال 14 يوم عمل.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    color: AppColors.textSub,
                                    height: 1.7))),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
