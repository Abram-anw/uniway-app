import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

class _Notif {
  final String icon, title, body, time;
  final Color color, bg;
  final bool read;
  const _Notif(this.icon, this.color, this.bg, this.title, this.body, this.time, this.read);
}

const _notifs = [
  _Notif('alert', AppColors.danger, AppColors.dangerLight, 'موعد التظلم ينتهي قريباً', 'تبقى يومان على إغلاق باب التظلم من درجات الاختبار النهائي', 'منذ ساعة', false),
  _Notif('checkCircle', AppColors.success, AppColors.successLight, 'تم رصد درجتك', 'تم رفع درجة الميدتيرم لمقرر هندسة البرمجيات.', 'منذ دقائق', false),
  _Notif('library', AppColors.blue, AppColors.blueLight, 'محاضرة جديدة', 'تم رفع محاضرة اختبارات البرمجيات لمقرر هندسة البرمجيات.', 'منذ دقائق', false),
  _Notif('calendar', AppColors.blue, AppColors.blueLight, 'تذكير: تسجيل المقررات', 'نافذة تسجيل مقررات الفصل القادم تغلق بعد 9 أيام', 'أمس', true),
  _Notif('announce', AppColors.purple, AppColors.purpleLight, 'إعلان من الكلية', 'سيُعقد اجتماع عام للطلاب يوم الأحد القادم في القاعة الكبرى', 'منذ يومين', true),
  _Notif('file', AppColors.warning, AppColors.warningLight, 'وثيقة جاهزة للاستلام', 'كشف الدرجات الذي طلبته جاهز للاستلام من مكتب شؤون الطلاب', 'منذ 3 أيام', true),
];

/// شاشة الإشعارات بكل أنواعها (درجات، محاضرات، إعلانات، وثائق).
class NotificationsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const NotificationsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'الإشعارات'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: _notifs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final n = _notifs[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: n.read ? AppColors.card : AppColors.blueLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: n.read ? AppColors.border : AppColors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: n.bg, borderRadius: BorderRadius.circular(10)),
                          alignment: Alignment.center,
                          child: AppIcon(n.icon, size: 18, color: n.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(n.title, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text))),
                                  if (!n.read) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(n.body, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub, height: 1.5)),
                              const SizedBox(height: 4),
                              Text(n.time, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                            ],
                          ),
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
}
