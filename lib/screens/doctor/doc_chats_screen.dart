import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common.dart';

class _DocChat {
  final String name, last, time;
  final int unread;
  const _DocChat(this.name, this.last, this.time, this.unread);
}

const _docChats = [
  _DocChat('أحمد العمري', 'أستاذة، هل يمكنني الاستفسار عن درجة الواجب؟', 'منذ ساعة', 1),
  _DocChat('سارة الزهراني', 'شكراً للتوضيح أستاذة', 'أمس', 0),
  _DocChat('خالد المطيري', 'متى سيُعلن عن جدول الاختبار؟', 'أمس', 2),
  _DocChat('نورة السبيعي', 'تم استلام الملف، شكراً', 'الأسبوع الماضي', 0),
];

/// قائمة محادثات الدكتور مع طلابه.
class DocChatsScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const DocChatsScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'رسائل الطلاب'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_docChats.length, (i) {
                        final c = _docChats[i];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => onNav('chat-doctor'),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Text(c.name[0], style: GoogleFonts.cairo(fontSize: 15, color: AppColors.blue, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(c.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                              Text(c.time, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(c.last, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                                        ],
                                      ),
                                    ),
                                    if (c.unread > 0)
                                      Container(
                                        width: 18,
                                        height: 18,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: Text('${c.unread}', style: GoogleFonts.cairo(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (i < _docChats.length - 1) const Divider(height: 1, color: AppColors.border, indent: 68),
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
