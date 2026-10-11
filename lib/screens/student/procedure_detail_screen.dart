import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/procedure.dart';
import '../../widgets/common.dart';

/// شاشة تفاصيل الإجراء: الخطوات، المستندات المطلوبة (مع تحديد ذاتي)،
/// موقع المكتب، وأزرار التذكير/الإبلاغ عن مشكلة.
class ProcedureDetailScreen extends StatefulWidget {
  final Procedure proc;
  final VoidCallback onBack;
  final VoidCallback onMap;
  const ProcedureDetailScreen({super.key, required this.proc, required this.onBack, required this.onMap});

  @override
  State<ProcedureDetailScreen> createState() => _ProcedureDetailScreenState();
}

class _ProcedureDetailScreenState extends State<ProcedureDetailScreen> {
  final Map<int, bool> _checked = {};

  bool get _allChecked => widget.proc.documents.asMap().keys.every((i) => _checked[i] == true);

  @override
  Widget build(BuildContext context) {
    final proc = widget.proc;
    final urgColor = proc.deadline?.urgency == 'danger' ? AppColors.danger : AppColors.warning;
    final urgBg = proc.deadline?.urgency == 'danger' ? AppColors.dangerLight : AppColors.warningLight;

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              color: AppColors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: widget.onBack,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: const AppIcon('chevronRight', size: 18, strokeWidth: 2.5, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('تفاصيل الإجراء', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.65))),
                            Text(proc.title, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                    child: Text(proc.dept, style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                children: [
                  if (proc.deadline != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: urgBg, borderRadius: BorderRadius.circular(14), border: Border.all(color: urgColor.withValues(alpha: 0.3))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: urgColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: AppIcon(proc.deadline!.urgency == 'danger' ? 'alert' : 'clock', size: 18, color: urgColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(proc.deadline!.label, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: urgColor)),
                                const SizedBox(height: 2),
                                Text(proc.deadline!.date, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: proc.deadline!.urgency == 'danger' ? AppColors.danger : AppColors.text)),
                                const SizedBox(height: 3),
                                Text('متبقٍّ ${proc.deadline!.daysLeft} أيام فقط', style: GoogleFonts.cairo(fontSize: 11, color: urgColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(child: _metricCard('clock', 'مدة الإجراء', proc.duration)),
                      const SizedBox(width: 10),
                      Expanded(child: _metricCard('clipboard', 'عدد الخطوات', '${proc.steps.length} خطوات')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('خطوات الإجراء', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 12),
                  ...List.generate(proc.steps.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text('${i + 1}', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                              child: Text(proc.steps[i], style: GoogleFonts.cairo(fontSize: 13, color: AppColors.text, height: 1.6)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المستندات المطلوبة', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                      if (_allChecked)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20)),
                          child: Row(children: [
                            const AppIcon('check', size: 11, strokeWidth: 2.5, color: AppColors.success),
                            const SizedBox(width: 4),
                            Text('مكتمل', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success)),
                          ]),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(proc.documents.length, (i) {
                        final isChecked = _checked[i] == true;
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => setState(() => _checked[i] = !isChecked),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: isChecked ? AppColors.success : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: isChecked ? AppColors.success : AppColors.border, width: 2),
                                      ),
                                      alignment: Alignment.center,
                                      child: isChecked ? const AppIcon('check', size: 12, strokeWidth: 3, color: Colors.white) : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        proc.documents[i],
                                        style: GoogleFonts.cairo(
                                          fontSize: 13,
                                          color: isChecked ? AppColors.textMuted : AppColors.text,
                                          decoration: isChecked ? TextDecoration.lineThrough : null,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (i < proc.documents.length - 1) const Divider(height: 1, color: AppColors.border, indent: 50),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('موقع المكتب', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: widget.onMap,
                          child: Container(
                            height: 100,
                            decoration: const BoxDecoration(color: Color(0xFFE8EEF4)),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Icon(Icons.map_outlined, size: 40, color: Color(0xFFC8D4E0)),
                                Positioned(
                                  bottom: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(20)),
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                      const AppIcon('externalLink', size: 12, strokeWidth: 2, color: Colors.white),
                                      const SizedBox(width: 6),
                                      Text('اضغط لعرض الخريطة الكاملة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: const AppIcon('mapPin', size: 17, color: AppColors.blue),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(proc.office.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                  Text(proc.office.building, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
                                  Text('${proc.office.floor} · غرفة ${proc.office.roomId}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(label: 'ذكّرني بالموعد النهائي', icon: 'bell', onPressed: () => _showRemindSheet(context)),
                  const SizedBox(height: 10),
                  SecondaryButton(label: 'الإبلاغ عن مشكلة في هذا الإجراء', onPressed: () => _showReportSheet(context)),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const AppIcon('info', size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 6),
                      Text(proc.lastUpdated, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String icon, String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          AppIcon(icon, size: 16, color: AppColors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.cairo(fontSize: 9, color: AppColors.textMuted)),
                Text(val, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRemindSheet(BuildContext context) {
    final proc = widget.proc;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const AppIcon('bell', size: 26, color: AppColors.blue),
              ),
              const SizedBox(height: 14),
              Text('تذكير بالموعد النهائي', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text)),
              const SizedBox(height: 6),
              Text(
                proc.deadline != null ? 'سيتم تذكيرك قبل ${proc.deadline!.date} بالإجراء:\n${proc.title}' : 'سيتم تذكيرك بإجراء:\n${proc.title}',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(fontSize: 12.5, color: AppColors.textSub, height: 1.6),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'تفعيل التذكير', onPressed: () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ReportSheetContent(),
    );
  }
}

const _reportTypes = ['معلومات غير دقيقة', 'خطوات ناقصة', 'مستندات مفقودة', 'موقع المكتب خاطئ', 'أخرى'];

class _ReportSheetContent extends StatefulWidget {
  @override
  State<_ReportSheetContent> createState() => _ReportSheetContentState();
}

class _ReportSheetContentState extends State<_ReportSheetContent> {
  bool _sent = false;
  String _selected = _reportTypes.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            if (_sent) ...[
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const AppIcon('check', size: 26, strokeWidth: 2.5, color: AppColors.success),
              ),
              const SizedBox(height: 14),
              Text('شكراً لإبلاغك!', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text)),
              const SizedBox(height: 6),
              Text('سيراجع فريقنا التقرير ويحدّث المعلومات قريباً.', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub, height: 1.6)),
              const SizedBox(height: 20),
              PrimaryButton(label: 'إغلاق', onPressed: () => Navigator.pop(context)),
            ] else ...[
              Text('الإبلاغ عن مشكلة', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text)),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: Text('نوع المشكلة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _reportTypes.map((t) {
                  final active = _selected == t;
                  return InkWell(
                    onTap: () => setState(() => _selected = t),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? AppColors.blue : AppColors.bg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: active ? AppColors.blue : AppColors.border),
                      ),
                      child: Text(t, style: GoogleFonts.cairo(fontSize: 11.5, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textSub)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              LabeledField(label: 'تفاصيل إضافية (اختياري)', hint: 'اشرح المشكلة بإيجاز...', maxLines: 3),
              PrimaryButton(label: 'إرسال البلاغ', onPressed: () => setState(() => _sent = true)),
            ],
          ],
        ),
      ),
    );
  }
}
