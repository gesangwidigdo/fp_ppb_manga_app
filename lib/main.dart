import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb_manga_app/firebase_options.dart';
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
    return MaterialApp(
      title: 'OtakuLib',
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
      home: RootPage(),
      routes: {

      },
    );
  }
}
