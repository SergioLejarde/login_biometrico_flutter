import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ArticulosScreen extends StatefulWidget {
  const ArticulosScreen({super.key});

  @override
  State<ArticulosScreen> createState() => _ArticulosScreenState();
}

class _ArticulosScreenState extends State<ArticulosScreen> {
  List<dynamic> articulos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticulos();
  }

  Future<void> fetchArticulos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.12:1802/articulos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          articulos = decodedData['articulos']; // <<--- CAMBIO IMPORTANTE
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar artículos');
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
      appBar: AppBar(title: const Text('Artículos')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: articulos.length,
              itemBuilder: (context, index) {
                final articulo = articulos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      articulo['urlimagen'] ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                    title: Text(articulo['articulo'] ?? 'Nombre no disponible'),
                    subtitle: Text('Precio: \$${articulo['precio'] ?? 'N/A'}'),
                  ),
                );
              },
            ),
    );
  }
}