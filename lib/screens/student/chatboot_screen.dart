import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';

class ChatbootScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ChatbootScreen({super.key, required this.onBack});

  @override
  State<ChatbootScreen> createState() => _ChatbootScreenState();
}

class _ChatbootScreenState extends State<ChatbootScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isUser: false,
      text: 'أهلاً بك، أنا UNIWAY Assistant 👋\nكيف يمكنني مساعدتك اليوم؟',
    ),
  ];

  static const _suggestions = [
    'كيف أسجل مادة إضافية؟',
    'ما هي مستندات التأجيل؟',
    'كيف أقدم اعتراضاً على درجة؟',
    'متى يبدأ التسجيل للفصل القادم؟',
    'كيف أطلب شهادة التخرج؟',
    'أين أجد جدول المحاضرات؟',
  ];

  static const _replies = {
    'كيف أسجل مادة إضافية؟':
        'يمكنك تسجيل مادة إضافية من قسم المقررات، ثم اختيار تسجيل مقرر جديد والتأكد من توفر المقاعد.',
    'ما هي مستندات التأجيل؟':
        'تحتاج إلى نموذج طلب التأجيل، صورة الهوية الجامعية، والمستند المؤيد للطلب. راجع شؤون الطلاب للتأكد من المتطلبات.',
    'كيف أقدم اعتراضاً على درجة؟':
        'افتح سجل الدرجات، اختر المادة، ثم اضغط تقديم اعتراض. اكتب السبب وأرفق المستندات المطلوبة.',
    'متى يبدأ التسجيل للفصل القادم؟':
        'يبدأ التسجيل للفصل القادم يوم الأحد 12 يناير. تابع التنبيهات داخل التطبيق لمعرفة المواعيد النهائية.',
    'كيف أطلب شهادة التخرج؟':
        'من قسم المستندات اختر شهادة التخرج، أكمل الطلب، ثم تابع حالة الطلب من صفحة طلباتي.',
    'أين أجد جدول المحاضرات؟':
        'ستجد جدول محاضراتك في قسم المحاضرات، ويمكنك فتح جدول أي مقرر لعرض الوقت والقاعة.',
  };

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? value]) {
    final question = (value ?? _inputController.text).trim();
    if (question.isEmpty) return;

    final reply = _replies[question] ??
        'أستطيع مساعدتك في إجراءات الجامعة مثل التسجيل والدرجات والمستندات والمحاضرات. اختر أحد الأسئلة المقترحة للحصول على إجابة سريعة.';

    setState(() {
      _messages
        ..add(_ChatMessage(isUser: true, text: question))
        ..add(_ChatMessage(isUser: false, text: reply));
      _inputController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                children: [
                  ..._messages.map(_buildMessage),
                  const SizedBox(height: 8),
                  Text(
                    'أسئلة مقترحة',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 7,
                    runSpacing: 7,
                    children: _suggestions
                        .map(
                          (suggestion) => InkWell(
                            onTap: () => _send(suggestion),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueLight,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: AppColors.blue.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                suggestion,
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 18, 12),
      color: AppColors.blue,
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            tooltip: 'رجوع',
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: const AppIcon('chat', size: 23, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UNIWAY Assistant',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'مساعدك الجامعي متاح الآن',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 330),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.blue : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
          border: message.isUser
              ? null
              : Border.all(color: AppColors.border),
        ),
        child: Text(
          message.text,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(
            fontSize: 13,
            height: 1.7,
            color: message.isUser ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _send,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const AppIcon('send', size: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _inputController,
              textAlign: TextAlign.right,
              onSubmitted: (_) => _send(),
              style: GoogleFonts.cairo(fontSize: 13, color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'اكتب سؤالك هنا...',
                hintStyle:
                    GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.bg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isUser;
  final String text;

  const _ChatMessage({required this.isUser, required this.text});
}
