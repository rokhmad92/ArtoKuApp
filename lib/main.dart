import 'package:flutter/material.dart';
import 'package:artoku/pages/auth/login.dart';
import 'package:artoku/pages/auth/register.dart';
import 'package:artoku/pages/intro.dart';
import 'package:artoku/pages/reconnect.dart';
import 'package:artoku/pages/splash.dart';
import 'package:artoku/widget/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // fullScreen
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
    //     overlays: [
    //       SystemUiOverlay.bottom,
    //     ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: settingTheme(),
      initialRoute: '/', // URL Pertama kali di kunjungi saat buka aplikasi
      routes: {
        '/': (context) => const Splash(),
        'intro': (context) => const Intro(),
        'login': (context) => const Login(),
        'register': (context) => const Register(),
        'userPage': (context) => const BottomBar(),
        'reconnect': (context) => const Reconnect(),
      },
    );
  }

  ThemeData settingTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFFF38181),
      secondaryHeaderColor: const Color(0xFF73BBA3),
      highlightColor: Colors.blue, // button color
      fontFamily: 'Roboto',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEAFFD0),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(color: Colors.black)),
      ),
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 21, color: Colors.white),
        titleSmall: TextStyle(
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.normal),
        displayLarge: TextStyle(fontSize: 20, color: Colors.black87),
        displayMedium: TextStyle(fontSize: 17, color: Colors.black87),
        displaySmall: TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }
}
