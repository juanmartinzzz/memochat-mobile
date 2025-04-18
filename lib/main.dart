import 'package:memochat/screens/main_screen.dart';

import 'integrations/supabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  await SupabaseService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'MemoChat AI',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.outfitTextTheme(),
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF38855D), // Brand green
            onPrimary: const Color(0xFFFFFFFF), // White
            secondary: const Color(0xFFFFD379), // Brand yellow/gold
            tertiary: const Color(0xFF994058), // Brand burgundy
          ),
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}