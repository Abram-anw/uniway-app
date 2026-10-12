import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

class _DocDef {
  final String icon, title, sub, badge;
  final Color color, bg, badgeColor;
  const _DocDef(this.icon, this.color, this.bg, this.title, this.sub, this.badge, this.badgeColor);
}

const _docs = [
  _DocDef('file', AppColors.blue, AppColors.blueLight, 'كشف الدرجات الرسمي', 'متاح · آخر طلب منذ أسبوع', 'مجاناً', AppColors.success),
  _DocDef('award', AppColors.purple, AppColors.purpleLight, 'شهادة التخرج', 'يتطلب استيفاء المتطلبات', 'قريباً', AppColors.textMuted),
  _DocDef('grad', AppColors.success, AppColors.successLight, 'شهادة قيد', 'متاحة فوراً', '10 ريال', AppColors.blue),
  _DocDef('star', AppColors.warning, AppColors.warningLight, 'شهادة إجادة لغة', 'مشروطة باجتياز الاختبار', '25 ريال', AppColors.blue),
  _DocDef('clipboard', Color(0xFFE11D48), Color(0xFFFFF1F2), 'خطاب تعريفي', 'فوري · باللغتين', 'مجاناً', AppColors.success),
  _DocDef('shield', Color(0xFF15803D), Color(0xFFF0FDF4), 'السجل الأكاديمي الكامل', 'متاح بطلب رسمي', '15 ريال', AppColors.blue),
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
            const SimpleAppBar(title: 'المستندات', subtitle: 'طلب الوثائق الرسمية'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
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
                            if (d.title == 'شهادة التخرج') onNav?.call('graduation');
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
  final bool done;
  const _GradReq(this.label, this.done);
}

const _gradReqs = [
  _GradReq('إتمام 132 ساعة معتمدة', true),
  _GradReq('معدل تراكمي لا يقل عن 2.0', true),
  _GradReq('اجتياز متطلبات الكلية', true),
  _GradReq('تسوية المستحقات المالية', false),
  _GradReq('إعادة الكتب للمكتبة', false),
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

  @override
  Widget build(BuildContext context) {
    final allDone = _gradReqs.every((r) => r.done);
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
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('متطلبات التخرج', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                              const SizedBox(height: 12),
                              ..._gradReqs.map((r) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(color: r.done ? AppColors.successLight : AppColors.dangerLight, shape: BoxShape.circle),
                                          alignment: Alignment.center,
                                          child: AppIcon(r.done ? 'check' : 'x', size: 12, strokeWidth: 2.5, color: r.done ? AppColors.success : AppColors.danger),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(r.label, style: GoogleFonts.cairo(fontSize: 13, color: r.done ? AppColors.text : AppColors.danger, fontWeight: r.done ? FontWeight.w400 : FontWeight.w600))),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        if (!allDone)
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(14)),
                            child: Text('يرجى استيفاء جميع المتطلبات قبل التقديم.', style: GoogleFonts.cairo(fontSize: 13, color: AppColors.warning, fontWeight: FontWeight.w600)),
                          )
                        else
                          PrimaryButton(label: 'تقديم الطلب', onPressed: () => setState(() => _step = 1)),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: const AppIcon('award', size: 30, color: AppColors.success),
                        ),
                        const SizedBox(height: 16),
                        Center(child: Text('تم استلام طلبك', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text))),
                        const SizedBox(height: 8),
                        Center(child: Text('سيتم مراجعة طلبك وإشعارك باستلام الشهادة خلال 14 يوم عمل.', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub, height: 1.7))),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
