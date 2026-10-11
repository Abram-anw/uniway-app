import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';

/// الأدوار المتاحة في النظام (يقابل UserRole الأصلي).
enum UserRole { student, doctor, affairs, admin, highschool }

class _DemoAccount {
  final String label, id, hint;
  const _DemoAccount(this.label, this.id, this.hint);
}

const _demoAccounts = [
  _DemoAccount('طالب', '20210145', 'الصفحة الرئيسية للطالب'),
  _DemoAccount('دكتور', 'DR1001', 'لوحة الدكتور'),
  _DemoAccount('شئون الطلاب', 'SA2001', 'لوحة شئون الطلاب'),
  _DemoAccount('إدارة', 'AD3001', 'لوحة تحكم الإدارة'),
];

/// شاشة تسجيل الدخول، تحدد الدور تلقائيًا من بادئة الكود الجامعي
/// (DR = دكتور، SA = شؤون طلاب، AD = إدارة، أرقام فقط = طالب).
class LoginScreen extends StatefulWidget {
  final ValueChanged<UserRole> onLogin;
  final VoidCallback onHighSchool;
  const LoginScreen({super.key, required this.onLogin, required this.onHighSchool});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _remember = true;
  bool _showDemo = false;
  bool _loading = false;
  String _error = '';

  void _handleLogin() {
    final normalized = _idCtrl.text.trim().toUpperCase();
    final validId = RegExp(r'^\d+$').hasMatch(normalized) ||
        RegExp(r'^DR\d+$').hasMatch(normalized) ||
        RegExp(r'^SA\d+$').hasMatch(normalized) ||
        RegExp(r'^AD\d+$').hasMatch(normalized);
    if (!validId || _passCtrl.text != '123456') {
      setState(() => _error = 'بيانات الدخول غير صحيحة، حاول مرة أخرى');
      return;
    }
    final role = normalized.startsWith('DR')
        ? UserRole.doctor
        : normalized.startsWith('SA')
            ? UserRole.affairs
            : normalized.startsWith('AD')
                ? UserRole.admin
                : UserRole.student;
    setState(() {
      _error = '';
      _loading = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _loading = false);
      widget.onLogin(role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                color: AppColors.blue,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const AppIcon('grad', size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text('UNIWAY', style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                    const SizedBox(height: 2),
                    Text('جامعتك... في طريق واحد', style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.72))),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('تسجيل الدخول', style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.text)),
                            const SizedBox(height: 4),
                            Text('أدخل بياناتك وسيتم توجيهك تلقائيًا حسب صلاحية حسابك',
                                style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                            const SizedBox(height: 18),
                            _buildField(label: 'الكود الجامعي', icon: 'idCard', controller: _idCtrl, hint: 'مثال: 20210145'),
                            const SizedBox(height: 8),
                            _buildPassField(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => setState(() => _remember = !_remember),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: _remember ? AppColors.blue : AppColors.white,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: _remember ? AppColors.blue : AppColors.border, width: 2),
                                        ),
                                        alignment: Alignment.center,
                                        child: _remember ? const AppIcon('check', size: 10, strokeWidth: 3, color: Colors.white) : null,
                                      ),
                                      const SizedBox(width: 7),
                                      Text('تذكرني', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
                                    ],
                                  ),
                                ),
                                Text('نسيت كلمة المرور؟', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.blue)),
                              ],
                            ),
                            if (_error.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(color: AppColors.dangerLight, borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    const AppIcon('alert', size: 14, strokeWidth: 2, color: AppColors.danger),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(_error, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.danger))),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _loading ? AppColors.border : AppColors.blue,
                                  foregroundColor: _loading ? AppColors.textMuted : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  _loading ? 'جارٍ تسجيل الدخول...' : 'تسجيل الدخول',
                                  style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Expanded(child: Divider(color: AppColors.border)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('أو', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                ),
                                const Expanded(child: Divider(color: AppColors.border)),
                              ],
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: widget.onHighSchool,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.blue,
                                  side: const BorderSide(color: AppColors.blue, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text('أنا طالب قادم من الثانوية', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('الحسابات يتم إنشاؤها بواسطة إدارة الجامعة',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFDF5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.warning),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => setState(() => _showDemo = !_showDemo),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('بيانات تجريبية للدخول', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.warning)),
                                    AppIcon(_showDemo ? 'chevronRight' : 'chevronLeft', size: 14, strokeWidth: 2, color: AppColors.warning),
                                  ],
                                ),
                              ),
                            ),
                            if (_showDemo)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                child: Column(
                                  children: [
                                    ..._demoAccounts.map((demo) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              _idCtrl.text = demo.id;
                                              _passCtrl.text = '123456';
                                              _error = '';
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0x40D97706)))),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('${demo.label}: ${demo.id}', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.text)),
                                                Text(demo.hint, style: GoogleFonts.cairo(fontSize: 9, color: AppColors.textMuted)),
                                              ],
                                            ),
                                          ),
                                        )),
                                    const SizedBox(height: 4),
                                    Text('كلمة المرور لجميع الحسابات: 123456', style: GoogleFonts.cairo(fontSize: 9, color: AppColors.warning)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({required String label, required String icon, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              AppIcon(icon, size: 17, strokeWidth: 1.8, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (_) => setState(() => _error = ''),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(fontSize: 13, color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('كلمة المرور', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSub)),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              const AppIcon('lock', size: 17, strokeWidth: 1.8, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  onChanged: (_) => setState(() => _error = ''),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.cairo(fontSize: 13, color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _showPass = !_showPass),
                child: AppIcon(_showPass ? 'eyeOff' : 'eye', size: 16, strokeWidth: 1.8, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
