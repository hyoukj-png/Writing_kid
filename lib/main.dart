import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writing_kid/features/theme/presentation/theme_selection_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:writing_kid/core/storage/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 로컬 저장소 초기화
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // 여기서 초기화된 prefs를 주입
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const EcoHeroApp(),
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
        textTheme: GoogleFonts.juaTextTheme(),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      home: const ThemeSelectionScreen(),
    );
  }
}
