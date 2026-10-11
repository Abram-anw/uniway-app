import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_icon.dart';

class NavTabDef {
  final String id, label, icon;
  const NavTabDef(this.id, this.label, this.icon);
}

/// شريط تنقّل سفلي عام تُبنى عليه كل أشرطة الأدوار الأربعة
/// (TabBar / DocTabBar / SATabBar / AdminTabBar في الكود الأصلي).
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

  /// تبويبات الدكتور.
  static const docTabs = [
    NavTabDef('doc-dashboard', 'الرئيسية', 'home'),
    NavTabDef('doc-courses', 'مقرراتي', 'book'),
    NavTabDef('doc-grades', 'الدرجات', 'star'),
    NavTabDef('doc-chats', 'المحادثات', 'chat'),
    NavTabDef('profile', 'الملف', 'user'),
  ];

  /// تبويبات شؤون الطلاب.
  static const saTabs = [
    NavTabDef('sa-dashboard', 'الرئيسية', 'home'),
    NavTabDef('sa-requests', 'الطلبات', 'clipboard'),
    NavTabDef('sa-hs-requests', 'الثانوية', 'grad'),
    NavTabDef('sa-military', 'التربية العسكرية', 'military'),
    NavTabDef('profile', 'الملف', 'user'),
  ];

  /// تبويبات الإدارة.
  static const adminTabs = [
    NavTabDef('adm-dashboard', 'لوحة التحكم', 'home'),
    NavTabDef('adm-users', 'المستخدمون', 'users'),
    NavTabDef('adm-courses', 'المقررات', 'book'),
    NavTabDef('adm-requests', 'الطلبات', 'clipboard'),
    NavTabDef('adm-settings', 'الإعدادات', 'settings'),
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
                              border: Border.all(color: AppColors.white, width: 1.5),
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
