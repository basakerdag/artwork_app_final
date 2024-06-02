import 'package:artwork_app/common/colors.dart';
import 'package:artwork_app/features/auth/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MY ARTWORK APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldBGColor,
        useMaterial3: true,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData( 
          unselectedItemColor: bottomNavigationUnselected,
          type: BottomNavigationBarType.fixed,
          backgroundColor: bottomNavigationBGColor,
        ),
      ),
      home: const Scaffold(
        backgroundColor: scaffoldBGColor,
        body: WelcomePage(),
      ),
    );
  }
}
