import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OfertasScreen extends StatefulWidget {
  const OfertasScreen({super.key});

  @override
  State<OfertasScreen> createState() => _OfertasScreenState();
}

class _OfertasScreenState extends State<OfertasScreen> {
  List<dynamic> ofertas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOfertas();
  }

  Future<void> fetchOfertas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.12:1802/articulos'), // Mismo endpoint
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          ofertas = decodedData['articulos']
              .where((item) => item['descuento'] != '0')
              .toList(); // <<--- FILTRAMOS solo las que tengan descuento
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar ofertas');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ofertas')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ofertas.length,
              itemBuilder: (context, index) {
                final oferta = ofertas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      oferta['urlimagen'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                    title: Text(oferta['articulo'] ?? 'Nombre no disponible'),
                    subtitle: Text('Descuento: ${oferta['descuento']}%'),
                  ),
                );
              },
            ),
    );
  }
}