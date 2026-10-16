import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/procedure.dart';
import '../../models/floor_rooms.dart';

/// خريطة المبنى المبسطة توضح موقع مكتب الإجراء داخل الدور المناسب
/// (نسخة مبسطة من CampusMapScreen الأصلية التي كانت ترسم مخططًا تفصيليًا بالـ SVG).
class CampusMapScreen extends StatefulWidget {
  final Procedure proc;
  final VoidCallback onBack;
  const CampusMapScreen({super.key, required this.proc, required this.onBack});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  late String _floor;

  @override
  void initState() {
    super.initState();
    _floor = widget.proc.office.floor.contains('الثاني') ? '2' : '1';
  }

  Color _roomColor(String type, bool highlighted) {
    if (highlighted) return AppColors.danger;
    switch (type) {
      case 'corridor':
        return const Color(0xFFD5E0EC);
      case 'stair':
      case 'toilet':
        return const Color(0xFFEDF2F7);
      case 'entrance':
        return AppColors.blue;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final proc = widget.proc;
    final rooms = floorRooms[_floor] ?? [];

    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              color: AppColors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.blueLight, borderRadius: BorderRadius.circular(18)),
                      alignment: Alignment.center,
                      child: const AppIcon('arrowRight', size: 18, color: AppColors.blue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('خريطة المبنى', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.text)),
                        Text(proc.office.building, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSub)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(child: _floorTab('1', 'الدور الأول')),
                  const SizedBox(width: 8),
                  Expanded(child: _floorTab('2', 'الدور الثاني')),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.blueLight,
              child: Row(
                children: [
                  const AppIcon('mapPin', size: 16, color: AppColors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(proc.office.name, style: GoogleFonts.cairo(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.blue)),
                        Text('${proc.office.floor} · غرفة ${proc.office.roomId}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('مخطط الطابق ${_floor == '1' ? 'الأول' : 'الثاني'}', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.text)),
                      ),
                      const SizedBox(height: 10),
                      AspectRatio(
                        aspectRatio: 340 / 320,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final scale = constraints.maxWidth / 340;
                            return Container(
                              decoration: BoxDecoration(color: const Color(0xFFEDF2F7), borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: rooms.map((r) {
                                  final highlighted = r.id == proc.office.roomId;
                                  return Positioned(
                                    left: r.x * scale,
                                    top: r.y * scale,
                                    width: r.w * scale,
                                    height: r.h * scale,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _roomColor(r.type, highlighted),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: highlighted ? AppColors.danger : const Color(0xFFC8D4E0), width: highlighted ? 1.5 : 1),
                                      ),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(2),
                                      child: r.label.isEmpty
                                          ? null
                                          : Text(
                                              r.label,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.cairo(
                                                fontSize: 7.5 * (scale.clamp(0.6, 1.4)),
                                                fontWeight: highlighted ? FontWeight.w800 : FontWeight.w600,
                                                color: highlighted ? Colors.white : (r.type == 'entrance' ? Colors.white : AppColors.text),
                                              ),
                                            ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _legend(AppColors.danger, 'وجهتك'),
                          _legend(Colors.white, 'مكاتب / غرف', border: true),
                          _legend(const Color(0xFFD5E0EC), 'ممرات'),
                          _legend(AppColors.blue, 'المدخل'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppIcon('navigation', size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text('ابدأ الملاحة داخل المبنى', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _floorTab(String id, String label) {
    final active = _floor == id;
    return InkWell(
      onTap: () => setState(() => _floor = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.blue : AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? AppColors.blue : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(label, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: active ? Colors.white : AppColors.textSub)),
      ),
    );
  }

  Widget _legend(Color color, String label, {bool border = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3), border: border ? Border.all(color: AppColors.border) : null),
        ),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSub)),
      ],
    );
  }
}
