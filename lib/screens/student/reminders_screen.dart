import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

/// شاشة التذكيرات: قائمة بالمواعيد النهائية مع إمكانية الاشتراك/إلغائه لكل منها.
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  late Map<int, bool> _subs;

  @override
  void initState() {
    super.initState();
    _subs = {for (var i = 0; i < allReminders.length; i++) i: allReminders[i].subscribed};
  }

  String _urgLabel(int days) => days <= 3 ? 'عاجل جداً' : days <= 10 ? 'قريب' : 'قادم';

  @override
  Widget build(BuildContext context) {
    final subscribedCount = _subs.values.where((v) => v).length;
    final urgentCount = List.generate(allReminders.length, (i) => i).where((i) => _subs[i] == true && allReminders[i].daysLeft <= 7).length;

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'التذكيرات', subtitle: 'المواعيد النهائية المسجلة', showNotif: true),
            Container(
              color: AppColors.card,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Expanded(child: _statBox('$subscribedCount', 'مشترك', AppColors.blue)),
                  const SizedBox(width: 10),
                  Expanded(child: _statBox('$urgentCount', 'عاجل', AppColors.danger)),
                  const SizedBox(width: 10),
                  Expanded(child: _statBox('${allReminders.length}', 'الكل', AppColors.textSub)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allReminders.length,
                itemBuilder: (context, i) {
                  final r = allReminders[i];
                  final sub = _subs[i] == true;
                  final color = AppColors.urgencyColor(r.urgency);
                  final bg = AppColors.urgencyBg(r.urgency);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        top: BorderSide(color: sub ? color.withValues(alpha: 0.25) : AppColors.border),
                        bottom: BorderSide(color: sub ? color.withValues(alpha: 0.25) : AppColors.border),
                        left: BorderSide(color: sub ? color.withValues(alpha: 0.25) : AppColors.border),
                        right: BorderSide(color: sub ? color : AppColors.border, width: 4),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.title, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text, height: 1.5)),
                                  const SizedBox(height: 2),
                                  Text(r.dept, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.blue)),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() => _subs[i] = !sub),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 42,
                                height: 24,
                                decoration: BoxDecoration(color: sub ? AppColors.blue : AppColors.border, borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                alignment: sub ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const AppIcon('calendar', size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 5),
                              Text(r.deadline, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                            ]),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
                              child: Text('${_urgLabel(r.daysLeft)} · ${r.daysLeft} يوم', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(val, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
