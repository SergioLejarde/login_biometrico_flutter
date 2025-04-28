import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableBiometricScreen extends StatefulWidget {
  const EnableBiometricScreen({super.key});

  @override
  State<EnableBiometricScreen> createState() => _EnableBiometricScreenState();
}

class _EnableBiometricScreenState extends State<EnableBiometricScreen> {
  bool isBiometricEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('biometric_enabled') ?? false;
    if (!mounted) return;
    setState(() {
      isBiometricEnabled = enabled;
    });
  }

  Future<void> _toggleBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      isBiometricEnabled = !isBiometricEnabled;
    });
    await prefs.setBool('biometric_enabled', isBiometricEnabled);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isBiometricEnabled
            ? 'Biometría habilitada'
            : 'Biometría deshabilitada'),
      ),
    );
  }

  Future<void> _checkBiometrics() async {
    final canCheck = await auth.canCheckBiometrics;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Biometría disponible'),
        content: Text(canCheck ? 'Sí, puedes usar biometría' : 'No disponible'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Biometría'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Habilitar biometría'),
              value: isBiometricEnabled,
              onChanged: (value) => _toggleBiometric(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkBiometrics,
              child: const Text('Comprobar disponibilidad de biometría'),
            ),
          ],
        ),
      ),
    );
  }
}