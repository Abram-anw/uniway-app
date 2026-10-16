import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

/// محادثة الطالب مع شؤون الطلاب حول طلبه.
class ChatStudentAffairsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const ChatStudentAffairsScreen({super.key, required this.onBack});

  @override
  State<ChatStudentAffairsScreen> createState() => _ChatStudentAffairsScreenState();
}

class _ChatStudentAffairsScreenState extends State<ChatStudentAffairsScreen> {
  final _messages = <String>[
    'مرحبًا، أرفقت صورة ورقة الإجابة للمراجعة.',
    'تم استلام المرفق وربطه بالطلب REQ-1048. سنراجع التفاصيل مع القسم.',
  ];
  final _inputCtrl = TextEditingController();

  void _send() {
    final message = _inputCtrl.text.trim();
    if (message.isEmpty) return;
    setState(() {
      _messages.add(message);
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
            BackHeader(title: 'شئون الطلاب', sub: 'REQ-2025-1052 · متصل الآن', onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: List.generate(_messages.length, (index) {
                  final fromStudent = index.isOdd;
                  return Align(
                    alignment: fromStudent ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: fromStudent ? AppColors.blue : AppColors.white,
                        border: Border.all(color: fromStudent ? AppColors.blue : AppColors.border),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(14),
                          topRight: const Radius.circular(14),
                          bottomLeft: Radius.circular(fromStudent ? 4 : 14),
                          bottomRight: Radius.circular(fromStudent ? 14 : 4),
                        ),
                      ),
                      child: Text(
                        _messages[index],
                        style: GoogleFonts.cairo(fontSize: 12, height: 1.7, color: fromStudent ? Colors.white : AppColors.text),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _inputCtrl,
                        textAlign: TextAlign.right,
                        onSubmitted: (_) => _send(),
                        style: GoogleFonts.cairo(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالة...',
                          hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _send,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: const AppIcon('send', size: 18, color: Colors.white),
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

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }
}
