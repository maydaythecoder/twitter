import 'package:flutter/material.dart';
import 'package:twitter/config/theme.dart';
import 'package:twitter/screens/home/home_screen.dart';

class TwitterApp extends StatelessWidget {
  const TwitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Twitter Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(title: 'Twitter Clone'),
    );
  }
}
