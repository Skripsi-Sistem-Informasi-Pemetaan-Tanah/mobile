import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/util/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  // Todo: Add Widgets Binding
  // Todo: Init Local Storage
  // Todo: Awoit Native Splash
  // Todo: Initialize Firebase
  // Todo: Initialize Authentication

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: DAppTheme.lightTheme,
      darkTheme: DAppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
