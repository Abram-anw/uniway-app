import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';

/// المساعد الذكي: محادثة نصية بسيطة مع ردود تلقائية واقتراحات أسئلة.
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<ChatMsg> _messages = List.of(assistantInitialMessages);
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  void _send([String? text]) {
    final q = (text ?? _inputCtrl.text).trim();
    if (q.isEmpty) return;
    setState(() {
      _messages.add(ChatMsg(role: 'user', text: q));
      _inputCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMsg(role: 'bot', text: 'شكراً على سؤالك. بخصوص "$q"، يمكنني مساعدتك في ذلك. هل تريد أن أوجهك لإجراء محدد؟'));
      });
      Future.delayed(const Duration(milliseconds: 50), () {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppColors.blue,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const AppIcon('chat', size: 22, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المساعد الذكي', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                      Row(children: [
                        Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text('متاح الآن', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.75))),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  ..._messages.map((m) {
                    final isUser = m.role == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUser) ...[
                            Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: const AppIcon('chat', size: 15, color: Colors.white),
                            ),
                          ],
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
                              child: Text(
                                m.text,
                                style: GoogleFonts.cairo(fontSize: 13, height: 1.7, color: isUser ? Colors.white : AppColors.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  Text('اقتراحات', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: assistantSuggestions.map((s) {
                      return InkWell(
                        onTap: () => _send(s),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.blue.withValues(alpha: 0.3))),
                          child: Text(s, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.blue)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _send(),
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
                          hintText: 'اكتب سؤالك هنا...',
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
