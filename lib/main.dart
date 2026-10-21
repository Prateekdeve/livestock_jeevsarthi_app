import 'package:flutter/material.dart';

import 'core/app_theme.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const JeevSarthiApp());
}

class JeevSarthiApp extends StatelessWidget {
  const JeevSarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JeevSarthi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: (context, child) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 410),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.12),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      home: const WelcomeScreen(),
    );
  }
}
