import 'package:flutter/material.dart';
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
  _DocDef('shield', AppColors.blue, AppColors.blueLight, 'طلب تجنيد',
      'للطلبة المستجدين', 'طلب', AppColors.blue),
  _DocDef('file', AppColors.blue, AppColors.blueLight, 'طلب بيان حالة',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'طلب', AppColors.blue),
  _DocDef('layers', AppColors.purple, AppColors.purpleLight, 'طلب تعديل مسار',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'طلب', AppColors.purple),
  _DocDef('clipboard', Color(0xFFE11D48), Color(0xFFFFF1F2), 'طلب تظلم',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'ورقي', AppColors.danger),
  _DocDef('idCard', AppColors.success, AppColors.successLight, 'طلب إثبات قيد',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'طلب', AppColors.success),
  _DocDef('star', AppColors.warning, AppColors.warningLight, 'طلب بيان نجاح',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'طلب', AppColors.warning),
  _DocDef('metro', AppColors.blue, AppColors.blueLight, 'طلب عمل كارنيه مترو',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'طلب', AppColors.blue),
  _DocDef('award', AppColors.purple, AppColors.purpleLight, 'طلب شهادة التخرج',
      'المستندات والخطوات المطلوبة لتقديم هذا الطلب', 'طلب', AppColors.purple),
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
                            if (d.title == 'طلب شهادة التخرج') {
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

/// شاشة التقدم لطلب شهادة التخرج، مع التحقق من متطلبات التخرج أولاً.
class GraduationScreen extends StatefulWidget {
  final VoidCallback onBack;
  const GraduationScreen({super.key, required this.onBack});

  @override
  State<GraduationScreen> createState() => _GraduationScreenState();
}

class _GraduationScreenState extends State<GraduationScreen> {
  int _step = 0;
  bool _paymentUploaded = false;
  bool _confirm = false;
  static const bool _creditHoursEligible = true;

  @override
  Widget build(BuildContext context) {
    final ready = _creditHoursEligible && _paymentUploaded;
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: 'طلب شهادة التخرج', onBack: widget.onBack),
                Expanded(
                  child: _step == 0
                      ? ListView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: _creditHoursEligible ? AppColors.successLight : AppColors.dangerLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: _creditHoursEligible ? AppColors.success : AppColors.danger),
                              ),
                              child: Text(
                                _creditHoursEligible
                                    ? 'مؤهل لاستخراج شهادة التخرج'
                                    : 'غير مؤهل لاستخراج شهادة التخرج حاليًا',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: _creditHoursEligible ? AppColors.success : AppColors.danger,
                                ),
                              ),
                            ),
                            if (_creditHoursEligible) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.blueLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.blue.withValues(alpha: 0.18)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Text('1', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'سحب طلب شهادة التخرج من غرفة الـ IT',
                                        style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'صورة من دفع مصروفات طلب شهادة التخرج من على موقع الـ UMS',
                                            style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                          decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(20)),
                                          child: Text('إلزامي', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.danger)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('PDF / JPG / PNG – حتى 5MB', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                    const SizedBox(height: 10),
                                    if (_paymentUploaded)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                        child: Row(
                                          children: [
                                            const AppIcon('checkCircle', size: 16, color: AppColors.success),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text('graduation-payment.pdf',
                                                  style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                                            ),
                                            InkWell(
                                              onTap: () => setState(() => _paymentUploaded = false),
                                              child: const AppIcon('trash', size: 14, color: AppColors.danger),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () => setState(() => _paymentUploaded = true),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: _paymentUploaded ? AppColors.success : AppColors.blue,
                                          side: BorderSide(color: _paymentUploaded ? AppColors.success : AppColors.blue),
                                        ),
                                        child: Text(_paymentUploaded ? 'تغيير الملف' : 'رفع الملف',
                                            style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            Center(
                              child: Text('تم إرسال طلبك بنجاح',
                                  style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text)),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text('رقم الطلب: REQ-2025-1052',
                                  style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub)),
                            ),
                          ],
                        ),
                ),
                if (_step == 0 && _creditHoursEligible)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
                    child: PrimaryButton(
                      label: 'إرسال الطلب',
                      onPressed: ready ? () => setState(() => _confirm = true) : null,
                    ),
                  ),
              ],
            ),
            if (_confirm)
              Container(
                color: Colors.black.withValues(alpha: 0.45),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('هل أنت متأكد من إرسال الطلب؟',
                          style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => setState(() {
                                _confirm = false;
                                _step = 1;
                              }),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white),
                              child: Text('إرسال الطلب', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => setState(() => _confirm = false),
                              child: Text('إلغاء', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
