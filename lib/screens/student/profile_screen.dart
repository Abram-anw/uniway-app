import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../auth/login_screen.dart';

class _StatDef {
  final String label, val;
  const _StatDef(this.label, this.val);
}

class _MenuDef {
  final String icon, label, sub, nav;
  final Color color;
  const _MenuDef(this.icon, this.label, this.sub, this.color, this.nav);
}

class _RoleProfile {
  final String name, meta, avatar;
  final List<_StatDef> stats;
  const _RoleProfile(this.name, this.meta, this.avatar, this.stats);
}

String _roleHomeScreen(UserRole r) {
  switch (r) {
    case UserRole.doctor:
      return 'doc-dashboard';
    case UserRole.affairs:
      return 'sa-dashboard';
    case UserRole.admin:
      return 'adm-dashboard';
    case UserRole.highschool:
      return 'hs-entry';
    case UserRole.student:
      return 'home';
  }
}

/// شاشة الملف الشخصي، تختلف بياناتها وقائمتها حسب دور المستخدم الحالي.
class ProfileScreen extends StatefulWidget {
  final UserRole role;
  final ValueChanged<String> onNav;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.role, required this.onNav, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _confirmLogout = false;

  _RoleProfile get _profile {
    switch (widget.role) {
      case UserRole.student:
        return const _RoleProfile('أحمد محمد العمري', 'علوم الحاسب · المستوى السابع', 'أ', [
          _StatDef('رقم الطالب', '4410123456'),
          _StatDef('المعدل التراكمي', '4.21'),
          _StatDef('الساعات المنجزة', '112'),
        ]);
      case UserRole.doctor:
        return const _RoleProfile('د. سارة القحطاني', 'قسم علوم الحاسب · أستاذ مساعد', 'س', [
          _StatDef('الرقم الوظيفي', 'F-1023'),
          _StatDef('المقررات', '3'),
          _StatDef('الطلاب', '115'),
        ]);
      case UserRole.affairs:
        return const _RoleProfile('نورة البشري', 'شؤون الطلاب · وحدة الطلبات', 'ن', [
          _StatDef('الرقم الوظيفي', 'S-0087'),
          _StatDef('طلبات اليوم', '12'),
          _StatDef('مكتملة', '47'),
        ]);
      case UserRole.admin:
        return const _RoleProfile('م. خالد السالم', 'مدير نظام UNIWAY', 'خ', [
          _StatDef('الرقم الوظيفي', 'A-0001'),
          _StatDef('المستخدمون', '2.4K'),
          _StatDef('تنبيهات النظام', '3'),
        ]);
      case UserRole.highschool:
        return const _RoleProfile('محمد أحمد السالم', 'متقدم جديد · ADM-2025-8847', 'م', [
          _StatDef('رقم الطلب', '8847'),
          _StatDef('الرغبات', '3'),
          _StatDef('الحالة', 'مراجعة'),
        ]);
    }
  }

  List<_MenuDef> get _menuItems {
    final items = <_MenuDef>[];
    if (widget.role == UserRole.student) {
      items.add(const _MenuDef('file', 'طلباتي السابقة', '3 طلبات نشطة', AppColors.blue, 'student-requests'));
    }
    items.add(_MenuDef('bell', 'إعدادات الإشعارات', 'تخصيص التنبيهات', AppColors.warning,
        widget.role == UserRole.student ? 'student-settings' : _roleHomeScreen(widget.role)));
    items.add(const _MenuDef('mail', 'التواصل مع الدعم', 'الإبلاغ عن مشكلة أو طلب مساعدة', AppColors.success, 'student-support'));
    items.add(const _MenuDef('star', 'تقييم التطبيق', 'شاركنا رأيك', AppColors.purple, 'student-support'));
    items.add(_MenuDef('settings', 'الإعدادات', 'الخصوصية والأمان والحساب', AppColors.textSub,
        widget.role == UserRole.admin ? 'adm-settings' : 'student-settings'));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final p = _profile;
    final menuItems = _menuItems;
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              color: AppColors.blue,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                    ),
                    alignment: Alignment.center,
                    child: Text(p.avatar, style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  Text(p.name, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(p.meta, style: GoogleFonts.cairo(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: p.stats.map((s) {
                        return Expanded(
                          child: Column(
                            children: [
                              Text(s.val, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(s.label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white.withValues(alpha: 0.65))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  InkWell(
                    onTap: () => widget.onNav('student-support'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.blue.withValues(alpha: 0.25))),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            child: const AppIcon('mail', size: 20, color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('أبلغ عن مشكلة إدارية', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.blue)),
                                const SizedBox(height: 2),
                                Text('لاحظت مشكلة في إجراء ما؟ ساعدنا في تحسين الخدمة.', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub, height: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(menuItems.length, (i) {
                        final item = menuItems[i];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => widget.onNav(item.nav),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                                      alignment: Alignment.center,
                                      child: AppIcon(item.icon, size: 18, color: item.color),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                          Text(item.sub, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                        ],
                                      ),
                                    ),
                                    const AppIcon('chevronLeft', size: 14, color: AppColors.textMuted),
                                  ],
                                ),
                              ),
                            ),
                            if (i < menuItems.length - 1) const Divider(height: 1, color: AppColors.border, indent: 64),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_confirmLogout)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.danger.withValues(alpha: 0.4))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('هل تريد تسجيل الخروج؟', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                          const SizedBox(height: 4),
                          Text('ستحتاج إلى إدخال بياناتك مرة أخرى.', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.onLogout,
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text('تأكيد الخروج', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => setState(() => _confirmLogout = false),
                                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSub, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text('إلغاء', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => setState(() => _confirmLogout = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dangerLight,
                          foregroundColor: AppColors.danger,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3))),
                        ),
                        child: Text('تسجيل الخروج', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700)),
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
