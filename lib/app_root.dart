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
import 'screens/student/reminders_screen.dart';
import 'screens/student/profile_screen.dart';
import 'screens/student/procedure_detail_screen.dart';
import 'screens/student/campus_map_screen.dart';
import 'screens/student/courses_screen.dart';
import 'screens/student/grades_screen.dart';
import 'screens/student/documents_screen.dart';
import 'screens/student/lectures_screen.dart';
import 'screens/student/chat_doctor_screen.dart';
import 'screens/student/notifications_screen.dart';
import 'screens/student/student_requests_flow.dart';
import 'screens/student/settings_support_screens.dart';

import 'screens/high_school/hs_flow.dart';

import 'screens/doctor/doc_dashboard_screen.dart';
import 'screens/doctor/doc_courses_screen.dart';
import 'screens/doctor/doc_grades_screen.dart';
import 'screens/doctor/doc_lectures_screen.dart';
import 'screens/doctor/doc_chats_screen.dart';

import 'screens/student_affairs/sa_screens.dart';

import 'screens/admin/admin_screens1.dart';
import 'screens/admin/admin_screens2.dart';

/// جذر التطبيق وآلة التنقل بين الشاشات، تقابل App() في الكود الأصلي.
/// تستخدم معرّف شاشة نصي (screen id) مطابق تمامًا لقيم Screen الأصلية،
/// مع نفس منطق noTabScreens لإظهار/إخفاء الشريط السفلي.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  String _screen = 'onboarding';
  UserRole _userRole = UserRole.student;
  Procedure? _selectedProc;
  StudentRequestType _selectedStudentRequest = studentRequestTypes.first;
  String _selectedLectureCourse = 'CS401';
  String _selectedDoctor = 'د. سارة القحطاني';
  String _trackNationalId = '';
  String _trackApplicationNumber = '';
  String _trackBack = 'hs-entry';
  String _backTo = 'search';

  void _go(String s) => setState(() => _screen = s);

  void _openProc(Procedure p, {String from = 'search'}) {
    setState(() {
      _selectedProc = p;
      _backTo = from;
      _screen = 'detail';
    });
  }

  static const _authScreens = ['onboarding', 'login', 'hs-entry', 'hs-form', 'hs-success', 'hs-track', 'hs-status'];

  static const _noTabScreens = [
    ..._authScreens,
    'detail', 'map', 'course-withdraw', 'grade-detail', 'appeal', 'graduation', 'lecture-course',
    'doctor-chat-list', 'chat-doctor', 'student-settings', 'student-support', 'student-requests',
    'student-request-types', 'student-request-requirements', 'student-request-success', 'student-request-detail',
    'doc-course-detail', 'doc-students', 'doc-upload-grades', 'doc-records', 'doc-lectures', 'doc-upload-lecture',
    'sa-request-detail', 'sa-hs-detail', 'sa-search', 'sa-chat',
    'adm-roles', 'adm-departments', 'adm-admission', 'adm-grades', 'adm-documents', 'adm-announcements',
    'adm-ai-kb', 'adm-add-user', 'adm-request-requirements',
  ];

  bool get _showTabs => !_noTabScreens.contains(_screen);

  String _roleHomeScreen(UserRole r) {
    switch (r) {
      case UserRole.doctor:
        return 'doc-dashboard';
      case UserRole.affairs:
        return 'sa-dashboard';
      case UserRole.admin:
        return 'adm-dashboard';
      case UserRole.highschool:
        return 'hs-entry';
      case UserRole.student:
        return 'home';
    }
  }

  Widget? _renderTabBar() {
    if (!_showTabs) return null;
    List<NavTabDef> tabs;
    switch (_userRole) {
      case UserRole.doctor:
        tabs = RoleBottomNav.docTabs;
        break;
      case UserRole.affairs:
        tabs = RoleBottomNav.saTabs;
        break;
      case UserRole.admin:
        tabs = RoleBottomNav.adminTabs;
        break;
      case UserRole.student:
        tabs = RoleBottomNav.studentTabs;
        break;
      default:
        return null;
    }
    return RoleBottomNav(tabs: tabs, active: _screen, onChange: _go);
  }

  Widget _renderScreen() {
    switch (_screen) {
      // Auth
      case 'onboarding':
        return OnboardingScreen(onDone: () => _go('login'));
      case 'login':
        return LoginScreen(
          onLogin: (role) {
            setState(() => _userRole = role);
            _go(_roleHomeScreen(role));
          },
          onHighSchool: () => _go('hs-entry'),
        );

      // Student
      case 'home':
        return HomeScreen(onNav: _go, onSelectProc: (p) => _openProc(p, from: 'home'));
      case 'search':
        return SearchScreen(onSelectProc: (p) => _openProc(p, from: 'search'));
      case 'assistant':
        return const AssistantScreen();
      case 'reminders':
        return const RemindersScreen();
      case 'profile':
        return ProfileScreen(
          role: _userRole,
          onNav: _go,
          onLogout: () {
            setState(() => _userRole = UserRole.student);
            _go('login');
          },
        );
      case 'detail':
        return _selectedProc == null
            ? const SizedBox()
            : ProcedureDetailScreen(proc: _selectedProc!, onBack: () => _go(_backTo), onMap: () => _go('map'));
      case 'map':
        return _selectedProc == null ? const SizedBox() : CampusMapScreen(proc: _selectedProc!, onBack: () => _go('detail'));
      case 'courses':
        return CoursesScreen(onNav: _go);
      case 'course-withdraw':
        return CourseWithdrawScreen(onBack: () => _go('courses'));
      case 'grades':
        return GradesScreen(onNav: _go);
      case 'grade-detail':
        return GradeDetailScreen(onNav: _go, onBack: () => _go('grades'));
      case 'appeal':
        return AppealScreen(onBack: () => _go('grade-detail'));
      case 'documents':
        return DocumentsScreen(onNav: _go);
      case 'graduation':
        return GraduationScreen(onBack: () => _go('documents'));
      case 'lectures':
        return LecturesScreen(
          onBack: () => _go('home'),
          onSelect: (code) {
            setState(() => _selectedLectureCourse = code);
            _go('lecture-course');
          },
        );
      case 'lecture-course':
        return CourseLecturesScreen(courseCode: _selectedLectureCourse, onBack: () => _go('lectures'));
      case 'doctor-chat-list':
        return StudentDoctorListScreen(
          onBack: () => _go('home'),
          onSelect: (doctor) {
            setState(() => _selectedDoctor = doctor);
            _go('chat-doctor');
          },
        );
      case 'chat-doctor':
        return ChatDoctorScreen(doctorName: _selectedDoctor, onBack: () => _go(_userRole == UserRole.doctor ? 'doc-chats' : 'doctor-chat-list'));
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
        return StudentRequestSuccessScreen(onTrack: () => _go('student-request-detail'));
      case 'student-request-detail':
        return StudentRequestDetailScreen(onBack: () => _go('student-affairs-portal'), onChat: () => _go('sa-chat'));

      // High school
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
        return HSApplicationScreen(onBack: () => _go('hs-entry'), onSubmitted: () => _go('hs-success'));
      case 'hs-success':
        return HSSuccessScreen(onTrack: () {
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
        return HSStatusScreen(applicationNumber: _trackApplicationNumber, onBack: () => _go('hs-track'));

      // Doctor
      case 'doc-dashboard':
        return DocDashboardScreen(onNav: _go);
      case 'doc-courses':
        return DocCoursesScreen(onNav: _go);
      case 'doc-course-detail':
        return DocCourseDetailScreen(onNav: _go, onBack: () => _go('doc-courses'));
      case 'doc-students':
        return DocStudentsScreen(onBack: () => _go('doc-course-detail'));
      case 'doc-grades':
        return DocGradesScreen(onNav: _go);
      case 'doc-upload-grades':
        return DocUploadGradesScreen(onBack: () => _go('doc-grades'));
      case 'doc-records':
        return DocRecordsScreen(onBack: () => _go('doc-dashboard'));
      case 'doc-lectures':
        return DocLecturesScreen(onNav: _go, onBack: () => _go('doc-courses'));
      case 'doc-upload-lecture':
        return DocUploadLectureScreen(onBack: () => _go('doc-lectures'), onNav: _go);
      case 'doc-chats':
        return DocChatsScreen(onNav: _go);

      // Student Affairs
      case 'sa-dashboard':
        return SADashboardScreen(onNav: _go);
      case 'sa-requests':
        return SARequestsScreen(onNav: _go);
      case 'sa-request-detail':
        return SARequestDetailScreen(onNav: _go, onBack: () => _go('sa-requests'));
      case 'sa-hs-requests':
        return SAHSRequestsScreen(onNav: _go);
      case 'sa-hs-detail':
        return SAHSDetailScreen(onBack: () => _go('sa-hs-requests'));
      case 'sa-military':
        return SAMilitaryScreen(onBack: () => _go('sa-dashboard'));
      case 'sa-search':
        return SAStudentSearchScreen(onBack: () => _go('sa-dashboard'));
      case 'sa-chats':
        return SAChatsScreen(onNav: _go);
      case 'sa-chat':
        return SAChatScreen(
          isStudent: _userRole == UserRole.student,
          onBack: () => _go(_userRole == UserRole.student ? 'student-request-detail' : 'sa-chats'),
        );

      // Admin
      case 'adm-dashboard':
        return AdminDashboardScreen(onNav: _go);
      case 'adm-users':
        return AdminUsersScreen(onNav: _go);
      case 'adm-roles':
        return AdminRolesScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-courses':
        return AdminCoursesScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-departments':
        return AdminDepartmentsScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-requests':
        return const AdminRequestsScreen();
      case 'adm-admission':
        return AdminAdmissionScreen(onNav: _go);
      case 'adm-grades':
        return AdminGradesScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-documents':
        return AdminDocumentsScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-announcements':
        return AdminAnnouncementsScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-ai-kb':
        return AdminAIKBScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-settings':
        return AdminSettingsScreen(onBack: () => _go('adm-dashboard'));
      case 'adm-add-user':
        return AdminAddUserScreen(onBack: () => _go('adm-users'));
      case 'adm-request-requirements':
        return AdminRequestRequirementsScreen(onBack: () => _go('adm-dashboard'));

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
      bottomNavigationBar: tabBar == null ? null : SafeArea(top: false, child: tabBar),
    );
  }
}
