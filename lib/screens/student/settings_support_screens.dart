import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../widgets/common.dart';

class _ToggleRow {
  final String key, label, sub;
  const _ToggleRow(this.key, this.label, this.sub);
}

const _toggleRows = [
  _ToggleRow('academic', 'التنبيهات الأكاديمية', 'الدرجات والتسجيل والمحاضرات'),
  _ToggleRow('requests', 'تحديثات الطلبات', 'تغيّر حالة الطلب والمستندات'),
  _ToggleRow('messages', 'الرسائل', 'الدكاترة وشؤون الطلاب'),
  _ToggleRow('marketing', 'الأخبار والفعاليات', 'إعلانات الجامعة والأنشطة'),
  _ToggleRow('biometric', 'الدخول بالبصمة', 'حماية أسرع لهذا الجهاز'),
];

/// إعدادات الحساب والتنبيهات والأمان.
class StudentSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onNavigate;

  const StudentSettingsScreen({
    super.key,
    required this.onBack,
    required this.onNavigate,
  });

  @override
  State<StudentSettingsScreen> createState() => _StudentSettingsScreenState();
}

class _StudentSettingsScreenState extends State<StudentSettingsScreen> {
  final Map<String, bool> _toggles = {
    'academic': true,
    'requests': true,
    'messages': true,
    'marketing': false,
    'biometric': true
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'الإعدادات',
                sub: 'الحساب والتنبيهات والأمان',
                onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Text('التنبيهات والأمان',
                      style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSub)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_toggleRows.length, (i) {
                        final row = _toggleRows[i];
                        final on = _toggles[row.key] ?? false;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 13),
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(row.label,
                                          style: GoogleFonts.cairo(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.text)),
                                      Text(row.sub,
                                          style: GoogleFonts.cairo(
                                              fontSize: 11,
                                              color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      setState(() => _toggles[row.key] = !on),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 42,
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    decoration: BoxDecoration(
                                        color: on
                                            ? AppColors.blue
                                            : AppColors.border,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    alignment: on
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle)),
                                  ),
                                ),
                              ]),
                            ),
                            if (i < _toggleRows.length - 1)
                              const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                  indent: 16),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: [
                        RowItem(
                          icon: 'user',
                          color: AppColors.blue,
                          bg: AppColors.blueLight,
                          title: 'بيانات الحساب',
                          sub: 'البريد الجامعي ورقم الهاتف',
                          onTap: () => widget.onNavigate('account-data'),
                        ),
                        RowItem(
                          icon: 'lock',
                          color: AppColors.purple,
                          bg: AppColors.purpleLight,
                          title: 'تغيير كلمة المرور',
                          sub: 'تحديث كلمة مرور حسابك',
                          onTap: () => widget.onNavigate('change-password'),
                        ),
                        RowItem(
                          icon: 'info',
                          color: AppColors.success,
                          bg: AppColors.successLight,
                          title: 'عن UNIWAY',
                          sub: 'الإصدار 2.4.1 · سياسة الخصوصية',
                          divider: false,
                          onTap: () => widget.onNavigate('about-app'),
                        ),
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

/// بيانات التواصل الجامعية القابلة للتعديل.
class AccountDataScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String email;
  final String phone;
  final void Function(String email, String phone) onSave;

  const AccountDataScreen({
    super.key,
    required this.onBack,
    required this.email,
    required this.phone,
    required this.onSave,
  });

  @override
  State<AccountDataScreen> createState() => _AccountDataScreenState();
}

class _AccountDataScreenState extends State<AccountDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(_emailController.text.trim(), _phoneController.text.trim());
    setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'بيانات الحساب',
              sub: 'حدّث وسائل التواصل الخاصة بك',
              onBack: widget.onBack,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SettingsInfoBanner(
                    icon: 'user',
                    color: AppColors.blue,
                    bg: AppColors.blueLight,
                    text:
                        'تأكد من صحة بيانات التواصل لتصلك تحديثات طلباتك وتنبيهات الجامعة.',
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Form(
                      key: _formKey,
                      onChanged: () {
                        if (_saved) setState(() => _saved = false);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'البريد الجامعي',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSub,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(fontSize: 13),
                            decoration: _settingsInputDecoration(
                              hint: 'name@university.edu',
                              icon: 'mail',
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) return 'أدخل البريد الجامعي';
                              if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(email)) {
                                return 'أدخل بريدًا إلكترونيًا صحيحًا';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'رقم الهاتف',
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSub,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(fontSize: 13),
                            decoration: _settingsInputDecoration(
                              hint: '05xxxxxxxx',
                              icon: 'phone',
                            ),
                            validator: (value) {
                              final phone = value?.trim() ?? '';
                              final digits = phone.replaceAll(
                                RegExp(r'[\s()+-]'),
                                '',
                              );
                              if (phone.isEmpty) return 'أدخل رقم الهاتف';
                              if (!RegExp(r'^\d{9,15}$').hasMatch(digits)) {
                                return 'أدخل رقم هاتف صحيحًا';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          PrimaryButton(
                            label: 'حفظ التغييرات',
                            icon: 'check',
                            onPressed: _save,
                          ),
                          if (_saved) ...[
                            const SizedBox(height: 12),
                            const _SettingsSuccessMessage(
                              text: 'تم تحديث بيانات التواصل في الجلسة الحالية.',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _SettingsInfoBanner(
                    icon: 'idCard',
                    color: AppColors.textSub,
                    bg: AppColors.blueLight,
                    text:
                        'رقم الطالب والبيانات الأكاديمية تُدار من نظام الجامعة ولا يمكن تعديلها من هنا.',
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

/// نموذج تغيير كلمة المرور مع تحقق محلي من المدخلات.
class ChangePasswordScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ChangePasswordScreen({super.key, required this.onBack});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showSuccess = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _showSuccess = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'تغيير كلمة المرور',
              sub: 'استخدم كلمة مرور قوية وفريدة',
              onBack: widget.onBack,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _SettingsInfoBanner(
                    icon: 'shield',
                    color: AppColors.purple,
                    bg: AppColors.purpleLight,
                    text:
                        'اختر كلمة مرور لا تقل عن 8 أحرف، واجمع بين الحروف والأرقام.',
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Form(
                      key: _formKey,
                      onChanged: () {
                        if (_showSuccess) {
                          setState(() => _showSuccess = false);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PasswordField(
                            controller: _currentController,
                            label: 'كلمة المرور الحالية',
                            obscureText: _obscureCurrent,
                            onToggleVisibility: () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                            validator: (value) => (value ?? '').isEmpty
                                ? 'أدخل كلمة المرور الحالية'
                                : null,
                          ),
                          const SizedBox(height: 14),
                          _PasswordField(
                            controller: _newController,
                            label: 'كلمة المرور الجديدة',
                            obscureText: _obscureNew,
                            onToggleVisibility: () =>
                                setState(() => _obscureNew = !_obscureNew),
                            validator: (value) {
                              final password = value ?? '';
                              if (password.length < 8) {
                                return 'يجب أن تتكون من 8 أحرف على الأقل';
                              }
                              if (password == _currentController.text) {
                                return 'اختر كلمة مرور مختلفة عن الحالية';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _PasswordField(
                            controller: _confirmController,
                            label: 'تأكيد كلمة المرور الجديدة',
                            obscureText: _obscureConfirm,
                            onToggleVisibility: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                            validator: (value) => value != _newController.text
                                ? 'كلمتا المرور غير متطابقتين'
                                : null,
                          ),
                          const SizedBox(height: 18),
                          PrimaryButton(
                            label: 'تأكيد التغيير',
                            icon: 'lock',
                            onPressed: _submit,
                          ),
                          if (_showSuccess) ...[
                            const SizedBox(height: 12),
                            const _SettingsInfoBanner(
                              icon: 'info',
                              color: AppColors.warning,
                              bg: AppColors.warningLight,
                              text:
                                  'البيانات مكتملة. يلزم ربط التطبيق بخدمة الجامعة لتحديث كلمة المرور فعليًا.',
                            ),
                          ],
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

/// معلومات التطبيق وروابط صفحات التعريف والخصوصية.
class AboutAppScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onPrivacy;
  final VoidCallback onSupport;

  const AboutAppScreen({
    super.key,
    required this.onBack,
    required this.onPrivacy,
    required this.onSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'عن UNIWAY',
              sub: 'دليلك للخدمات الجامعية',
              onBack: onBack,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: AppColors.blueLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: const AppIcon(
                            'grad',
                            size: 34,
                            color: AppColors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'UNIWAY',
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          'دليل الخدمات الجامعية الذكي',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: AppColors.textSub,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const AppChip(
                          label: 'الإصدار 2.4.1',
                          color: AppColors.blue,
                          bg: AppColors.blueLight,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        RowItem(
                          icon: 'shield',
                          color: AppColors.success,
                          bg: AppColors.successLight,
                          title: 'سياسة الخصوصية',
                          sub: 'كيف نتعامل مع بياناتك',
                          onTap: onPrivacy,
                          divider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _SettingsInfoBanner(
                    icon: 'info',
                    color: AppColors.blue,
                    bg: AppColors.blueLight,
                    text:
                        'UNIWAY يساعدك على الوصول إلى الخدمات الأكاديمية ومتابعة طلباتك الجامعية من مكان واحد.',
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'تواصل مع الدعم',
                    onPressed: onSupport,
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

/// شرح موجز وواضح للبيانات التي يتعامل معها التطبيق.
class PrivacyPolicyScreen extends StatelessWidget {
  final VoidCallback onBack;

  const PrivacyPolicyScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    const sections = [
      (
        'البيانات التي نستخدمها',
        'قد يعرض التطبيق بيانات الحساب ووسائل التواصل والطلبات الأكاديمية التي تدخلها أثناء استخدام الخدمات.'
      ),
      (
        'استخدام البيانات',
        'تُستخدم البيانات لتخصيص تجربتك، وعرض الخدمات المناسبة، ومساعدتك على متابعة الطلبات والتنبيهات.'
      ),
      (
        'حماية البيانات',
        'حافظ على سرية كلمة المرور ولا تشاركها مع الآخرين. لا تُدخل معلومات حساسة إلا عبر القنوات الجامعية المعتمدة.'
      ),
      (
        'التحكم ببياناتك',
        'يمكنك تعديل بيانات التواصل من صفحة بيانات الحساب. أما البيانات الأكاديمية فتُحدّث من أنظمة الجامعة.'
      ),
    ];

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'سياسة الخصوصية',
              sub: 'آخر تحديث: أكتوبر 2026',
              onBack: onBack,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _SettingsInfoBanner(
                    icon: 'shield',
                    color: AppColors.success,
                    bg: AppColors.successLight,
                    text:
                        'هذا ملخص توضيحي للنسخة الحالية. تُحدد سياسة الجامعة الرسمية تفاصيل معالجة بيانات الحساب والخدمات.',
                  ),
                  const SizedBox(height: 12),
                  ...sections.map(
                    (section) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.$1,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            section.$2,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              height: 1.8,
                              color: AppColors.textSub,
                            ),
                          ),
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

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSub,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(fontSize: 13),
          decoration: _settingsInputDecoration(
            hint: '••••••••',
            icon: 'lock',
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: AppIcon(
                obscureText ? 'eye' : 'eyeOff',
                size: 18,
                color: AppColors.textMuted,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class _SettingsInfoBanner extends StatelessWidget {
  final String icon;
  final Color color;
  final Color bg;
  final String text;

  const _SettingsInfoBanner({
    required this.icon,
    required this.color,
    required this.bg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          AppIcon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 11,
                height: 1.7,
                color: AppColors.textSub,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSuccessMessage extends StatelessWidget {
  final String text;

  const _SettingsSuccessMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const AppIcon('checkCircle', size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _settingsInputDecoration({
  required String hint,
  required String icon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.cairo(
      fontSize: 11,
      color: AppColors.textMuted,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.all(12),
      child: AppIcon(icon, size: 18, color: AppColors.textMuted),
    ),
    filled: true,
    fillColor: AppColors.bg,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.blue, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.danger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
    ),
  );
}

class _StudentPastRequest {
  final String id, type, date, status;
  final Color color, bg;
  final int progressSteps;
  const _StudentPastRequest(this.id, this.type, this.date, this.status,
      this.color, this.bg, this.progressSteps);
}

final _pastRequests = [
  _StudentPastRequest('REQ-1048', 'تظلم على درجة', '5 يناير 2025',
      'قيد المراجعة', AppColors.warning, AppColors.warningLight, 2),
  _StudentPastRequest('DOC-9921', 'كشف درجات رسمي', '2 يناير 2025', 'مكتمل',
      AppColors.success, AppColors.successLight, 4),
  _StudentPastRequest('REG-7734', 'انسحاب من مقرر', '18 ديسمبر 2024',
      'يحتاج معلومات', AppColors.danger, AppColors.dangerLight, 1),
];

/// سجل طلبات الطالب السابقة لشؤون الطلاب مع مؤشر تقدّم بصري.
class StudentRequestsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const StudentRequestsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'طلباتي السابقة',
                sub: 'متابعة كل الطلبات من مكان واحد',
                onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: _pastRequests.map((r) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.type,
                                        style: GoogleFonts.cairo(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.text)),
                                    Text('${r.id} · ${r.date}',
                                        style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: r.bg,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(r.status,
                                      style: GoogleFonts.cairo(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: r.color))),
                            ]),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(4, (i) {
                            return Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.only(left: i < 3 ? 4 : 0),
                                decoration: BoxDecoration(
                                    color: i < r.progressSteps
                                        ? r.color
                                        : AppColors.border,
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                            );
                          }),
                        ),
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

/// شاشة الدعم والإبلاغ عن مشكلة إدارية أو أكاديمية أو تقنية.
class SupportScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SupportScreen({super.key, required this.onBack});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool _sent = false;
  String _type = 'إدارية';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'الدعم والإبلاغ',
                sub: 'سنرد عليك خلال يوم عمل',
                onBack: widget.onBack),
            Expanded(
              child: _sent
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 20),
                        decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border)),
                        alignment: Alignment.center,
                        child: Column(children: [
                          Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  color: AppColors.successLight,
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: const AppIcon('checkCircle',
                                  size: 28, color: AppColors.success)),
                          const SizedBox(height: 14),
                          Text('تم إرسال البلاغ بنجاح',
                              style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.text)),
                          const SizedBox(height: 6),
                          Text('رقم المتابعة: SUP-2025-184',
                              style: GoogleFonts.cairo(
                                  fontSize: 12, color: AppColors.textMuted)),
                        ]),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('نوع المشكلة',
                                  style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSub)),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.bg,
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColors.border)),
                                child: DropdownButton<String>(
                                  value: _type,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: [
                                    'إدارية',
                                    'أكاديمية',
                                    'تقنية',
                                    'اقتراح أو ملاحظة'
                                  ]
                                      .map((o) => DropdownMenuItem(
                                          value: o,
                                          child: Text(o,
                                              style: GoogleFonts.cairo(
                                                  fontSize: 12))))
                                      .toList(),
                                  onChanged: (v) => setState(() => _type = v!),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text('وصف المشكلة',
                                  style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textSub)),
                              const SizedBox(height: 6),
                              TextField(
                                maxLines: 5,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.cairo(fontSize: 13),
                                decoration: InputDecoration(
                                    hintText:
                                        'اشرح المشكلة بوضوح، وأضف رقم الطلب إن وجد...',
                                    hintStyle: GoogleFonts.cairo(
                                        fontSize: 11,
                                        color: AppColors.textMuted),
                                    filled: true,
                                    fillColor: AppColors.bg,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: AppColors.border))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(18),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: AppColors.border, width: 2)),
                          child: Column(children: [
                            const AppIcon('upload',
                                size: 24,
                                strokeWidth: 1.8,
                                color: AppColors.textMuted),
                            const SizedBox(height: 6),
                            Text('إرفاق صورة أو مستند داعم',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: AppColors.textSub)),
                          ]),
                        ),
                        PrimaryButton(
                            label: 'إرسال البلاغ',
                            onPressed: () => setState(() => _sent = true)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
