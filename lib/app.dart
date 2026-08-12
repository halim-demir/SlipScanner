import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/home/presentation/screens/home_screen.dart';

class SlipScannerApp extends StatelessWidget {
  const SlipScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Responsive
    return ScreenUtilInit(
      designSize: const Size(1080, 2400),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child){
        return MaterialApp(
          title: 'Slip Scanner',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.dark,
              surface: const Color(0xFF0F172A),
            ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          ),
          home: const HomeScreen(),
        );
      }
    );
  }
}
