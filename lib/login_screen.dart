import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricAndLogin();
  }

  Future<void> _checkBiometricAndLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('biometric_enabled') ?? false;

    if (!mounted || !isEnabled) return;

    final isAvailable = await auth.canCheckBiometrics;
    if (isAvailable) {
      final authenticated = await auth.authenticate(
        localizedReason: 'Usa tu huella o rostro para ingresar',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  void _loginManual() async {
    final user = userCtrl.text;
    final pass = passCtrl.text;

    if (user == 'admin' && pass == '1234') {
      Navigator.pushReplacementNamed(context, '/enable-biometric');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o clave incorrectos')),
      );
    }
  }

  void _loginWithBiometrics() async {
    final isAvailable = await auth.canCheckBiometrics;
    if (!mounted) return;

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometría no disponible en este dispositivo')),
      );
      return;
    }

    final authenticated = await auth.authenticate(
      localizedReason: 'Autentícate con tu huella o rostro',
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (authenticated && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              const Text(
                'Inicio de Sesión',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: userCtrl,
                decoration: const InputDecoration(labelText: 'Usuario'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loginManual,
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.fingerprint, color: Colors.teal),
                label: const Text('Iniciar con biometría'),
                onPressed: _loginWithBiometrics,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
