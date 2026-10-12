import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

class _ToggleRow {
  final String key, label, sub;
  const _ToggleRow(this.key, this.label, this.sub);
}

const _toggleRows = [
  _ToggleRow('academic', 'التنبيهات الأكاديمية', 'الدرجات والتسجيل والمحاضرات'),
  _ToggleRow('requests', 'تحديثات الطلبات', 'تغيّر حالة الطلب والمستندات'),
  _ToggleRow('messages', 'الرسائل', 'الدكاترة وشؤون الطلاب'),
  _ToggleRow('marketing', 'الأخبار والفعاليات', 'إعلانات الجامعة والأنشطة'),
  _ToggleRow('biometric', 'الدخول بالبصمة', 'حماية أسرع لهذا الجهاز'),
];

/// إعدادات الحساب والتنبيهات والأمان.
class StudentSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const StudentSettingsScreen({super.key, required this.onBack});

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  final Map<String, bool> _toggles = {'academic': true, 'requests': true, 'messages': true, 'marketing': false, 'biometric': true};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'الإعدادات', sub: 'الحساب والتنبيهات والأمان', onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Text('التنبيهات والأمان', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textSub)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_toggleRows.length, (i) {
                        final row = _toggleRows[i];
                        final on = _toggles[row.key] ?? false;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(row.label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text(row.sub, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => setState(() => _toggles[row.key] = !on),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 42,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(color: on ? AppColors.blue : AppColors.border, borderRadius: BorderRadius.circular(20)),
                                    alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(width: 18, height: 18, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                                  ),
                                ),
                              ]),
                            ),
                            if (i < _toggleRows.length - 1) const Divider(height: 1, color: AppColors.border, indent: 16),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: const Column(
                      children: [
                        RowItem(icon: 'user', color: AppColors.blue, bg: AppColors.blueLight, title: 'بيانات الحساب', sub: 'البريد الجامعي ورقم الهاتف'),
                        RowItem(icon: 'lock', color: AppColors.purple, bg: AppColors.purpleLight, title: 'تغيير كلمة المرور', sub: 'آخر تغيير منذ 3 أشهر'),
                        RowItem(icon: 'info', color: AppColors.success, bg: AppColors.successLight, title: 'عن UNIWAY', sub: 'الإصدار 2.4.1 · سياسة الخصوصية', divider: false),
                      ],
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

class _StudentPastRequest {
  final String id, type, date, status;
  final Color color, bg;
  final int progressSteps;
  const _StudentPastRequest(this.id, this.type, this.date, this.status, this.color, this.bg, this.progressSteps);
}

final _pastRequests = [
  _StudentPastRequest('REQ-1048', 'تظلم على درجة', '5 يناير 2025', 'قيد المراجعة', AppColors.warning, AppColors.warningLight, 2),
  _StudentPastRequest('DOC-9921', 'كشف درجات رسمي', '2 يناير 2025', 'مكتمل', AppColors.success, AppColors.successLight, 4),
  _StudentPastRequest('REG-7734', 'انسحاب من مقرر', '18 ديسمبر 2024', 'يحتاج معلومات', AppColors.danger, AppColors.dangerLight, 1),
];

/// سجل طلبات الطالب السابقة لشؤون الطلاب مع مؤشر تقدّم بصري.
class StudentRequestsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const StudentRequestsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'طلباتي السابقة', sub: 'متابعة كل الطلبات من مكان واحد', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: _pastRequests.map((r) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.type, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                Text('${r.id} · ${r.date}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: r.bg, borderRadius: BorderRadius.circular(20)), child: Text(r.status, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: r.color))),
                        ]),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(4, (i) {
                            return Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.only(left: i < 3 ? 4 : 0),
                                decoration: BoxDecoration(color: i < r.progressSteps ? r.color : AppColors.border, borderRadius: BorderRadius.circular(4)),
                              ),
                            );
                          }),
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
}

/// شاشة الدعم والإبلاغ عن مشكلة إدارية أو أكاديمية أو تقنية.
class SupportScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SupportScreen({super.key, required this.onBack});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _sent = false;
  String _type = 'إدارية';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'الدعم والإبلاغ', sub: 'سنرد عليك خلال يوم عمل', onBack: widget.onBack),
            Expanded(
              child: _sent
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        alignment: Alignment.center,
                        child: Column(children: [
                          Container(width: 60, height: 60, decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle), alignment: Alignment.center, child: const AppIcon('checkCircle', size: 28, color: AppColors.success)),
                          const SizedBox(height: 14),
                          Text('تم إرسال البلاغ بنجاح', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text)),
                          const SizedBox(height: 6),
                          Text('رقم المتابعة: SUP-2025-184', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                        ]),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('نوع المشكلة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                                child: DropdownButton<String>(
                                  value: _type,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: ['إدارية', 'أكاديمية', 'تقنية', 'اقتراح أو ملاحظة'].map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.cairo(fontSize: 12)))).toList(),
                                  onChanged: (v) => setState(() => _type = v!),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('وصف المشكلة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                              const SizedBox(height: 6),
                              TextField(
                                maxLines: 5,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.cairo(fontSize: 13),
                                decoration: InputDecoration(hintText: 'اشرح المشكلة بوضوح، وأضف رقم الطلب إن وجد...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(18),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border, width: 2)),
                          child: Column(children: [
                            const AppIcon('upload', size: 24, strokeWidth: 1.8, color: AppColors.textMuted),
                            const SizedBox(height: 6),
                            Text('إرفاق صورة أو مستند داعم', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                          ]),
                        ),
                        PrimaryButton(label: 'إرسال البلاغ', onPressed: () => setState(() => _sent = true)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
