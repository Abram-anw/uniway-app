import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

const _adminQuickLinks = [
  ('users', AppColors.blue, AppColors.blueLight, 'المستخدمون', 'adm-users'),
  ('layers', AppColors.purple, AppColors.purpleLight, 'الأدوار', 'adm-roles'),
  ('book', AppColors.success, AppColors.successLight, 'المقررات', 'adm-courses'),
  ('grid4', AppColors.warning, AppColors.warningLight, 'الأقسام', 'adm-departments'),
  ('clipboard', Color(0xFFE11D48), Color(0xFFFFF1F2), 'الطلبات', 'adm-requests'),
  ('grad', Color(0xFF15803D), Color(0xFFF0FDF4), 'القبول', 'adm-admission'),
  ('star', AppColors.blue, AppColors.blueLight, 'الدرجات', 'adm-grades'),
  ('file', AppColors.warning, AppColors.warningLight, 'المستندات', 'adm-documents'),
  ('announce', Color(0xFFE11D48), Color(0xFFFFF1F2), 'الإعلانات', 'adm-announcements'),
  ('database', AppColors.purple, AppColors.purpleLight, 'قاعدة المعرفة', 'adm-ai-kb'),
  ('clipboard', AppColors.blue, AppColors.blueLight, 'إدارة متطلبات الطلبات', 'adm-request-requirements'),
  ('settings', AppColors.textSub, AppColors.border, 'الإعدادات', 'adm-settings'),
];

/// لوحة تحكم الإدارة الرئيسية بجميع الإجراءات الإدارية.
class AdminDashboardScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const AdminDashboardScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              color: AppColors.blue,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('لوحة تحكم', style: GoogleFonts.cairo(fontSize: 12, color: Colors.white.withValues(alpha: 0.65))),
                            Text('إدارة النظام', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const AppIcon('bell', size: 20, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _stat('2,481', 'مستخدم')),
                    const SizedBox(width: 8),
                    Expanded(child: _stat('312', 'مقرر')),
                    const SizedBox(width: 8),
                    Expanded(child: _stat('47', 'طلب معلق')),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Text('الإجراءات الإدارية', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.95,
                    children: _adminQuickLinks.map((q) {
                      return InkWell(
                        onTap: () => onNav(q.$5),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 40, height: 40, decoration: BoxDecoration(color: q.$3, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: AppIcon(q.$1, size: 20, color: q.$2)),
                              const SizedBox(height: 8),
                              Text(q.$4, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.text)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: Column(children: [
        Text(val, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
      ]),
    );
  }
}

class _AdminUser {
  final String name, role, id, status;
  const _AdminUser(this.name, this.role, this.id, this.status);
}

const _adminUsers = [
  _AdminUser('أحمد العمري', 'طالب', '4410112345', 'active'),
  _AdminUser('د. سارة القحطاني', 'عضو هيئة التدريس', 'F-1023', 'active'),
  _AdminUser('خالد المطيري', 'طالب', '4410112347', 'suspended'),
  _AdminUser('نورة البشري', 'موظف شؤون الطلاب', 'S-0087', 'active'),
  _AdminUser('عمر الشهري', 'طالب', '4410112349', 'active'),
];

/// إدارة المستخدمين وإضافة حسابات جديدة.
class AdminUsersScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const AdminUsersScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            SimpleAppBar(title: 'المستخدمون', subtitle: '${_adminUsers.length} مستخدم'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                child: Row(children: [
                  const AppIcon('search', size: 15, strokeWidth: 2, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(child: Text('بحث عن مستخدم...', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted))),
                ]),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_adminUsers.length, (i) {
                        final u = _adminUsers[i];
                        final active = u.status == 'active';
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(width: 38, height: 38, decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle), alignment: Alignment.center, child: Text(u.name[0], style: GoogleFonts.cairo(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700))),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(u.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('${u.role} · ${u.id}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: active ? AppColors.successLight : AppColors.dangerLight, borderRadius: BorderRadius.circular(20)), child: Text(active ? 'نشط' : 'موقوف', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: active ? AppColors.success : AppColors.danger))),
                              ]),
                            ),
                            if (i < _adminUsers.length - 1) const Divider(height: 1, color: AppColors.border, indent: 66),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(label: 'إضافة مستخدم جديد', icon: 'plusCircle', onPressed: () => onNav('adm-add-user')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// نموذج إضافة مستخدم جديد بدور وحالة.
class AdminAddUserScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AdminAddUserScreen({super.key, required this.onBack});

  @override
  State<AdminAddUserScreen> createState() => _AdminAddUserScreenState();
}

class _AdminAddUserScreenState extends State<AdminAddUserScreen> {
  bool _saved = false;
  String _role = 'طالب';
  String _status = 'نشط';
  static const _fields = ['الاسم الكامل', 'البريد الجامعي', 'الرقم الجامعي / الوظيفي', 'القسم'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'إضافة مستخدم', sub: 'إنشاء حساب وصلاحيات جديدة', onBack: widget.onBack),
            Expanded(
              child: _saved
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                        alignment: Alignment.center,
                        child: Column(children: [
                          const AppIcon('checkCircle', size: 42, color: AppColors.success),
                          const SizedBox(height: 12),
                          Text('تم إنشاء المستخدم بنجاح', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.text)),
                          const SizedBox(height: 5),
                          Text('تم إرسال رابط تفعيل الحساب إلى البريد الجامعي.', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
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
                            children: [
                              ..._fields.map((f) => LabeledField(label: f, hint: f)),
                              Align(alignment: Alignment.centerRight, child: Text('الدور', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub))),
                              const SizedBox(height: 6),
                              _dropdown(_role, ['طالب', 'عضو هيئة التدريس', 'شؤون الطلاب', 'مدير نظام'], (v) => setState(() => _role = v)),
                              const SizedBox(height: 12),
                              Align(alignment: Alignment.centerRight, child: Text('الحالة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub))),
                              const SizedBox(height: 6),
                              _dropdown(_status, ['نشط', 'موقوف مؤقتًا'], (v) => setState(() => _status = v)),
                            ],
                          ),
                        ),
                        PrimaryButton(label: 'إنشاء المستخدم', onPressed: () => setState(() => _saved = true)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String value, List<String> options, ValueChanged<String> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: DropdownButton<String>(value: value, isExpanded: true, underline: const SizedBox(), items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.cairo(fontSize: 12)))).toList(), onChanged: (v) => onChanged(v!)),
    );
  }
}

const _rolesList = ['طالب', 'شؤون الطلاب', 'دكتور', 'إدارة'];

class _Permission {
  final String name;
  List<bool> values;
  _Permission(this.name, this.values);
}

/// شاشة إدارة الأدوار والصلاحيات (مصفوفة قابلة للتبديل).
class AdminRolesScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AdminRolesScreen({super.key, required this.onBack});

  @override
  State<AdminRolesScreen> createState() => _AdminRolesScreenState();
}

class _AdminRolesScreenState extends State<AdminRolesScreen> {
  bool _saved = false;
  late List<_Permission> _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = [
      _Permission('عرض الطلاب', [false, true, true, true]),
      _Permission('تعديل بيانات الطلاب', [false, true, false, true]),
      _Permission('إدارة الدرجات', [false, false, true, true]),
      _Permission('رفع المحاضرات', [false, false, true, true]),
      _Permission('إدارة طلبات القبول', [false, true, false, true]),
      _Permission('إدارة الطلبات', [false, true, false, true]),
      _Permission('المحادثات', [true, true, true, true]),
      _Permission('إدارة المستخدمين', [false, false, false, true]),
      _Permission('إعدادات النظام', [false, false, false, true]),
    ];
  }

  void _toggle(int row, int role) {
    if (role == 3) return;
    setState(() {
      _saved = false;
      _permissions[row].values[role] = !_permissions[row].values[role];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'الأدوار والصلاحيات', onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.blue.withValues(alpha: 0.15))),
                    child: Text('اضغط على أي خلية لتفعيل الصلاحية أو إيقافها. صلاحيات الإدارة كاملة وثابتة لحماية النظام.', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.blue, height: 1.7)),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          color: AppColors.blue,
                          child: Row(children: [
                            Expanded(flex: 16, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11), child: Text('الصلاحية', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)))),
                            ..._rolesList.map((r) => Expanded(flex: 8, child: Padding(padding: const EdgeInsets.symmetric(vertical: 11), child: Text(r, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white))))),
                          ]),
                        ),
                        ...List.generate(_permissions.length, (row) {
                          final p = _permissions[row];
                          return Container(
                            decoration: BoxDecoration(border: Border(bottom: row < _permissions.length - 1 ? const BorderSide(color: AppColors.border) : BorderSide.none)),
                            child: Row(
                              children: [
                                Expanded(flex: 16, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), child: Text(p.name, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.text)))),
                                ...List.generate(4, (role) {
                                  final enabled = p.values[role];
                                  return Expanded(
                                    flex: 8,
                                    child: Center(
                                      child: InkWell(
                                        onTap: () => _toggle(row, role),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: BoxDecoration(color: enabled ? AppColors.successLight : AppColors.bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: enabled ? AppColors.success : AppColors.border)),
                                          alignment: Alignment.center,
                                          child: enabled ? const AppIcon('check', size: 13, strokeWidth: 2.5, color: AppColors.success) : null,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(label: _saved ? 'تم حفظ الصلاحيات' : 'حفظ التغييرات', color: _saved ? AppColors.success : AppColors.blue, onPressed: () => setState(() => _saved = true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// إدارة المقررات على مستوى النظام.
class AdminCoursesScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AdminCoursesScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'إدارة المقررات', subtitle: '312 مقرر'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(children: const [
                    Expanded(child: DashStat(label: 'مقرر نشط', value: '298', icon: 'book', color: AppColors.blue, bg: AppColors.blueLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'قسم', value: '12', icon: 'grid4', color: AppColors.success, bg: AppColors.successLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'مسجل', value: '4.8K', icon: 'users', color: AppColors.warning, bg: AppColors.warningLight)),
                  ]),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(docCourses.length, (i) {
                        final c = docCourses[i];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const AppIcon('book', size: 18, color: AppColors.blue)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('${c.code} · ${c.students} طالباً', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                const AppIcon('editPen', size: 14, strokeWidth: 1.8, color: AppColors.textMuted),
                              ]),
                            ),
                            if (i < docCourses.length - 1) const Divider(height: 1, color: AppColors.border, indent: 66),
                          ],
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

class _Dept {
  final String name, head;
  final int courses, students;
  const _Dept(this.name, this.head, this.courses, this.students);
}

const _depts = [
  _Dept('علوم الحاسب وتقنية المعلومات', 'أ.د. منصور الغامدي', 48, 620),
  _Dept('هندسة الحاسب', 'أ.د. خالد العتيبي', 42, 580),
  _Dept('نظم المعلومات', 'أ.د. نورة السلمي', 35, 410),
  _Dept('تقنية المعلومات', 'أ.د. سعد الدوسري', 38, 445),
];

/// قائمة الأقسام الأكاديمية وإحصاءاتها.
class AdminDepartmentsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AdminDepartmentsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'الأقسام الأكاديمية', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: _depts.map((d) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 6),
                        Text('رئيس القسم: ${d.head}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(8)), child: Text('${d.courses} مقرر', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.blue))),
                          const SizedBox(width: 12),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(8)), child: Text('${d.students} طالب', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success))),
                        ]),
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
