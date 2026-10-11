import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

Color _reqStatusColor(String s) => s == 'pending' ? AppColors.warning : s == 'approved' ? AppColors.success : AppColors.danger;
Color _reqStatusBg(String s) => s == 'pending' ? AppColors.warningLight : s == 'approved' ? AppColors.successLight : AppColors.dangerLight;
String _reqStatusLabel(String s) => s == 'pending' ? 'معلق' : s == 'approved' ? 'موافق' : 'مرفوض';

/// الشاشة الرئيسية لشؤون الطلاب: إحصائيات، آخر الطلبات، وإجراءات سريعة.
class SADashboardScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const SADashboardScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    final quick = [
      ('grad', AppColors.blue, AppColors.blueLight, 'طلاب الثانوية', 'sa-hs-requests'),
      ('military', AppColors.purple, AppColors.purpleLight, 'التربية العسكرية', 'sa-military'),
      ('search', AppColors.success, AppColors.successLight, 'البحث عن طالب', 'sa-search'),
      ('chat', AppColors.warning, AppColors.warningLight, 'محادثات الطلاب', 'sa-chats'),
    ];
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
                            Text('شؤون الطلاب', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ),
                      Stack(clipBehavior: Clip.none, children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: const AppIcon('bell', size: 20, color: Colors.white),
                        ),
                        Positioned(top: -2, right: -2, child: Container(width: 9, height: 9, decoration: BoxDecoration(color: AppColors.danger, shape: BoxShape.circle, border: Border.all(color: AppColors.blue, width: 2)))),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _stat('12', 'طلب معلق', Colors.white)),
                    const SizedBox(width: 8),
                    Expanded(child: _stat('3', 'عاجل', const Color(0xFFFCA5A5))),
                    const SizedBox(width: 8),
                    Expanded(child: _stat('47', 'هذا الأسبوع', Colors.white)),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('آخر الطلبات', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                      GestureDetector(onTap: () => onNav('sa-requests'), child: Text('عرض الكل', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.blue))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...mockRequests.take(3).map((r) {
                    return InkWell(
                      onTap: () => onNav('sa-request-detail'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: r.urgent ? AppColors.danger : AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(r.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(color: _reqStatusBg(r.status), borderRadius: BorderRadius.circular(20)),
                                child: Text(_reqStatusLabel(r.status), style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: _reqStatusColor(r.status))),
                              ),
                            ]),
                            const SizedBox(height: 4),
                            Text('${r.type} · ${r.course}', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                            Text(r.date, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: quick.map((q) {
                      return InkWell(
                        onTap: () => onNav(q.$5),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(color: q.$3, borderRadius: BorderRadius.circular(12)),
                                alignment: Alignment.center,
                                child: AppIcon(q.$1, size: 20, color: q.$2),
                              ),
                              const SizedBox(height: 8),
                              Text(q.$4, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
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

  Widget _stat(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: Column(children: [
        Text(val, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
      ]),
    );
  }
}

/// قائمة كل طلبات الطلاب مع فلاتر الحالة.
class SARequestsScreen extends StatefulWidget {
  final ValueChanged<String> onNav;
  const SARequestsScreen({super.key, required this.onNav});

  @override
  State<SARequestsScreen> createState() => _SARequestsScreenState();
}

class _SARequestsScreenState extends State<SARequestsScreen> {
  String _filter = 'الكل';
  static const _filters = ['الكل', 'معلق', 'موافق', 'مرفوض'];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'الكل'
        ? mockRequests
        : mockRequests.where((r) => (_filter == 'معلق' && r.status == 'pending') || (_filter == 'موافق' && r.status == 'approved') || (_filter == 'مرفوض' && r.status == 'rejected')).toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'طلبات الطلاب'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: SizedBox(
                height: 32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _filters.map((f) {
                    final active = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: () => setState(() => _filter = f),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(color: active ? AppColors.blue : AppColors.bg, borderRadius: BorderRadius.circular(20), border: Border.all(color: active ? AppColors.blue : AppColors.border)),
                          alignment: Alignment.center,
                          child: Text(f, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textSub)),
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
                children: filtered.map((r) {
                  return InkWell(
                    onTap: () => widget.onNav('sa-request-detail'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: r.urgent ? AppColors.danger.withValues(alpha: 0.35) : AppColors.border)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(r.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                  if (r.urgent) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(20)),
                                      child: Text('عاجل', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.danger)),
                                    ),
                                  ],
                                ]),
                                const SizedBox(height: 2),
                                Text('${r.type} · ${r.course}', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
                                Text(r.date, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: _reqStatusBg(r.status), borderRadius: BorderRadius.circular(20)),
                            child: Text(_reqStatusLabel(r.status), style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: _reqStatusColor(r.status))),
                          ),
                        ],
                      ),
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

class _ReqDocument {
  String name, file, status, reason;
  _ReqDocument(this.name, this.file, this.status, this.reason);
}

/// تفاصيل طلب طالب: مراجعة كل مستند على حدة (قبول/رفض بسبب).
class SARequestDetailScreen extends StatefulWidget {
  final ValueChanged<String> onNav;
  final VoidCallback onBack;
  const SARequestDetailScreen({super.key, required this.onNav, required this.onBack});

  @override
  State<SARequestDetailScreen> createState() => _SARequestDetailScreenState();
}

class _SARequestDetailScreenState extends State<SARequestDetailScreen> {
  late List<_ReqDocument> _docs;
  int? _rejecting;
  final _reasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _docs = [
      _ReqDocument('صورة بطاقة الرقم القومي', 'national-id.pdf', 'pending', ''),
      _ReqDocument('إيصال سداد مصروفات الفصل الحالي', 'payment-receipt.jpg', 'pending', ''),
      _ReqDocument('جهة تقديم الإفادة', 'وزارة الاتصالات', 'accepted', ''),
    ];
  }

  String _label(String s) => s == 'accepted' ? 'مقبول' : s == 'rejected' ? 'مرفوض' : 'قيد المراجعة';
  Color _color(String s) => s == 'accepted' ? AppColors.success : s == 'rejected' ? AppColors.danger : AppColors.warning;
  Color _bg(String s) => s == 'accepted' ? AppColors.successLight : s == 'rejected' ? AppColors.dangerLight : AppColors.warningLight;

  @override
  Widget build(BuildContext context) {
    const info = [
      ['نوع الطلب', 'إفادة قيد'],
      ['رقم الطلب', 'REQ-2025-1052'],
      ['تاريخ التقديم', '8 يناير 2025'],
      ['جهة تقديم الإفادة', 'وزارة الاتصالات'],
    ];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: 'تفاصيل الطلب', sub: 'REQ-2025-1052', onBack: widget.onBack),
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
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('أحمد محمد العمري', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                                Text('4410112345 · المستوى السابع', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                              ]),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                                child: Text('قيد المراجعة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning)),
                              ),
                            ]),
                            const SizedBox(height: 12),
                            ...info.map((pair) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(children: [
                                    SizedBox(width: 90, child: Text('${pair[0]}:', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted))),
                                    Expanded(child: Text(pair[1], style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text))),
                                  ]),
                                )),
                          ],
                        ),
                      ),
                      Text('مراجعة المستندات والبيانات', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                      const SizedBox(height: 8),
                      ...List.generate(_docs.length, (i) {
                        final d = _docs[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(13), border: Border.all(color: d.status == 'rejected' ? AppColors.danger.withValues(alpha: 0.35) : AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(child: Text(d.name, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.text))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                                  decoration: BoxDecoration(color: _bg(d.status), borderRadius: BorderRadius.circular(20)),
                                  child: Text(_label(d.status), style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: _color(d.status))),
                                ),
                              ]),
                              const SizedBox(height: 3),
                              Text(d.file, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                              if (d.reason.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                                  decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(8)),
                                  child: Text('سبب الرفض: ${d.reason}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger)),
                                ),
                              const SizedBox(height: 8),
                              Row(children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(() {
                                      d.status = 'accepted';
                                      d.reason = '';
                                    }),
                                    style: OutlinedButton.styleFrom(backgroundColor: d.status == 'accepted' ? AppColors.success : Colors.white, foregroundColor: d.status == 'accepted' ? Colors.white : AppColors.success, side: const BorderSide(color: AppColors.success), padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                    child: Text('قبول المستند', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      _reasonCtrl.text = d.reason;
                                      setState(() => _rejecting = i);
                                    },
                                    style: OutlinedButton.styleFrom(backgroundColor: d.status == 'rejected' ? AppColors.danger : Colors.white, foregroundColor: d.status == 'rejected' ? Colors.white : AppColors.danger, side: const BorderSide(color: AppColors.danger), padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                                    child: Text('رفض المستند', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 10),
                      SecondaryButton(label: 'التواصل مع الطالب', onPressed: () => widget.onNav('sa-chat')),
                    ],
                  ),
                ),
              ],
            ),
            if (_rejecting != null)
              Container(
                color: Colors.black.withValues(alpha: 0.55),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سبب رفض المستند', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                      const SizedBox(height: 6),
                      Text('يجب كتابة سبب واضح ليتمكن الطالب من تصحيح المستند.', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _reasonCtrl,
                        maxLines: 3,
                        textAlign: TextAlign.right,
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.cairo(fontSize: 12),
                        decoration: InputDecoration(hintText: 'اكتب سبب الرفض...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _reasonCtrl.text.trim().isEmpty
                                ? null
                                : () => setState(() {
                                      _docs[_rejecting!].status = 'rejected';
                                      _docs[_rejecting!].reason = _reasonCtrl.text.trim();
                                      _rejecting = null;
                                    }),
                            style: ElevatedButton.styleFrom(backgroundColor: _reasonCtrl.text.trim().isEmpty ? AppColors.border : AppColors.danger, foregroundColor: _reasonCtrl.text.trim().isEmpty ? AppColors.textMuted : Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: Text('تأكيد الرفض', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _rejecting = null),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSub, side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: Text('إلغاء', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ]),
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

class _HSApp {
  final String name, id, nationalId, status;
  final Color color, bg;
  const _HSApp(this.name, this.id, this.nationalId, this.status, this.color, this.bg);
}

const _hsApps = [
  _HSApp('محمد أحمد السالم', 'APP-2026-00123', '30101011234567', 'قيد المراجعة', AppColors.blue, AppColors.blueLight),
  _HSApp('فاطمة خالد القحطاني', 'APP-2026-00124', '30202021234568', 'يحتاج معلومات إضافية', AppColors.warning, AppColors.warningLight),
  _HSApp('عبدالله ناصر الشمري', 'APP-2026-00125', '30003031234569', 'مقبول', AppColors.success, AppColors.successLight),
  _HSApp('ريم محمد المطيري', 'APP-2026-00126', '30304041234560', 'مرفوض', AppColors.danger, AppColors.dangerLight),
];

/// قائمة طلبات التحاق طلاب الثانوية.
class SAHSRequestsScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const SAHSRequestsScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            SimpleAppBar(title: 'طلبات طلاب الثانوية', subtitle: '${_hsApps.length} طلبات التحاق'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: _hsApps.map((app) {
                  return InkWell(
                    onTap: () => onNav('sa-hs-detail'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                Text('${app.id} · ${app.nationalId}', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(color: app.bg, borderRadius: BorderRadius.circular(20)),
                            child: Text(app.status, style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: app.color)),
                          ),
                        ],
                      ),
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

/// تفاصيل طلب التحاق طالب ثانوية: قبول، رفض، أو طلب معلومات إضافية.
class SAHSDetailScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SAHSDetailScreen({super.key, required this.onBack});

  @override
  State<SAHSDetailScreen> createState() => _SAHSDetailScreenState();
}

class _SAHSDetailScreenState extends State<SAHSDetailScreen> {
  String _status = 'قيد المراجعة';
  String? _action;
  final _reasonCtrl = TextEditingController();
  bool _zoom = false;

  void _confirmAction() {
    setState(() {
      if (_action == 'approve') _status = 'مقبول';
      if (_action == 'reject') _status = 'مرفوض';
      if (_action == 'info') _status = 'يحتاج معلومات إضافية';
      _action = null;
    });
  }

  Color get _statusColor => _status == 'مقبول' ? AppColors.success : _status == 'مرفوض' ? AppColors.danger : _status == 'يحتاج معلومات إضافية' ? AppColors.warning : AppColors.blue;
  Color get _statusBg => _status == 'مقبول' ? AppColors.successLight : _status == 'مرفوض' ? AppColors.dangerLight : _status == 'يحتاج معلومات إضافية' ? AppColors.warningLight : AppColors.blueLight;

  @override
  Widget build(BuildContext context) {
    const info = [
      ['الاسم بالكامل', 'محمد أحمد السالم'],
      ['الرقم القومي', '30101011234567'],
      ['رقم الطلب', 'APP-2026-00123'],
    ];
    final needsReason = _action == 'reject' || _action == 'info';
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: 'تفاصيل طلب الالتحاق', sub: 'APP-2026-00123', onBack: widget.onBack),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('محمد أحمد السالم', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: _statusBg, borderRadius: BorderRadius.circular(20)), child: Text(_status, style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w700, color: _statusColor))),
                            ]),
                            ...info.map((pair) => Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(pair[0], style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    Text(pair[1], style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.text)),
                                  ]),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('بطاقة الترشيح', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => setState(() => _zoom = true),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.blue.withValues(alpha: 0.2))),
                                alignment: Alignment.center,
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  const AppIcon('file', size: 34, strokeWidth: 1.6, color: AppColors.blue),
                                  const SizedBox(height: 8),
                                  Text('nomination-card.pdf', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.blue, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 3),
                                  Text('اضغط للعرض والتكبير', style: GoogleFonts.cairo(fontSize: 9, color: AppColors.textMuted)),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_status == 'قيد المراجعة')
                        Column(children: [
                          PrimaryButton(label: 'قبول الطلب', color: AppColors.success, onPressed: () => setState(() => _action = 'approve')),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  _reasonCtrl.clear();
                                  _action = 'info';
                                }),
                                style: OutlinedButton.styleFrom(foregroundColor: AppColors.warning, side: const BorderSide(color: AppColors.warning), padding: const EdgeInsets.symmetric(vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                                child: Text('طلب معلومات إضافية', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  _reasonCtrl.clear();
                                  _action = 'reject';
                                }),
                                style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger), padding: const EdgeInsets.symmetric(vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                                child: Text('رفض الطلب', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ]),
                        ])
                      else
                        Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(color: _statusBg, borderRadius: BorderRadius.circular(13)),
                          alignment: Alignment.center,
                          child: Text('تم تحديث الحالة إلى: $_status', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w800, color: _statusColor)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (_action == 'approve')
              _ConfirmOverlay(
                title: 'هل أنت متأكد من قبول الطلب؟',
                body: 'سيتم إشعار المتقدم بالتوجه إلى الجامعة لاستكمال الإجراءات.',
                confirmLabel: 'قبول الطلب',
                onCancel: () => setState(() => _action = null),
                onConfirm: _confirmAction,
              ),
            if (needsReason)
              Container(
                color: Colors.black.withValues(alpha: 0.55),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_action == 'reject' ? 'سبب رفض الطلب' : 'المعلومات المطلوبة', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
                      const SizedBox(height: 6),
                      Text('يجب كتابة سبب واضح ليظهر للمتقدم.', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _reasonCtrl,
                        maxLines: 3,
                        textAlign: TextAlign.right,
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.cairo(fontSize: 12),
                        decoration: InputDecoration(hintText: 'اكتب السبب...', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
                      ),
                      const SizedBox(height: 11),
                      Row(children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _reasonCtrl.text.trim().isEmpty ? null : _confirmAction,
                            style: ElevatedButton.styleFrom(backgroundColor: _reasonCtrl.text.trim().isEmpty ? AppColors.border : (_action == 'reject' ? AppColors.danger : AppColors.warning), foregroundColor: _reasonCtrl.text.trim().isEmpty ? AppColors.textMuted : Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: Text('تأكيد', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _action = null),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSub, side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                            child: Text('إلغاء', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            if (_zoom)
              GestureDetector(
                onTap: () => setState(() => _zoom = false),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.9),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
                    alignment: Alignment.center,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const AppIcon('file', size: 64, strokeWidth: 1.5, color: AppColors.blue),
                      const SizedBox(height: 12),
                      Text('معاينة بطاقة الترشيح', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                      const SizedBox(height: 5),
                      Text('اضغط في أي مكان للإغلاق', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                    ]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MilitaryStudent {
  final String name, id, status, grade;
  const _MilitaryStudent(this.name, this.id, this.status, this.grade);
}

const _militaryStudents = [
  _MilitaryStudent('أحمد العمري', '4410112345', 'registered', 'B+'),
  _MilitaryStudent('خالد المطيري', '4410112347', 'registered', 'A'),
  _MilitaryStudent('عمر الشهري', '4410112349', 'excused', '—'),
  _MilitaryStudent('محمد السالم', '4410112351', 'pending', '—'),
];

/// إدارة قوائم طلاب مادة التربية العسكرية.
class SAMilitaryScreen extends StatelessWidget {
  final VoidCallback onBack;
  const SAMilitaryScreen({super.key, required this.onBack});

  String _label(String s) => s == 'registered' ? 'مسجل' : s == 'excused' ? 'معفو' : 'معلق';
  Color _color(String s) => s == 'registered' ? AppColors.success : s == 'excused' ? AppColors.blue : AppColors.warning;
  Color _bg(String s) => s == 'registered' ? AppColors.successLight : s == 'excused' ? AppColors.blueLight : AppColors.warningLight;

  @override
  Widget build(BuildContext context) {
    final registeredCount = _militaryStudents.where((s) => s.status == 'registered').length;
    final excusedCount = _militaryStudents.where((s) => s.status == 'excused').length;
    final pendingCount = _militaryStudents.where((s) => s.status == 'pending').length;
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'التربية العسكرية', subtitle: 'إدارة قوائم الطلاب'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Row(children: [
                    Expanded(child: DashStat(label: 'مسجل', value: '$registeredCount', icon: 'checkCircle', color: AppColors.success, bg: AppColors.successLight)),
                    const SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'معفو', value: '$excusedCount', icon: 'shield', color: AppColors.blue, bg: AppColors.blueLight)),
                    const SizedBox(width: 8),
                    Expanded(child: DashStat(label: 'معلق', value: '$pendingCount', icon: 'clock', color: AppColors.warning, bg: AppColors.warningLight)),
                  ]),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_militaryStudents.length, (i) {
                        final s = _militaryStudents[i];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(width: 38, height: 38, decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle), alignment: Alignment.center, child: Text(s.name[0], style: GoogleFonts.cairo(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700))),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('${s.id} · الدرجة: ${s.grade}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: _bg(s.status), borderRadius: BorderRadius.circular(20)), child: Text(_label(s.status), style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: _color(s.status)))),
                              ]),
                            ),
                            if (i < _militaryStudents.length - 1) const Divider(height: 1, color: AppColors.border, indent: 66),
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

class _SAStudent {
  final String name, id, dept, level;
  const _SAStudent(this.name, this.id, this.dept, this.level);
}

const _saStudents = [
  _SAStudent('أحمد محمد العمري', '4410112345', 'علوم الحاسب', 'السابع'),
  _SAStudent('سارة خالد الزهراني', '4410112346', 'نظم المعلومات', 'السادس'),
  _SAStudent('خالد ناصر المطيري', '4410112347', 'تقنية المعلومات', 'الخامس'),
];

/// بحث شؤون الطلاب عن طالب بالاسم أو الرقم الجامعي.
class SAStudentSearchScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SAStudentSearchScreen({super.key, required this.onBack});

  @override
  State<SAStudentSearchScreen> createState() => _SAStudentSearchScreenState();
}

class _SAStudentSearchScreenState extends State<SAStudentSearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final shown = _saStudents.where((s) => _query.isEmpty || s.name.contains(_query) || s.id.contains(_query)).toList();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'البحث عن طالب', onBack: widget.onBack),
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.white,
              child: Container(
                decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(children: [
                  const AppIcon('search', size: 17, strokeWidth: 2, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontSize: 13),
                      decoration: InputDecoration(hintText: 'الاسم أو الرقم الجامعي...', hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 11)),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              child: shown.isEmpty
                  ? const EmptyState(icon: 'search', text: 'لا توجد نتائج مطابقة')
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: shown.map((s) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Row(children: [
                            Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle), alignment: Alignment.center, child: Text(s.name[0], style: GoogleFonts.cairo(color: AppColors.blue, fontWeight: FontWeight.w800))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                  Text('${s.id} · ${s.dept} · المستوى ${s.level}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ),
                            const AppIcon('chevronLeft', size: 14, strokeWidth: 2, color: AppColors.textMuted),
                          ]),
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

class _SAChatPreview {
  final String name, request, last;
  final int unread;
  const _SAChatPreview(this.name, this.request, this.last, this.unread);
}

const _saChats = [
  _SAChatPreview('أحمد العمري', 'REQ-1048 · تظلم درجة', 'أرفقت صورة ورقة الإجابة', 2),
  _SAChatPreview('نورة السبيعي', 'DOC-9921 · كشف درجات', 'شكرًا، تم استلام الوثيقة', 0),
  _SAChatPreview('خالد المطيري', 'REG-7734 · انسحاب', 'ما المستند المطلوب؟', 1),
];

/// قائمة محادثات شؤون الطلاب المرتبطة بالطلبات.
class SAChatsScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const SAChatsScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'محادثات الطلاب', subtitle: 'مرتبطة بالطلبات الإدارية'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_saChats.length, (i) {
                        final c = _saChats[i];
                        return RowItem(
                          icon: 'chat',
                          color: AppColors.blue,
                          bg: AppColors.blueLight,
                          title: c.name,
                          sub: '${c.request} · ${c.last}',
                          badge: c.unread > 0 ? '${c.unread}' : null,
                          onTap: () => onNav('sa-chat'),
                          divider: i < _saChats.length - 1,
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

/// محادثة فردية بين شؤون الطلاب وطالب حول طلب محدد.
class SAChatScreen extends StatefulWidget {
  final VoidCallback onBack;
  final bool isStudent;
  const SAChatScreen({super.key, required this.onBack, this.isStudent = false});

  @override
  State<SAChatScreen> createState() => _SAChatScreenState();
}

class _SAChatScreenState extends State<SAChatScreen> {
  final List<String> _messages = ['مرحبًا، أرفقت صورة ورقة الإجابة للمراجعة.', 'تم استلام المرفق وربطه بالطلب REQ-1048. سنراجع التفاصيل مع القسم.'];
  final _inputCtrl = TextEditingController();

  void _send() {
    final v = _inputCtrl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      _messages.add(v);
      _inputCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: widget.isStudent ? 'شئون الطلاب' : 'أحمد العمري', sub: 'REQ-2025-1052 · متصل الآن', onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(_messages.length, (i) {
                  final fromMe = i % 2 == 1;
                  return Align(
                    alignment: fromMe ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: fromMe ? AppColors.blue : AppColors.white,
                        border: Border.all(color: fromMe ? AppColors.blue : AppColors.border),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(fromMe ? 4 : 14),
                          bottomRight: Radius.circular(fromMe ? 14 : 4),
                        ),
                      ),
                      child: Text(_messages[i], style: GoogleFonts.cairo(fontSize: 12, height: 1.7, color: fromMe ? Colors.white : AppColors.text)),
                    ),
                  );
                }),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _inputCtrl,
                      textAlign: TextAlign.right,
                      onSubmitted: (_) => _send(),
                      style: GoogleFonts.cairo(fontSize: 13),
                      decoration: InputDecoration(hintText: 'اكتب رسالة...', hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _send,
                  child: Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const AppIcon('send', size: 18, color: Colors.white)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmOverlay extends StatelessWidget {
  final String title, body, confirmLabel;
  final VoidCallback onCancel, onConfirm;
  const _ConfirmOverlay({required this.title, required this.body, required this.confirmLabel, required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.45),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.text)),
            const SizedBox(height: 8),
            Text(body, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSub, height: 1.6)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text(confirmLabel, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.text, side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text('إلغاء', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
