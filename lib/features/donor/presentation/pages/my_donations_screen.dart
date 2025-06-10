import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  @override
  MyDonationsScreenState createState() => MyDonationsScreenState();
}

class MyDonationsScreenState extends State<MyDonationsScreen> {
  List<dynamic> donations = [];
  List<Map<String, dynamic>> groupedDonations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final donanteId = prefs.getInt('donante_id');
      final token = prefs.getString('token');

      if (donanteId == null || token == null) return;

      final response = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/donantes/$donanteId/donaciones',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final rawDonations = json.decode(response.body);
        setState(() {
          donations = rawDonations;
          groupedDonations = _groupDonations(rawDonations);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar donaciones')));
    }
  }

  List<Map<String, dynamic>> _groupDonations(List<dynamic> rawDonations) {
    Map<int, Map<String, dynamic>> grouped = {};

    for (var donation in rawDonations) {
      int donationId = donation['id_donacion_especie'];

      if (!grouped.containsKey(donationId)) {
        grouped[donationId] = {
          'id_donacion_especie': donationId,
          'nombre_articulo':
              donation['nombre_articulo'] ?? 'Artículo sin nombre',
          'cantidad_total': donation['cantidad'] ?? 0,
          'cantidad_restante_total':
              donation['cantidad_restante'] ?? 0, // Solo tomar el valor una vez
          'distribuciones': <Map<String, dynamic>>[],
          'has_distributions': false,
        };
      }

      // Si tiene paquete, es una distribución
      if (donation['nombre_paquete'] != null && donation['ubicacion'] != null) {
        grouped[donationId]!['has_distributions'] = true;

        // Verificar si ya existe esta distribución para evitar duplicados
        bool distributionExists =
            (grouped[donationId]!['distribuciones'] as List).any(
              (dist) =>
                  dist['nombre_paquete'] == donation['nombre_paquete'] &&
                  dist['ubicacion'] == donation['ubicacion'],
            );

        if (!distributionExists) {
          (grouped[donationId]!['distribuciones'] as List).add({
            'nombre_paquete': donation['nombre_paquete'],
            'ubicacion': donation['ubicacion'],
            'cantidad_restante': donation['cantidad_restante'] ?? 0,
          });
        }
      }
    }

    return grouped.values.toList();
  }

  Color _getStatusColor(double progress) {
    if (progress <= 0.2) return Colors.red;
    if (progress <= 0.6) return Colors.orange;
    return Colors.green;
  }

  String _getStatusText(double progress) {
    if (progress <= 0.2) return "Crítico";
    if (progress <= 0.6) return "En proceso";
    return "Disponible";
  }

  IconData _getStatusIcon(double progress) {
    if (progress <= 0.2) return Icons.warning;
    if (progress <= 0.6) return Icons.hourglass_empty;
    return Icons.check_circle;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC300)),
        ),
      );
    }

    if (groupedDonations.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Color(0xFFFFC300),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.volunteer_activism,
                  size: 64,
                  color: Color(0xFF000814),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'No tienes donaciones registradas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003566),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '¡Empieza a ayudar con tu primera donación!',
                style: TextStyle(fontSize: 16, color: Color(0xFF003566)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Header con estadísticas
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF000814), Color(0xFF003566)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${groupedDonations.length}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC300),
                      ),
                    ),
                    Text(
                      'Donaciones\nRealizadas',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                Container(height: 40, width: 1, color: Colors.white24),
                Column(
                  children: [
                    Icon(Icons.favorite, size: 32, color: Color(0xFFFFC300)),
                    Text(
                      'Impacto\nGenerado',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de donaciones agrupadas
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadDonations,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: groupedDonations.length,
                itemBuilder: (context, index) {
                  final donation = groupedDonations[index];
                  final totalQuantity = (donation['cantidad_total'] as num)
                      .toDouble();
                  final remainingQuantity =
                      (donation['cantidad_restante_total'] as num).toDouble();
                  final usedQuantity = totalQuantity - remainingQuantity;
                  final progress = totalQuantity > 0
                      ? remainingQuantity / totalQuantity
                      : 0.0;
                  final statusColor = _getStatusColor(progress);
                  final distributions =
                      donation['distribuciones'] as List<Map<String, dynamic>>;
                  final hasDistributions =
                      donation['has_distributions'] as bool;

                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.white, Color(0xFFFAFAFA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header del producto
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFFC300),
                                        Color(0xFFFFD60A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(
                                          0xFFFFC300,
                                        ).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.inventory_2,
                                    color: Color(0xFF000814),
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        donation['nombre_articulo'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000814),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFF003566,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          hasDistributions
                                              ? 'Distribuido en ${distributions.length} destino${distributions.length > 1 ? 's' : ''}'
                                              : 'Pendiente de distribución',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF003566),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: statusColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getStatusIcon(progress),
                                        size: 16,
                                        color: statusColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _getStatusText(progress),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Información de impacto y destinos
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF003566).withOpacity(0.05),
                                    Color(0xFF000814).withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color(0xFF003566).withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        hasDistributions
                                            ? Icons.location_on
                                            : Icons.schedule,
                                        color: Color(0xFFFFC300),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        hasDistributions
                                            ? 'Destinos de tu donación'
                                            : 'Estado de tu donación',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF003566),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),

                                  // Mostrar destinos o estado pendiente
                                  if (hasDistributions)
                                    ...distributions
                                        .map(
                                          (dist) => Container(
                                            margin: EdgeInsets.only(bottom: 8),
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(
                                                  0xFF003566,
                                                ).withOpacity(0.1),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Color(
                                                      0xFF2196F3,
                                                    ).withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.local_shipping,
                                                    size: 16,
                                                    color: Color(0xFF2196F3),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        dist['nombre_paquete'] ??
                                                            'Paquete sin nombre',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                            0xFF000814,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        dist['ubicacion'] ??
                                                            'Ubicación no especificada',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                            0xFF003566,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList()
                                  else
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE0B2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            color: Color(0xFFFF9800),
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Tu donación está siendo preparada para distribución',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF000814),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  SizedBox(height: 16),

                                  // Estadísticas de uso
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          'Donado',
                                          totalQuantity.toInt().toString(),
                                          Icons.volunteer_activism,
                                          Color(0xFF4CAF50),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Utilizado',
                                          usedQuantity.toInt().toString(),
                                          Icons.people_alt,
                                          Color(0xFF2196F3),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Disponible',
                                          remainingQuantity.toInt().toString(),
                                          Icons.inventory,
                                          statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 16),

                            // Barra de progreso mejorada
                            if (totalQuantity > 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Impacto generado',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF003566),
                                        ),
                                      ),
                                      Text(
                                        '${((1 - progress) * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2196F3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xFFE9ECEF),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            color: Color(0xFFE9ECEF),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: (1 - progress).clamp(
                                            0.0,
                                            1.0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF2196F3),
                                                  Color(0xFF4CAF50),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    hasDistributions
                                        ? 'Tu donación está ayudando a personas en necesidad'
                                        : 'Tu donación será distribuida pronto',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
