import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableBiometricScreen extends StatefulWidget {
  const EnableBiometricScreen({super.key});

  @override
  State<EnableBiometricScreen> createState() => _EnableBiometricScreenState();
}

class _EnableBiometricScreenState extends State<EnableBiometricScreen> {
  Future<void> _setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', enabled);
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              const Text(
                '¿Activar inicio con biometría?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _setBiometricEnabled(true),
                child: const Text('Sí, activar biometría'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _setBiometricEnabled(false),
                child: const Text('No, gracias'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
