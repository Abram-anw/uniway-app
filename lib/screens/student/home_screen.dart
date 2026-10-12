import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../models/procedure.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  final ValueChanged<Procedure> onSelectProc;
  const HomeScreen(
      {super.key, required this.onNav, required this.onSelectProc});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(context),
            _buildServices(context),
            _buildDeadlines(context),
            _buildQuickActions(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 36,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('صباح الخير',
                          style: GoogleFonts.cairo(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.75))),
                      Text('👋 أحمد العمري',
                          style: GoogleFonts.cairo(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.2)),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: () => onNav('notifications'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(11)),
                          alignment: Alignment.center,
                          child: const AppIcon('bell',
                              size: 18, color: Colors.white, strokeWidth: 1.7),
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -1,
                        child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                                color: AppColors.danger,
                                shape: BoxShape.circle)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          InkWell(
            onTap: () => onNav('search'),
            borderRadius: BorderRadius.circular(11),
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(11)),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ابحث عن إجراء، خدمة، أو قسم...',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(
                          fontSize: 10, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const AppIcon('search',
                      size: 16, color: AppColors.textMuted, strokeWidth: 1.7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServices(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        children: [
          _sectionTitle('استكشف الخدمات', 'عرض الكل', () => onNav('search')),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
              childAspectRatio: 0.91,
            ),
            itemBuilder: (context, index) {
              final category = homeCategories[index];
              return InkWell(
                onTap: () => onNav(category.nav),
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColors.border)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: category.bg,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: AppIcon(category.iconName,
                            size: 19, color: category.color, strokeWidth: 1.7),
                      ),
                      const SizedBox(height: 6),
                      Text(category.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: GoogleFonts.cairo(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                              height: 1.25)),
                      const SizedBox(height: 2),
                      Text('${category.count} إجراء',
                          style: GoogleFonts.cairo(
                              fontSize: 8.5, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlines(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
      child: Column(
        children: [
          _sectionTitle(
              'المواعيد النهائية', 'عرض الكل', () => onNav('reminders')),
          const SizedBox(height: 8),
          ...homeDeadlines.map((deadline) {
            final statusColor = _deadlineColor(deadline.daysLeft);
            final statusBackground = _deadlineBackground(deadline.daysLeft);
            return InkWell(
              onTap: () => onSelectProc(allProcedures.firstWhere(
                  (procedure) => procedure.title.contains('الاعتراض'),
                  orElse: () => allProcedures.first)),
              borderRadius: BorderRadius.circular(11),
              child: Container(
                height: 78,
                margin: const EdgeInsets.only(bottom: 9),
                padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppColors.border),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(3))),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: statusBackground,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              '${deadline.daysLeft} يوم${deadline.daysLeft == 2 ? ' فقط' : ''}',
                              style: GoogleFonts.cairo(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  color: statusColor)),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 9,
                      left: 74,
                      top: 0,
                      bottom: 0,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(deadline.title,
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cairo(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.text,
                                      height: 1.3)),
                            ),
                            const SizedBox(height: 2),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(deadline.date,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.cairo(
                                          fontSize: 8.5,
                                          color: AppColors.textMuted)),
                                  const SizedBox(width: 4),
                                  const AppIcon('calendar',
                                      size: 11,
                                      color: AppColors.textMuted,
                                      strokeWidth: 1.5),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(deadline.dept,
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.cairo(
                                      fontSize: 8.5, color: statusColor)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      (
        'chat',
        'المحادثات',
        AppColors.blue,
        AppColors.blueLight,
        'doctor-chat-list'
      ),
      (
        'alert',
        'التظلم من\nالدرجة',
        AppColors.danger,
        AppColors.dangerLight,
        'grades'
      ),
      (
        'award',
        'طلب شهادة',
        AppColors.success,
        AppColors.successLight,
        'documents'
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
      child: Column(
        children: [
          _sectionTitle('إجراءات سريعة', null, null),
          const SizedBox(height: 8),
          Row(
            children: actions.map((action) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => onNav(action.$5),
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: AppColors.border)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcon(action.$1,
                              size: 18, color: action.$3, strokeWidth: 1.7),
                          const SizedBox(height: 5),
                          Text(action.$2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cairo(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                  height: 1.25)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String? action, VoidCallback? onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.text)),
        if (action != null)
          InkWell(
              onTap: onAction,
              child: Text(action,
                  style:
                      GoogleFonts.cairo(fontSize: 9.5, color: AppColors.blue)))
        else
          const SizedBox(),
      ],
    );
  }

  Color _deadlineColor(int days) {
    if (days <= 2) return AppColors.danger;
    if (days <= 9) return AppColors.warning;
    return AppColors.success;
  }

  Color _deadlineBackground(int days) {
    if (days <= 2) return AppColors.dangerLight;
    if (days <= 9) return AppColors.warningLight;
    return AppColors.successLight;
  }
}
