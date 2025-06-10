import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/article_detail_screen.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/inventary_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({super.key});

  @override
  VolunteerDashboardScreenState createState() =>
      VolunteerDashboardScreenState();
}

class VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> {
  int? totalDonations;
  List<dynamic> donationsByMonth = [];
  List<dynamic> stockItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Obtener total de donaciones
      final totalResponse = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/dashboard/total-donaciones',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (totalResponse.statusCode == 200) {
        final totalData = json.decode(totalResponse.body);
        setState(() {
          totalDonations = totalData['total'];
        });
      }

      // Obtener donaciones por mes (año actual)
      final currentYear = DateTime.now().year;
      final monthResponse = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/dashboard/donaciones-por-mes/$currentYear',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (monthResponse.statusCode == 200) {
        setState(() {
          donationsByMonth = json.decode(monthResponse.body);
        });
      }

      // Obtener vista rápida de stock
      final stockResponse = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/inventario/stock',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (stockResponse.statusCode == 200) {
        setState(() {
          stockItems = json.decode(stockResponse.body);
        });
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos del dashboard')),
      );
    }
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

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Donaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003566),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'Total Donaciones',
                          totalDonations?.toString() ?? '0',
                          Icons.volunteer_activism,
                          Color(0xFF4CAF50),
                        ),
                        _buildStatCard(
                          'Este Mes',
                          donationsByMonth.isNotEmpty
                              ? donationsByMonth.last['cantidad'].toString()
                              : '0',
                          Icons.calendar_today,
                          Color(0xFF2196F3),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (donationsByMonth.isNotEmpty)
                      SizedBox(height: 200, child: _buildDonationsChart()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Inventario Rápido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003566),
              ),
            ),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: stockItems.length,
              itemBuilder: (context, index) {
                final item = stockItems[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            articleId: item['id_articulo'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nombre_articulo'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF000814),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${item['total_restante']} ${item['medida_abreviada']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003566),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory,
                                size: 16,
                                color: Color(0xFFFFC300),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${item['cantidad_estimada_por_persona']} ${item['medida_abreviada']}/pers',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF003566),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFC300),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Ver Inventario Completo',
                style: TextStyle(
                  color: Color(0xFF000814),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsChart() {
    // Implementar un gráfico simple con los datos de donationsByMonth
    // Esto es un placeholder - en una app real usarías una librería como charts_flutter
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: donationsByMonth.length,
      itemBuilder: (context, index) {
        final monthData = donationsByMonth[index];
        final monthName = _getMonthName(monthData['mes']);
        final donationCount = monthData['cantidad'];
        final maxCount = donationsByMonth.fold(
          0,
          (max, item) => item['cantidad'] > max ? item['cantidad'] : max,
        );

        return Container(
          width: 60,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(monthName, style: TextStyle(fontSize: 12)),
              SizedBox(height: 4),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: maxCount > 0 ? donationCount / maxCount : 0,
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                donationCount.toString(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Ene';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dic';
      default:
        return '';
    }
  }
}
