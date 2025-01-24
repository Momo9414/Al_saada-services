import 'package:android/screens/chat_screen.dart';
import 'package:android/screens/commande_screen.dart';
import 'package:android/screens/home_screen.dart';
import 'package:android/screens/message_screen.dart';
import 'package:android/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  
  runApp(const SaadaApp());
  
  FlutterNativeSplash.remove();
}

class SaadaApp extends StatelessWidget {
  const SaadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saada Services',
      theme: ThemeData(
        primaryColor: const Color(0xFFF97316),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0xFF4B5563)),
          titleTextStyle: TextStyle(
            color: Color(0xFFF97316),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/orders': (context) => const CommandeScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}