import 'package:dipetakan/bindings/general_bindings.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
// import 'package:dipetakan/features/authentication/screens/signup/signup.dart';
import 'package:dipetakan/util/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: DAppTheme.lightTheme,
      darkTheme: DAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: const LoginScreen(),
    );
  }
}
