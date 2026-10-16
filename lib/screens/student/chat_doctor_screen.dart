import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

class _DoctorEntry {
  final String name, courses;
  final int unread;
  const _DoctorEntry(this.name, this.courses, this.unread);
}

const _doctors = [
  _DoctorEntry('د. محمد الغامدي', 'هندسة البرمجيات', 2),
  _DoctorEntry('د. سارة القحطاني', 'شبكات الحاسب المتقدمة', 0),
  _DoctorEntry('د. خالد العتيبي', 'الذكاء الاصطناعي', 1),
  _DoctorEntry('د. أحمد الزهراني', 'مشروع التخرج 1', 0),
];

/// قائمة دكاترة المقررات المسجلة للتواصل معهم.
class StudentDoctorListScreen extends StatelessWidget {
  final ValueChanged<String> onSelect;
  final VoidCallback onBack;
  const StudentDoctorListScreen({super.key, required this.onSelect, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'المحادثة مع الدكتور', sub: 'دكاترة مقرراتك المسجلة', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: _doctors.map((d) {
                  return InkWell(
                    onTap: () => onSelect(d.name),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(d.name.replaceFirst('د. ', '')[0], style: GoogleFonts.cairo(fontWeight: FontWeight.w900, color: AppColors.blue)),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                                Text(d.courses, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          if (d.unread > 0)
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(left: 6),
                              decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Text('${d.unread}', style: GoogleFonts.cairo(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                          const AppIcon('chevronLeft', size: 14, strokeWidth: 2, color: AppColors.textMuted),
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

const Map<String, String> _courseContext = {
  'د. محمد الغامدي': 'هندسة البرمجيات',
  'د. سارة القحطاني': 'شبكات الحاسب المتقدمة',
  'د. خالد العتيبي': 'الذكاء الاصطناعي',
  'د. أحمد الزهراني': 'مشروع التخرج 1',
};

class _ChatLine {
  final String role, text;
  const _ChatLine(this.role, this.text);
}

/// محادثة مباشرة بين الطالب والدكتور.
class ChatDoctorScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String doctorName;
  const ChatDoctorScreen({super.key, required this.onBack, this.doctorName = 'د. سارة القحطاني'});

  @override
  State<ChatDoctorScreen> createState() => _ChatDoctorScreenState();
}

class _ChatDoctorScreenState extends State<ChatDoctorScreen> {
  late List<_ChatLine> _msgs;
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _msgs = [
      const _ChatLine('bot', 'مرحباً أحمد، كيف يمكنني مساعدتك؟'),
      const _ChatLine('user', 'دكتورة، أريد الاستفسار عن درجة الواجب الثالث.'),
      const _ChatLine('bot', 'تفضل، الواجب الثالث تم رصد درجته كاملة 9/10 لأن هناك ملاحظة طفيفة على قسم التحليل. يمكنني مراجعتها مرة أخرى إذا أردت.'),
    ];
  }

  void _send() {
    final q = _inputCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() {
      _msgs.add(_ChatLine('user', q));
      _inputCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _msgs.add(const _ChatLine('bot', 'شكراً على تواصلك. سأراجع الأمر وأرد عليك خلال 24 ساعة.')));
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseLabel = _courseContext[widget.doctorName] ?? 'محادثة أكاديمية';
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppColors.blue,
              child: Row(
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
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text('د', style: GoogleFonts.cairo(fontSize: 16, color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.doctorName, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text('$courseLabel · متاح الآن', style: GoogleFonts.cairo(fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: _msgs.map((m) {
                  final isUser = m.role == 'user';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isUser)
                          Container(
                            width: 28,
                            height: 28,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: Text('د', style: GoogleFonts.cairo(fontSize: 12, color: Colors.white)),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isUser ? AppColors.blue : AppColors.card,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(14),
                                topRight: const Radius.circular(14),
                                bottomLeft: Radius.circular(isUser ? 4 : 14),
                                bottomRight: Radius.circular(isUser ? 14 : 4),
                              ),
                              border: !isUser ? Border.all(color: AppColors.border) : null,
                            ),
                            child: Text(m.text, style: GoogleFonts.cairo(fontSize: 13, height: 1.7, color: isUser ? Colors.white : AppColors.text)),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    alignment: Alignment.center,
                    child: const AppIcon('file', size: 17, strokeWidth: 2, color: AppColors.textSub),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _send,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: const AppIcon('send', size: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        controller: _inputCtrl,
                        textAlign: TextAlign.right,
                        onSubmitted: (_) => _send(),
                        style: GoogleFonts.cairo(fontSize: 13, color: AppColors.text),
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك...',
                          hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
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
