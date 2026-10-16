import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_icon.dart';

class NavTabDef {
  final String id, label, icon;
  const NavTabDef(this.id, this.label, this.icon);
}

/// شريط التنقل السفلي الخاص بالطالب.
class RoleBottomNav extends StatelessWidget {
  final List<NavTabDef> tabs;
  final String active;
  final ValueChanged<String> onChange;
  final bool showNotifDot;

  const RoleBottomNav({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChange,
    this.showNotifDot = false,
  });

  /// تبويبات الطالب.
  static const studentTabs = [
    NavTabDef('home', 'الرئيسية', 'home'),
    NavTabDef('courses', 'المقررات', 'book'),
    NavTabDef('documents', 'المستندات', 'file'),
    NavTabDef('notifications', 'الإشعارات', 'bell'),
    NavTabDef('profile', 'حسابي', 'user'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(top: 6, bottom: 10),
      child: Row(
        children: tabs.map((t) {
          final isActive = active == t.id;
          return Expanded(
            child: InkWell(
              onTap: () => onChange(t.id),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppIcon(
                        t.icon,
                        size: 21,
                        strokeWidth: isActive ? 2 : 1.5,
                        color: isActive ? AppColors.blue : AppColors.textMuted,
                      ),
                      if (showNotifDot && t.id == 'notifications')
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.white, width: 1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    t.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 9.5,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive ? AppColors.blue : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
