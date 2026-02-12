import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: EcoHeroApp(),
    ),
  );
}

class EcoHeroApp extends StatelessWidget {
  const EcoHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '에코 히어로 한글 특공대',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.juaTextTheme(), // 아이들에게 친숙한 폰트 적용
      ),
      home: const PlaceholderScreen(),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                '에코 히어로 한글 특공대',
                style: GoogleFonts.jua(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '환경을 구하는 한글 공부 여행!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
