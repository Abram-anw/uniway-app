/// بيانات غرف ومرافق كل دور لمخطط المبنى (floorRooms في الكود الأصلي).
class FloorRoom {
  final String id, label, type;
  final double x, y, w, h;
  const FloorRoom({required this.id, required this.label, required this.x, required this.y, required this.w, required this.h, required this.type});
}

final Map<String, List<FloorRoom>> floorRooms = {
  '1': [
    FloorRoom(id: 'c1', label: '', x: 70.0, y: 80.0, w: 260.0, h: 30.0, type: 'corridor'),
    FloorRoom(id: 'c2', label: '', x: 70.0, y: 200.0, w: 260.0, h: 30.0, type: 'corridor'),
    FloorRoom(id: 'c3', label: '', x: 155.0, y: 80.0, w: 30.0, h: 150.0, type: 'corridor'),
    FloorRoom(id: '101', label: 'شؤون الطلاب\n101', x: 70.0, y: 30.0, w: 80.0, h: 50.0, type: 'room'),
    FloorRoom(id: '102', label: 'مراقبة الامتحانات\n102', x: 155.0, y: 30.0, w: 80.0, h: 50.0, type: 'room'),
    FloorRoom(id: '103', label: 'الأكاديمية\n103', x: 240.0, y: 30.0, w: 90.0, h: 50.0, type: 'room'),
    FloorRoom(id: '104', label: 'المحاسبة\n104', x: 70.0, y: 110.0, w: 80.0, h: 85.0, type: 'room'),
    FloorRoom(id: '105', label: 'السجلات\n105', x: 155.0, y: 110.0, w: 80.0, h: 85.0, type: 'room'),
    FloorRoom(id: '106', label: 'الدعم\n106', x: 240.0, y: 110.0, w: 90.0, h: 85.0, type: 'room'),
    FloorRoom(id: 'toilet', label: 'دورة المياه', x: 70.0, y: 230.0, w: 60.0, h: 50.0, type: 'toilet'),
    FloorRoom(id: 'stair', label: 'سلم', x: 135.0, y: 230.0, w: 40.0, h: 50.0, type: 'stair'),
    FloorRoom(id: '107', label: 'الإرشاد\n107', x: 180.0, y: 230.0, w: 150.0, h: 50.0, type: 'room'),
    FloorRoom(id: 'entrance', label: 'المدخل الرئيسي', x: 130.0, y: 288.0, w: 80.0, h: 26.0, type: 'entrance'),
  ],
  '2': [
    FloorRoom(id: 'c1', label: '', x: 70.0, y: 80.0, w: 260.0, h: 30.0, type: 'corridor'),
    FloorRoom(id: 'c2', label: '', x: 70.0, y: 190.0, w: 260.0, h: 30.0, type: 'corridor'),
    FloorRoom(id: '210', label: 'الشؤون الأكاديمية\n210', x: 70.0, y: 30.0, w: 100.0, h: 50.0, type: 'room'),
    FloorRoom(id: '211', label: 'الإرشاد\n211', x: 175.0, y: 30.0, w: 80.0, h: 50.0, type: 'room'),
    FloorRoom(id: '212', label: 'الجودة\n212', x: 260.0, y: 30.0, w: 70.0, h: 50.0, type: 'room'),
    FloorRoom(id: '213', label: 'شؤون أعضاء\nهيئة التدريس\n213', x: 70.0, y: 110.0, w: 80.0, h: 75.0, type: 'room'),
    FloorRoom(id: '214', label: 'الاعتماد\n214', x: 155.0, y: 110.0, w: 80.0, h: 75.0, type: 'room'),
    FloorRoom(id: '215', label: 'الإرشاد الأكاديمي\n215', x: 240.0, y: 110.0, w: 90.0, h: 75.0, type: 'room'),
    FloorRoom(id: 'stair', label: 'سلم', x: 70.0, y: 220.0, w: 40.0, h: 50.0, type: 'stair'),
    FloorRoom(id: '216', label: 'قاعة الاجتماعات\n216', x: 115.0, y: 220.0, w: 215.0, h: 50.0, type: 'room'),
  ],
};
