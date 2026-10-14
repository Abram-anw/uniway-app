import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'widgets/bottom_nav.dart';
import 'models/procedure.dart';
import 'models/student_request.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/home_screen.dart';
import 'screens/student/search_screen.dart';
import 'screens/student/assistant_screen.dart';
import 'screens/student/chatboot_screen.dart';
import 'screens/student/reminders_screen.dart';
import 'screens/student/profile_screen.dart';
import 'screens/student/procedure_detail_screen.dart';
import 'screens/student/campus_map_screen.dart';
import 'screens/student/courses_screen.dart';
import 'screens/student/grades_screen.dart';
import 'screens/student/documents_screen.dart';
import 'screens/student/lectures_screen.dart';
import 'screens/student/chat_doctor_screen.dart';
import 'screens/student/chat_student_affairs_screen.dart';
import 'screens/student/notifications_screen.dart';
import 'screens/student/student_requests_flow.dart';
import 'screens/student/settings_support_screens.dart';
import 'screens/high_school/hs_flow.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  String _screen = 'onboarding';
  Procedure? _selectedProc;
  StudentRequestType _selectedStudentRequest = studentRequestTypes.first;
  String _selectedLectureCourse = 'CS401';
  String _selectedDoctor = 'د. سارة القحطاني';
  String _trackNationalId = '';
  String _trackApplicationNumber = '';
  String _trackBack = 'hs-entry';
  String _backTo = 'search';
  String _graduationBack = 'documents';
  final List<GradeAppeal> _appeals = [
    GradeAppeal(
      trackingNumber: 'TZ-2026-1042',
      courseName: 'الإحصاء والاحتمالات',
      courseCode: 'MATH301',
      examType: 'الاختبار النهائي',
      currentGrade: 'A- (89)',
      reason: 'خطأ في التصحيح',
      details: 'لم تحتسب درجتان في السؤال الثالث حسب نموذج الإجابة.',
      status: 'قيد المراجعة',
      submittedAt: '12 أكتوبر 2026',
    ),
    GradeAppeal(
      trackingNumber: 'TZ-2026-0987',
      courseName: 'شبكات الحاسب المتقدمة',
      courseCode: 'CS415',
      examType: 'اختبار منتصف الفصل',
      currentGrade: 'B+ (87)',
      reason: 'عدم احتساب واجب',
      details: 'تم تسليم الواجب في الموعد المحدد ولم تظهر درجته.',
      status: 'تم القبول',
      submittedAt: '28 سبتمبر 2026',
    ),
  ];
  GradeAppeal? _selectedAppeal;

  void _go(String screen) => setState(() => _screen = screen);

  void _openProc(Procedure procedure, {String from = 'search'}) {
    setState(() {
      _selectedProc = procedure;
      _backTo = from;
      _screen = 'detail';
    });
  }

  static const _authScreens = [
    'onboarding',
    'login',
    'hs-entry',
    'hs-form',
    'hs-success',
    'hs-track',
    'hs-status'
  ];

  static const _noTabScreens = [
    ..._authScreens,
    'detail',
    'map',
    'course-withdraw',
    'grade-detail',
    'appeal',
    'graduation',
    'lecture-course',
    'doctor-chat-list',
    'chat-doctor',
    'student-settings',
    'student-support',
    'student-requests',
    'student-request-types',
    'student-request-requirements',
    'student-request-success',
    'student-request-detail',
    'appeal-success',
    'appeal-track',
    'chat-student-affairs',
    'chatboot',
  ];

  bool get _showTabs => !_noTabScreens.contains(_screen);

  Widget? _renderTabBar() {
    if (!_showTabs) return null;
    return RoleBottomNav(
        tabs: RoleBottomNav.studentTabs, active: _screen, onChange: _go);
  }

  Widget _renderScreen() {
    switch (_screen) {
      case 'onboarding':
        return OnboardingScreen(onDone: () => _go('login'));
      case 'login':
        return LoginScreen(
            onLogin: () => _go('home'), onHighSchool: () => _go('hs-entry'));
      case 'home':
        return HomeScreen(
            onNav: _go,
            onSelectProc: (procedure) => _openProc(procedure, from: 'home'));
      case 'search':
        return SearchScreen(onSelectProc: (procedure) => _openProc(procedure));
      case 'assistant':
        return const AssistantScreen();
      case 'chatboot':
        return ChatbootScreen(onBack: () => _go('home'));
      case 'reminders':
        return const RemindersScreen();
      case 'profile':
        return ProfileScreen(onNav: _go, onLogout: () => _go('login'));
      case 'detail':
        return _selectedProc == null
            ? const SizedBox()
            : ProcedureDetailScreen(
                proc: _selectedProc!,
                onBack: () => _go(_backTo),
                onMap: () => _go('map'));
      case 'map':
        return _selectedProc == null
            ? const SizedBox()
            : CampusMapScreen(
                proc: _selectedProc!, onBack: () => _go('detail'));
      case 'courses':
        return CoursesScreen(onNav: _go);
      case 'course-withdraw':
        return CourseWithdrawScreen(onBack: () => _go('courses'));
      case 'grades':
        return GradesScreen(
          onNav: _go,
          appeals: _appeals,
          onTrackAppeal: (appeal) {
            setState(() => _selectedAppeal = appeal);
            _go('appeal-track');
          },
        );
      case 'grade-detail':
        return GradeDetailScreen(onNav: _go, onBack: () => _go('grades'));
      case 'appeal':
        return AppealScreen(
          onBack: () => _go('grade-detail'),
          onSubmitted: (appeal) {
            setState(() {
              _appeals.insert(0, appeal);
              _selectedAppeal = appeal;
            });
            _go('appeal-success');
          },
        );
      case 'appeal-success':
        return AppealSuccessScreen(
          appeal: _selectedAppeal!,
          onTrack: () => _go('appeal-track'),
          onBackToGrades: () => _go('grades'),
        );
      case 'appeal-track':
        return _selectedAppeal == null
            ? const SizedBox()
            : AppealTrackingScreen(
                appeal: _selectedAppeal!,
                onBack: () => _go('grades'),
              );
      case 'documents':
        return DocumentsScreen(onNav: _go);
      case 'graduation':
        return GraduationScreen(onBack: () => _go(_graduationBack));
      case 'lectures':
        return LecturesScreen(
          onBack: () => _go('home'),
          onSelect: (code) {
            setState(() => _selectedLectureCourse = code);
            _go('lecture-course');
          },
        );
      case 'lecture-course':
        return CourseLecturesScreen(
            courseCode: _selectedLectureCourse, onBack: () => _go('lectures'));
      case 'doctor-chat-list':
        return StudentDoctorListScreen(
          onBack: () => _go('home'),
          onSelect: (doctor) {
            setState(() => _selectedDoctor = doctor);
            _go('chat-doctor');
          },
        );
      case 'chat-doctor':
        return ChatDoctorScreen(
            doctorName: _selectedDoctor, onBack: () => _go('doctor-chat-list'));
      case 'notifications':
        return NotificationsScreen(onBack: () => _go('home'));
      case 'student-affairs-portal':
        return StudentAffairsPortalScreen(onNav: _go);
      case 'student-settings':
        return StudentSettingsScreen(onBack: () => _go('profile'));
      case 'student-support':
        return SupportScreen(onBack: () => _go('profile'));
      case 'student-requests':
        return StudentRequestsScreen(onBack: () => _go('profile'));
      case 'student-request-types':
        return StudentRequestTypesScreen(
          onBack: () => _go('student-affairs-portal'),
          onSelect: (request) {
            if (request.id == 'graduation') {
              setState(() => _graduationBack = 'student-request-types');
              _go('graduation');
              return;
            }
            setState(() => _selectedStudentRequest = request);
            _go('student-request-requirements');
          },
        );
      case 'student-request-requirements':
        return StudentRequestRequirementsScreen(
          request: _selectedStudentRequest,
          onBack: () => _go('student-request-types'),
          onSubmitted: () => _go('student-request-success'),
        );
      case 'student-request-success':
        return StudentRequestSuccessScreen(
            onTrack: () => _go('student-request-detail'));
      case 'student-request-detail':
        return StudentRequestDetailScreen(
            onBack: () => _go('student-affairs-portal'),
            onChat: () => _go('chat-student-affairs'));
      case 'chat-student-affairs':
        return ChatStudentAffairsScreen(
            onBack: () => _go('student-request-detail'));
      case 'hs-entry':
        return HSApplicantEntryScreen(
          onBack: () => _go('login'),
          onApply: () => _go('hs-form'),
          onTrack: () {
            setState(() {
              _trackNationalId = '';
              _trackApplicationNumber = '';
              _trackBack = 'hs-entry';
            });
            _go('hs-track');
          },
        );
      case 'hs-form':
        return HSApplicationScreen(
            onBack: () => _go('hs-entry'),
            onSubmitted: () => _go('hs-success'));
      case 'hs-success':
        return HSSuccessScreen(
            onBack: () => _go('hs-entry'),
            onTrack: () {
              setState(() {
                _trackNationalId = '30101011234567';
                _trackApplicationNumber = 'APP-2026-00123';
                _trackBack = 'hs-success';
              });
              _go('hs-track');
            });
      case 'hs-track':
        return HSTrackScreen(
          initialNationalId: _trackNationalId,
          initialApplicationNumber: _trackApplicationNumber,
          onBack: () => _go(_trackBack),
          onFound: (nationalId, applicationNumber) {
            setState(() {
              _trackNationalId = nationalId;
              _trackApplicationNumber = applicationNumber;
            });
            _go('hs-status');
          },
        );
      case 'hs-status':
        return HSStatusScreen(
            applicationNumber: _trackApplicationNumber,
            onBack: () => _go('hs-entry'));
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = _renderTabBar();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: _renderScreen(),
      bottomNavigationBar:
          tabBar == null ? null : SafeArea(top: false, child: tabBar),
    );
  }
}
