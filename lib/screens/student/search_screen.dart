import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/procedure.dart';
import '../../widgets/common.dart';

const _filters = ['الكل', 'شؤون الطلاب', 'الامتحانات', 'الأكاديمية', 'المكتبة', 'الإرشاد'];

Color _deptColor(String dept) {
  if (dept.contains('الامتحانات')) return AppColors.warning;
  if (dept.contains('الأكاديم')) return AppColors.blue;
  if (dept.contains('شؤون الطلاب')) return AppColors.success;
  if (dept.contains('المكتبة')) return const Color(0xFFE11D48);
  if (dept.contains('الإرشاد')) return AppColors.purple;
  return AppColors.blue;
}

/// شاشة البحث عن الإجراءات الجامعية مع فلاتر الأقسام.
class SearchScreen extends StatefulWidget {
  final ValueChanged<Procedure> onSelectProc;
  const SearchScreen({super.key, required this.onSelectProc});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  String _activeFilter = 'الكل';

  List<Procedure> get _filtered {
    return allProcedures.where((p) {
      final matchFilter = _activeFilter == 'الكل' || p.dept.contains(_activeFilter);
      final matchQuery = _query.isEmpty || p.title.contains(_query) || p.dept.contains(_query);
      return matchFilter && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'البحث', subtitle: 'اعثر على أي إجراء جامعي'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              decoration: const BoxDecoration(color: AppColors.card, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const AppIcon('search', size: 17, strokeWidth: 2, color: AppColors.textMuted),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _query = v),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(fontSize: 13, color: AppColors.text),
                            decoration: InputDecoration(
                              hintText: 'ابحث عن إجراء أو قسم...',
                              hintStyle: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 32,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _filters.map((f) {
                        final active = _activeFilter == f;
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () => setState(() => _activeFilter = f),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: active ? AppColors.blue : AppColors.bg,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: active ? AppColors.blue : AppColors.border),
                              ),
                              alignment: Alignment.center,
                              child: Text(f, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : AppColors.textSub)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const EmptyState(icon: 'search', text: 'لا توجد نتائج\nجرّب كلمات بحث مختلفة')
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      itemCount: filtered.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text('${filtered.length} نتيجة', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                          );
                        }
                        final p = filtered[i - 1];
                        final dc = _deptColor(p.dept);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () => widget.onSelectProc(p),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          spacing: 8,
                                          children: [
                                            Text(p.title, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text)),
                                            if (p.tag.isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: p.tag == 'عاجل' ? AppColors.dangerLight : AppColors.blueLight,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(p.tag, style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: p.tag == 'عاجل' ? AppColors.danger : AppColors.blue)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Container(width: 6, height: 6, decoration: BoxDecoration(color: dc, shape: BoxShape.circle)),
                                            const SizedBox(width: 6),
                                            Text(p.dept, style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w600, color: dc)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text('${p.steps.length} خطوات', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                            const SizedBox(width: 12),
                                            Text('المدة: ${p.duration}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                            if (p.deadline != null) ...[
                                              const SizedBox(width: 12),
                                              AppIcon('clock', size: 12, strokeWidth: 2, color: AppColors.urgencyColor(p.deadline!.urgency)),
                                              const SizedBox(width: 4),
                                              Text('له موعد نهائي', style: GoogleFonts.cairo(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.urgencyColor(p.deadline!.urgency))),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const AppIcon('chevronLeft', size: 16, strokeWidth: 2, color: AppColors.textMuted),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
