import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

/// نقطة دخول طالب الثانوية: تقديم طلب جديد أو تتبع طلب سابق.
class HSApplicantEntryScreen extends StatelessWidget {
  final VoidCallback onApply, onTrack, onBack;
  const HSApplicantEntryScreen({super.key, required this.onApply, required this.onTrack, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'طالب الثانوية', sub: 'اختر الخدمة التي تريدها', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  InkWell(
                    onTap: onApply,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(18)),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.17), borderRadius: BorderRadius.circular(14)),
                            alignment: Alignment.center,
                            child: const AppIcon('grad', size: 24, color: Colors.white),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('تقديم طلب التحاق', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                                const SizedBox(height: 3),
                                Text('قدّم طلبك برفع بطاقة الترشيح وبياناتك الأساسية.', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.78), height: 1.7)),
                              ],
                            ),
                          ),
                          const AppIcon('chevronLeft', size: 18, strokeWidth: 2.5, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTrack,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.blue, width: 1.5)),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(14)),
                            alignment: Alignment.center,
                            child: const AppIcon('search', size: 24, color: AppColors.blue),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('تتبع الطلب', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.blue)),
                                const SizedBox(height: 3),
                                Text('لديك رقم طلب؟ تابع حالة طلبك الآن.', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub, height: 1.7)),
                              ],
                            ),
                          ),
                          const AppIcon('chevronLeft', size: 18, strokeWidth: 2.5, color: AppColors.blue),
                        ],
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

/// نموذج تقديم طلب التحاق لطالب قادم من الثانوية.
class HSApplicationScreen extends StatefulWidget {
  final VoidCallback onBack, onSubmitted;
  const HSApplicationScreen({super.key, required this.onBack, required this.onSubmitted});

  @override
  State<HSApplicationScreen> createState() => _HSApplicationScreenState();
}

class _HSApplicationScreenState extends State<HSApplicationScreen> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  String _file = '';
  bool _confirm = false;

  bool get _idValid => RegExp(r'^\d{14}$').hasMatch(_idCtrl.text);
  bool get _ready => _nameCtrl.text.trim().isNotEmpty && _idValid && _file.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackHeader(title: 'تقديم طلب التحاق', sub: 'للطلاب القادمين من الثانوية', onBack: widget.onBack),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(14)),
                        child: Text('للتقديم تحتاج فقط إلى إدخال اسمك ورقمك القومي ورفع بطاقة الترشيح. لا تحتاج إلى إنشاء حساب.',
                            style: GoogleFonts.cairo(fontSize: 12, color: AppColors.blue, height: 1.8)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الاسم بالكامل', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _nameCtrl,
                              onChanged: (_) => setState(() {}),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(fontSize: 13),
                              decoration: InputDecoration(hintText: 'اكتب الاسم كما هو في بطاقة الرقم القومي', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border))),
                            ),
                            const SizedBox(height: 13),
                            Text('الرقم القومي', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _idCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(14)],
                              onChanged: (_) => setState(() {}),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(fontSize: 13),
                              decoration: InputDecoration(hintText: '14 رقمًا', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _idCtrl.text.isNotEmpty && !_idValid ? AppColors.danger : AppColors.border))),
                            ),
                            if (_idCtrl.text.isNotEmpty && !_idValid)
                              Padding(padding: const EdgeInsets.only(top: 4), child: Text('الرقم القومي يجب أن يتكون من 14 رقمًا', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: _file.isNotEmpty ? AppColors.success : AppColors.border, width: 2)),
                        child: Column(
                          children: [
                            AppIcon(_file.isNotEmpty ? 'checkCircle' : 'upload', size: 28, strokeWidth: 1.8, color: _file.isNotEmpty ? AppColors.success : AppColors.textMuted),
                            const SizedBox(height: 8),
                            Text('رفع بطاقة الترشيح', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                            const SizedBox(height: 3),
                            Text('PDF / JPG / PNG – حتى 5MB', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                            if (_file.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                child: Row(children: [
                                  Expanded(child: Text(_file, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.success))),
                                  const AppIcon('eye', size: 14, strokeWidth: 2, color: AppColors.success),
                                  const SizedBox(width: 8),
                                  InkWell(onTap: () => setState(() => _file = ''), child: const AppIcon('trash', size: 14, strokeWidth: 2, color: AppColors.danger)),
                                ]),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  onPressed: () => setState(() => _file = 'nomination-card.pdf'),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.blueLight, foregroundColor: AppColors.blue, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text('اختيار الملف', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(color: AppColors.white, border: Border(top: BorderSide(color: AppColors.border))),
                  child: PrimaryButton(label: 'إرسال الطلب', onPressed: _ready ? () => setState(() => _confirm = true) : null),
                ),
              ],
            ),
            if (_confirm)
              _ConfirmBox(
                title: 'هل أنت متأكد من إرسال الطلب؟',
                body: 'تأكد من صحة الاسم والرقم القومي ووضوح بطاقة الترشيح قبل الإرسال.',
                onCancel: () => setState(() => _confirm = false),
                onConfirm: widget.onSubmitted,
              ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmBox extends StatelessWidget {
  final String title, body;
  final VoidCallback onCancel, onConfirm;
  const _ConfirmBox({required this.title, required this.body, required this.onCancel, required this.onConfirm});

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
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: Text('إرسال الطلب', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700)),
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

/// شاشة نجاح تقديم طلب الالتحاق، مع رقم الطلب القابل للنسخ.
class HSSuccessScreen extends StatefulWidget {
  final VoidCallback onBack, onTrack;
  const HSSuccessScreen({super.key, required this.onBack, required this.onTrack});

  @override
  State<HSSuccessScreen> createState() => _HSSuccessScreenState();
}

class _HSSuccessScreenState extends State<HSSuccessScreen> {
  bool _copied = false;
  static const _applicationNumber = 'APP-2026-00123';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 16,
              child: InkWell(
                onTap: widget.onBack,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: const AppIcon('arrowRight', size: 18, color: AppColors.blue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                width: 78,
                height: 78,
                decoration: const BoxDecoration(color: AppColors.successLight, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const AppIcon('checkCircle', size: 38, color: AppColors.success),
              ),
              const SizedBox(height: 18),
              Text('تم إرسال طلبك بنجاح', style: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.text)),
              const SizedBox(height: 8),
              Text('احتفظ برقم الطلب لمتابعة حالة طلبك', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.blue.withValues(alpha: 0.15))),
                child: Column(children: [
                  Text('رقم الطلب', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  const Text(_applicationNumber, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.blue)),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: _applicationNumber));
                      setState(() => _copied = true);
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.blue, side: const BorderSide(color: AppColors.blue), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                    child: Text(_copied ? 'تم النسخ' : 'نسخ', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                margin: const EdgeInsets.only(bottom: 22),
                decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(20)),
                child: Text('قيد المراجعة', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.warning)),
              ),
                  SecondaryButton(label: 'تتبع الطلب', onPressed: widget.onTrack),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شاشة إدخال الرقم القومي ورقم الطلب لتتبعه.
class HSTrackScreen extends StatefulWidget {
  final String initialNationalId, initialApplicationNumber;
  final VoidCallback onBack;
  final void Function(String nationalId, String applicationNumber) onFound;
  const HSTrackScreen({super.key, required this.initialNationalId, required this.initialApplicationNumber, required this.onBack, required this.onFound});

  @override
  State<HSTrackScreen> createState() => _HSTrackScreenState();
}

class _HSTrackScreenState extends State<HSTrackScreen> {
  late TextEditingController _idCtrl;
  late TextEditingController _appCtrl;
  String _state = 'idle';

  @override
  void initState() {
    super.initState();
    _idCtrl = TextEditingController(text: widget.initialNationalId);
    _appCtrl = TextEditingController(text: widget.initialApplicationNumber);
  }

  bool get _idValid => RegExp(r'^\d{14}$').hasMatch(_idCtrl.text);
  bool get _appValid => RegExp(r'^APP-\d{4}-\d{5}$').hasMatch(_appCtrl.text);

  void _search() {
    if (!_idValid || !_appValid) return;
    setState(() => _state = 'loading');
    Future.delayed(const Duration(milliseconds: 750), () {
      if (!mounted) return;
      if (_appCtrl.text.endsWith('404')) {
        setState(() => _state = 'not-found');
      } else if (_appCtrl.text.endsWith('500')) {
        setState(() => _state = 'error');
      } else {
        widget.onFound(_idCtrl.text, _appCtrl.text);
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
            BackHeader(title: 'تتبع الطلب', onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('أدخل الرقم القومي ورقم الطلب لمعرفة حالة طلبك.', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub, height: 1.8)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الرقم القومي', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(14)],
                          onChanged: (_) => setState(() => _state = 'idle'),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(fontSize: 13),
                          decoration: InputDecoration(hintText: '14 رقمًا', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _idCtrl.text.isNotEmpty && !_idValid ? AppColors.danger : AppColors.border))),
                        ),
                        if (_idCtrl.text.isNotEmpty && !_idValid)
                          Padding(padding: const EdgeInsets.only(top: 4), child: Text('الرقم القومي يجب أن يتكون من 14 رقمًا', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger))),
                        const SizedBox(height: 13),
                        Text('رقم الطلب', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _appCtrl,
                          onChanged: (v) => setState(() {
                            _appCtrl.value = _appCtrl.value.copyWith(text: v.toUpperCase());
                            _state = 'idle';
                          }),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(fontSize: 13),
                          decoration: InputDecoration(hintText: 'APP-2026-00123', hintStyle: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted), filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _appCtrl.text.isNotEmpty && !_appValid ? AppColors.danger : AppColors.border))),
                        ),
                        if (_appCtrl.text.isNotEmpty && !_appValid)
                          Padding(padding: const EdgeInsets.only(top: 4), child: Text('أدخل رقم الطلب بالصيغة الصحيحة', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.danger))),
                        const SizedBox(height: 15),
                        PrimaryButton(label: 'بحث', onPressed: (_idValid && _appValid && _state != 'loading') ? _search : null),
                      ],
                    ),
                  ),
                  if (_state == 'loading') ...[
                    const SizedBox(height: 12),
                    ...List.generate(3, (i) => Container(height: i == 0 ? 76 : 48, margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: AppColors.border.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(12)))),
                  ],
                  if (_state == 'not-found')
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.danger.withValues(alpha: 0.2))),
                      child: Column(children: [
                        const AppIcon('search', size: 28, strokeWidth: 1.7, color: AppColors.danger),
                        const SizedBox(height: 8),
                        Text('لم يتم العثور على طلب بهذه البيانات، تأكد من الرقم القومي ورقم الطلب.', textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.danger, height: 1.8)),
                      ]),
                    ),
                  if (_state == 'error')
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Column(children: [
                        const AppIcon('alert', size: 28, strokeWidth: 1.8, color: AppColors.danger),
                        const SizedBox(height: 8),
                        Text('حدث خطأ، حاول مرة أخرى', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _search,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
                          child: Text('إعادة المحاولة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ]),
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

class _StatusCfg {
  final Color color, bg;
  final String icon, message;
  const _StatusCfg(this.color, this.bg, this.icon, this.message);
}

/// نتيجة تتبع طلب الالتحاق، تُحدد وفق الأحرف الأخيرة من رقم الطلب (بيانات تجريبية).
class HSStatusScreen extends StatefulWidget {
  final String applicationNumber;
  final VoidCallback onBack;
  const HSStatusScreen({super.key, required this.applicationNumber, required this.onBack});

  @override
  State<HSStatusScreen> createState() => _HSStatusScreenState();
}

class _HSStatusScreenState extends State<HSStatusScreen> {
  bool _reuploaded = false;

  @override
  Widget build(BuildContext context) {
    final num = widget.applicationNumber;
    final status = num.endsWith('124')
        ? 'يحتاج معلومات إضافية'
        : num.endsWith('125')
            ? 'مقبول'
            : num.endsWith('126')
                ? 'مرفوض'
                : 'قيد المراجعة';
    final cfg = status == 'مقبول'
        ? const _StatusCfg(AppColors.success, AppColors.successLight, 'checkCircle', 'تم قبول طلبك، يرجى التوجه إلى الجامعة لاستكمال الإجراءات.')
        : status == 'مرفوض'
            ? const _StatusCfg(AppColors.danger, AppColors.dangerLight, 'xCircle', 'تم رفض الطلب لعدم مطابقة بطاقة الترشيح للبيانات المقدمة.')
            : status == 'يحتاج معلومات إضافية'
                ? const _StatusCfg(AppColors.warning, AppColors.warningLight, 'alert', 'بطاقة الترشيح غير واضحة، يرجى إعادة رفع صورة كاملة وواضحة.')
                : const _StatusCfg(AppColors.blue, AppColors.blueLight, 'clock', 'طلبك قيد المراجعة من شئون الطلاب، يرجى الانتظار.');

    final steps = ['تم استلام الطلب', 'مراجعة بطاقة الترشيح', status == 'مقبول' ? 'تم القبول' : status == 'مرفوض' ? 'تم الرفض' : 'القرار النهائي'];

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'نتيجة تتبع الطلب', onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('محمد أحمد السالم', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.text)),
                        const SizedBox(height: 4),
                        Text('رقم الطلب: $num', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                        Text('تاريخ التقديم: 06 أكتوبر 2026', style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: cfg.bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: cfg.color.withValues(alpha: 0.2))),
                    child: Column(
                      children: [
                        AppIcon(cfg.icon, size: 30, color: cfg.color),
                        const SizedBox(height: 8),
                        Text(status, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w900, color: cfg.color)),
                        const SizedBox(height: 6),
                        Text(cfg.message, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub, height: 1.8)),
                        if (status == 'يحتاج معلومات إضافية')
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => setState(() => _reuploaded = true),
                                style: ElevatedButton.styleFrom(backgroundColor: cfg.color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(_reuploaded ? 'تم إعادة رفع بطاقة الترشيح' : 'إعادة رفع بطاقة الترشيح', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('مراحل الطلب', style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.text)),
                        const SizedBox(height: 12),
                        ...List.generate(steps.length, (i) {
                          final done = i < 2 || (i == 2 && (status == 'مقبول' || status == 'مرفوض'));
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: Row(children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(color: done ? cfg.color : AppColors.border, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: done ? const AppIcon('check', size: 10, strokeWidth: 2.5, color: Colors.white) : null,
                              ),
                              const SizedBox(width: 10),
                              Text(steps[i], style: GoogleFonts.cairo(fontSize: 11, color: done ? AppColors.text : AppColors.textMuted, fontWeight: FontWeight.w700)),
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
