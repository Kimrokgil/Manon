import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:man_on/firestore_service.dart';
import 'package:man_on/screens/find_team_screen.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/logined_screen.dart';
import 'screens/create_team_screen.dart';
import 'screens/manage_position_screen.dart'; // 이 줄을 추가
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirestoreService firestoreService = FirestoreService();
  await firestoreService.addFormations();  // 포지션 데이터 추가

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Man On',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/main': (context) => LoginedScreen(), // 로그인 성공 후 이동할 화면
        '/createTeam': (context) => CreateTeamScreen(),
        '/findTeam': (context) => FindTeamScreen(),
        '/managePositions': (context) => ManagePositionScreen(), // 여기를 수정
      },
    );
  }
}
