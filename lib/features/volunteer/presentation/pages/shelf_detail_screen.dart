import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/article_detail_screen.dart';
import 'package:flutter_donaciones_1/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShelfDetailScreen extends StatefulWidget {
  final int shelfId;

  const ShelfDetailScreen({super.key, required this.shelfId});

  @override
  ShelfDetailScreenState createState() => ShelfDetailScreenState();
}

class ShelfDetailScreenState extends State<ShelfDetailScreen> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShelfItems();
  }

  Future<void> _loadShelfItems() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/inventario/stock/estante/${widget.shelfId}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar items del estante')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Cargando...')),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC300)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Estante ${widget.shelfId}')),
      body: RefreshIndicator(
        onRefresh: _loadShelfItems,
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nombre_articulo'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000814),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item['descripcion'],
                      style: TextStyle(fontSize: 14, color: Color(0xFF003566)),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFC300).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${item['total_restante']} ${item['medida_abreviada']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000814),
                            ),
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailScreen(
                                  articleId: item['id_articulo'],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Ver Detalles',
                            style: TextStyle(
                              color: Color(0xFF003566),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
