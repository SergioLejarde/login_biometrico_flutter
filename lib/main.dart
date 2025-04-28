import 'package:flutter/material.dart';
import 'package:login_biometrico_flutter/login_screen.dart';
import 'package:login_biometrico_flutter/home_screen.dart';
import 'package:login_biometrico_flutter/articulos_screen.dart';
import 'package:login_biometrico_flutter/ofertas_screen.dart';
import 'package:login_biometrico_flutter/enable_biometric_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Biométrico Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/articulos': (context) => const ArticulosScreen(),
        '/ofertas': (context) => const OfertasScreen(),
        '/enable-biometric': (context) => const EnableBiometricScreen(),
      },
    );
  }
}