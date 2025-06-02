import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/firebase_options.dart';
import 'package:fp_ppb_manga_app/pages/login.dart';
import 'package:fp_ppb_manga_app/pages/register.dart';
import 'package:fp_ppb_manga_app/pages/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: 'login', routes: {
      'login': (context) => const LoginPage(),
      'root': (context) => const RootPage(),
      'register': (context) => const RegisterPage(),
    },
      title: 'OtakuLib',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Color(0xFF1D4ED7),
        scaffoldBackgroundColor: const Color(0xFF202939),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181E2A),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF181E2A),
          selectedItemColor: Color(0xFFD9D9D9),
          unselectedItemColor: Color(0xFFD9D9D9),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      // home: LoginPage(),
    );
  }
}
