import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../models/student_request.dart';
import '../../widgets/common.dart';

Color _reqColor(String s) => s == 'pending' ? AppColors.warning : s == 'approved' ? AppColors.success : AppColors.danger;
Color _reqBg(String s) => s == 'pending' ? AppColors.warningLight : s == 'approved' ? AppColors.successLight : AppColors.dangerLight;
String _reqLabel(String s) => s == 'pending' ? 'معلق' : s == 'approved' ? 'موافق' : 'مرفوض';

/// عرض شامل لجميع طلبات النظام.
class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'جميع الطلبات', subtitle: '47 طلب معلق'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(children: const [
                    Expanded(child: DashStat(label: 'معلق', value: '47', icon: 'clock', color: AppColors.warning, bg: AppColors.warningLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'موافق اليوم', value: '12', icon: 'checkCircle', color: AppColors.success, bg: AppColors.successLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'مرفوض', value: '5', icon: 'xCircle', color: AppColors.danger, bg: AppColors.dangerLight)),
                  ]),
                  const SizedBox(height: 14),
                  ...mockRequests.map((r) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(r.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: _reqBg(r.status), borderRadius: BorderRadius.circular(20)), child: Text(_reqLabel(r.status), style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: _reqColor(r.status)))),
                          ]),
                          const SizedBox(height: 4),
                          Text('${r.type} · ${r.course} · ${r.date}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// إحصاءات ومدخل طلبات القبول حسب التخصص.
class AdminAdmissionScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const AdminAdmissionScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    const dist = [['علوم الحاسب', 68], ['الهندسة', 55], ['الأعمال', 42], ['العلوم', 17]];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'طلبات التقديم', subtitle: 'فصل 1446 / 2'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(children: const [
                    Expanded(child: DashStat(label: 'طلب كلي', value: '248', icon: 'file', color: AppColors.blue, bg: AppColors.blueLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'مقبول', value: '182', icon: 'checkCircle', color: AppColors.success, bg: AppColors.successLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'معلق', value: '41', icon: 'clock', color: AppColors.warning, bg: AppColors.warningLight)),
                  ]),
                  const SizedBox(height: 14),
                  PrimaryButton(label: 'عرض قائمة طلبات القبول', onPressed: () => onNav('sa-hs-requests')),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('توزيع القبول حسب التخصص', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 10),
                        ...dist.map((row) {
                          final dept = row[0] as String;
                          final count = row[1] as int;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(dept, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.text)),
                                  Text('$count', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blue)),
                                ]),
                                const SizedBox(height: 4),
                                ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: count / 68, minHeight: 6, backgroundColor: AppColors.bg, color: AppColors.blue)),
                              ],
                            ),
                          );
                        }),
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

/// إدارة حالة تسليم الدرجات لكل المقررات.
class AdminGradesScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AdminGradesScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final pending = docCourses.where((c) => !c.submitted).toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'إدارة الدرجات', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(children: const [
                    Expanded(child: DashStat(label: 'مقرر لم تُرفع درجاته', value: '14', icon: 'alert', color: AppColors.warning, bg: AppColors.warningLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'مقرر مكتمل', value: '298', icon: 'checkCircle', color: AppColors.success, bg: AppColors.successLight)),
                  ]),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('مقررات معلقة', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                            Text('14 مقرر', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                          ]),
                        ),
                        ...pending.map((c) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(children: [
                              Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const AppIcon('clock', size: 17, strokeWidth: 1.8, color: AppColors.warning)),
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
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.blueLight, foregroundColor: AppColors.blue, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                child: Text('تنبيه', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ]),
                          );
                        }),
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

/// إدارة طلبات المستندات الرسمية على مستوى النظام.
class AdminDocumentsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AdminDocumentsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    const docs = ['كشف الدرجات الرسمي', 'شهادة قيد', 'خطاب تعريفي', 'شهادة التخرج'];
    const counts = [8, 5, 12, 2];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'إدارة المستندات', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(children: const [
                    Expanded(child: DashStat(label: 'طلب اليوم', value: '23', icon: 'file', color: AppColors.blue, bg: AppColors.blueLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'معالجة', value: '18', icon: 'checkCircle', color: AppColors.success, bg: AppColors.successLight)),
                    SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'معلق', value: '5', icon: 'clock', color: AppColors.warning, bg: AppColors.warningLight)),
                  ]),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(docs.length, (i) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const AppIcon('file', size: 17, strokeWidth: 1.8, color: AppColors.blue)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(docs[i], style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('${counts[i]} طلب نشط', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                const AppIcon('chevronLeft', size: 14, strokeWidth: 2, color: AppColors.textMuted),
                              ]),
                            ),
                            if (i < docs.length - 1) const Divider(height: 1, color: AppColors.border, indent: 64),
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

class _Announcement {
  final String title, date, audience, status;
  const _Announcement(this.title, this.date, this.audience, this.status);
}

const _announcements = [
  _Announcement('بدء فترة التسجيل للفصل القادم', '5 يناير 2025', 'جميع الطلاب', 'published'),
  _Announcement('اجتماع عام للطلاب — الأحد القادم', '4 يناير 2025', 'كلية الحاسب', 'published'),
  _Announcement('تحديث جدول الاختبارات النهائية', '3 يناير 2025', 'المستوى 7', 'draft'),
];

/// إدارة الإعلانات الجامعية.
class AdminAnnouncementsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AdminAnnouncementsScreen({super.key, required this.onBack});

  @override
  State<AdminAnnouncementsScreen> createState() => _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  bool _showNew = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(
                  title: 'الإعلانات',
                  onBack: widget.onBack,
                  trailing: InkWell(
                    onTap: () => setState(() => _showNew = true),
                    child: Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: const AppIcon('plusCircle', size: 18, color: AppColors.blue)),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: _announcements.map((a) {
                      final pub = a.status == 'published';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(child: Text(a.title, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text))),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), decoration: BoxDecoration(color: pub ? AppColors.successLight : AppColors.warningLight, borderRadius: BorderRadius.circular(20)), child: Text(pub ? 'منشور' : 'مسودة', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: pub ? AppColors.success : AppColors.warning))),
                            ]),
                            const SizedBox(height: 6),
                            Text('${a.date} · ${a.audience}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            if (_showNew)
              Container(
                color: Colors.black.withValues(alpha: 0.45),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إعلان جديد', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                      const SizedBox(height: 14),
                      const LabeledField(label: 'عنوان الإعلان', hint: 'اكتب عنوان الإعلان'),
                      const LabeledField(label: 'النص', hint: 'تفاصيل الإعلان...', maxLines: 3),
                      PrimaryButton(label: 'نشر الإعلان', onPressed: () => setState(() => _showNew = false)),
                      const SizedBox(height: 8),
                      SecondaryButton(label: 'إلغاء', onPressed: () => setState(() => _showNew = false)),
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

class _KBEntry {
  final String q, updated;
  final int views;
  const _KBEntry(this.q, this.updated, this.views);
}

const _kbEntries = [
  _KBEntry('كيف أتظلم على درجة الاختبار؟', '1 يناير 2025', 342),
  _KBEntry('ما هي خطوات تسجيل المقررات؟', '28 ديسمبر 2024', 589),
  _KBEntry('كيف أطلب كشف الدرجات الرسمي؟', '25 ديسمبر 2024', 271),
  _KBEntry('ما هي متطلبات التخرج؟', '20 ديسمبر 2024', 445),
];

/// إدارة قاعدة المعرفة التي تغذي المساعد الذكي.
class AdminAIKBScreen extends StatelessWidget {
  final VoidCallback onBack;
  const AdminAIKBScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'قاعدة معرفة المساعد', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12)),
                    child: Text('تُغذّي هذه الأسئلة والإجابات المساعد الذكي. قم بتحديثها بانتظام لضمان دقة الردود.', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.blue, height: 1.7)),
                  ),
                  ..._kbEntries.map((e) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(e.q, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text))),
                            const AppIcon('editPen', size: 14, strokeWidth: 1.8, color: AppColors.textMuted),
                          ]),
                          const SizedBox(height: 6),
                          Row(children: [
                            Text('آخر تحديث: ${e.updated}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(width: 10),
                            Text('${e.views} مشاهدة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.blue)),
                          ]),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  PrimaryButton(label: 'إضافة سؤال جديد', icon: 'plusCircle', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// إعدادات النظام العامة (الفصل الدراسي، البريد، النسخ الاحتياطي...).
class AdminSettingsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const AdminSettingsScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    const settings = [
      ('calendar', AppColors.blue, AppColors.blueLight, 'الفصل الدراسي الحالي', 'الفصل الثاني 1446'),
      ('clock', AppColors.warning, AppColors.warningLight, 'آخر يوم للتسجيل', '14 يناير 2025'),
      ('mail', AppColors.success, AppColors.successLight, 'نطاق البريد الجامعي', '@student.edu.sa'),
      ('shield', AppColors.purple, AppColors.purpleLight, 'المصادقة الثنائية', 'مفعّلة'),
      ('database', AppColors.blue, AppColors.blueLight, 'نسخ احتياطي تلقائي', 'يومياً - 2:00 ص'),
      ('settings', AppColors.textSub, AppColors.border, 'إصدار النظام', 'v2.4.1'),
    ];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'إعدادات النظام'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(settings.length, (i) {
                        final s = settings[i];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(width: 36, height: 36, decoration: BoxDecoration(color: s.$3, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: AppIcon(s.$1, size: 17, strokeWidth: 1.8, color: s.$2)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s.$4, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                                      Text(s.$5, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                    ],
                                  ),
                                ),
                                const AppIcon('editPen', size: 14, strokeWidth: 1.8, color: AppColors.textMuted),
                              ]),
                            ),
                            if (i < settings.length - 1) const Divider(height: 1, color: AppColors.border, indent: 64),
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

/// إدارة أنواع طلبات شؤون الطلاب ومتطلبات كل نوع (نسخة مبسّطة للعرض والتحديث).
class AdminRequestRequirementsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const AdminRequestRequirementsScreen({super.key, required this.onBack});

  @override
  State<AdminRequestRequirementsScreen> createState() => _AdminRequestRequirementsScreenState();
}

class _AdminRequestRequirementsScreenState extends State<AdminRequestRequirementsScreen> {
  late String _selectedId;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _selectedId = studentRequestTypes.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final selected = studentRequestTypes.firstWhere((t) => t.id == _selectedId);
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'إدارة متطلبات الطلبات', sub: 'أنواع طلبات شؤون الطلاب', onBack: widget.onBack),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: studentRequestTypes.map((t) {
                    final active = t.id == _selectedId;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: () => setState(() {
                          _selectedId = t.id;
                          _saved = false;
                        }),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: active ? AppColors.blue : AppColors.bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? AppColors.blue : AppColors.border)),
                          alignment: Alignment.center,
                          child: Text(t.name, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textSub)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selected.name, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 4),
                        Text(selected.description, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted, height: 1.6)),
                      ],
                    ),
                  ),
                  Text('المتطلبات (${selected.requirements.length})', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                  const SizedBox(height: 10),
                  ...selected.requirements.map((r) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.border)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name, style: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.text)),
                                Text(r.hint, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(color: r.mandatory ? AppColors.dangerLight : AppColors.bg, borderRadius: BorderRadius.circular(20)),
                            child: Text(r.mandatory ? 'إلزامي' : 'اختياري', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: r.mandatory ? AppColors.danger : AppColors.textMuted)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  PrimaryButton(label: _saved ? 'تم الحفظ' : 'حفظ التغييرات', color: _saved ? AppColors.success : AppColors.blue, onPressed: () => setState(() => _saved = true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
