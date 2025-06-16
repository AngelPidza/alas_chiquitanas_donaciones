import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/article_detail_screen.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/shelf_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  // Colores del sistema de diseño
  static const Color primaryDark = Color(0xFF0D1B2A);
  static const Color primaryBlue = Color(0xFF1B263B);
  static const Color accentBlue = Color(0xFF415A77);
  static const Color lightBlue = Color(0xFF778DA9);
  static const Color cream = Color(0xFFE0E1DD);
  static const Color accent = Color(0xFFFFB700);
  static const Color white = Color(0xFFFFFFFE);
  static const Color errorColor = Color(0xFFE63946);
  static const Color successColor = Color(0xFF2A9D8F);

  List<dynamic> shelves = [];
  List<dynamic> donations = []; // Nueva lista para donaciones
  bool isLoading = true;
  bool isDownloading = false;
  late TabController _tabController;

  // Controlador de animación simple
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initAnimations();
    _loadShelves();
    _loadDonations(); // Nuevo método para cargar donaciones
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadShelves() async {
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
        Uri.parse('https://backenddonaciones.onrender.com/api/estantes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          shelves = json.decode(response.body);
          isLoading = false;
        });

        // Iniciar animación cuando los datos están cargados
        _fadeController.forward();
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Error al cargar estantes');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Error de conexión');
    }
  }

  Future<void> _loadDonations() async {
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
        Uri.parse('https://backenddonaciones.onrender.com/api/donaciones'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          donations = json.decode(response.body);
        });
        print(donations);
      } else {
        _showErrorSnackBar('Error al cargar donaciones');
      }
    } catch (e) {
      _showErrorSnackBar('Error de conexión');
    }
  }

  Future<void> _downloadExcelReport() async {
    if (isDownloading) return;

    setState(() {
      isDownloading = true;
    });

    HapticFeedback.lightImpact();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isDownloading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/reportes/stock/excel',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/inventario.xlsx';
        print('Ruta del archivo: $filePath');
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        _showSuccessSnackBar('Reporte descargado exitosamente');
        OpenFile.open(filePath);
      } else {
        _showErrorSnackBar('Error al descargar reporte');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _navigateToShelfDetail(int shelfId) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ShelfDetailScreen(shelfId: shelfId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [cream, white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryDark.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Cargando inventario...',
                style: TextStyle(
                  fontSize: 16,
                  color: accentBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cream,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 160,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 107, left: 30),
                title: const Text(
                  'Inventario',
                  style: TextStyle(fontWeight: FontWeight.w700, color: white),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryDark, primaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isDownloading ? null : _downloadExcelReport,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: isDownloading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    accent,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.download_rounded,
                                color: accent,
                                size: 20,
                              ),
                      ),
                    ),
                  ),
                ),
              ],

              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(
                  kToolbarHeight + 1,
                ), // altura del TabBar + línea
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.3), // Línea divisoria
                    ),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: accent,
                      indicatorWeight: 3,
                      labelColor: white,
                      unselectedLabelColor: white.withOpacity(0.7),
                      tabs: const [
                        Tab(icon: Icon(Icons.shelves), text: 'Estantes'),
                        Tab(icon: Icon(Icons.inventory), text: 'Donaciones'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
          //Poner una linea de separación
        },
        body: TabBarView(
          controller: _tabController,
          children: [_buildShelvesView(), _buildDonationsView()],
        ),
      ),
    );
  }

  Widget _buildShelvesView() {
    if (shelves.isEmpty) {
      return FadeTransition(opacity: _fadeAnimation, child: _buildEmptyState());
    }

    return RefreshIndicator(
      onRefresh: () async {
        _fadeController.reset();
        await _loadShelves();
      },
      color: accent,
      backgroundColor: white,
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: shelves.length,
        itemBuilder: (context, index) {
          final shelf = shelves[index];
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildShelfCard(shelf),
          );
        },
      ),
    );
  }

  Widget _buildDonationsView() {
    if (donations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryDark.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.inventory_2_rounded, size: 64, color: lightBlue),
                  SizedBox(height: 16),
                  Text(
                    'No hay donaciones registradas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryDark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las donaciones aparecerán aquí cuando se registren',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: lightBlue),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDonations,
      color: accent,
      backgroundColor: white,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return _buildDonationCard(donation, index);
        },
      ),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> donation, int index) {
    // Formatear la fecha
    String formattedDate = '';
    if (donation['fecha_donacion'] != null) {
      try {
        DateTime date = DateTime.parse(donation['fecha_donacion']);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedDate = 'Fecha no válida';
      }
    }

    // Determinar el color del estado
    Color getStatusColor(String? status) {
      switch (status?.toLowerCase()) {
        case 'validado':
          return successColor;
        case 'pendiente':
          return accent;
        case 'rechazado':
          return errorColor;
        default:
          return lightBlue;
      }
    }

    // Determinar el icono según el tipo de donación
    IconData getDonationIcon(String? type) {
      switch (type?.toLowerCase()) {
        case 'dinero':
          return Icons.attach_money_rounded;
        case 'especie':
          return Icons.inventory_2_rounded;
        default:
          return Icons.volunteer_activism_rounded;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            // Aquí puedes agregar tu funcionalidad de navegación
            print('Donación clickeada: ${donation['id_donacion']}');
            bool type = donation['tipo_donacion'].trim() == 'especie';
            if (!type) return;
            _navigateToArticleDetail(donation['id_donacion']);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icono de la donación
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    getDonationIcon(donation['tipo_donacion']),
                    color: accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Información de la donación
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Donación #${donation['id_donacion'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                donation['estado_validacion'],
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: getStatusColor(
                                  donation['estado_validacion'],
                                ).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              donation['estado_validacion']?.toUpperCase() ??
                                  'SIN ESTADO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: getStatusColor(
                                  donation['estado_validacion'],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo: ${donation['tipo_donacion']?.toUpperCase() ?? 'No especificado'}',
                        style: const TextStyle(color: accentBlue, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fecha: $formattedDate',
                        style: const TextStyle(color: lightBlue, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Campaña: #${donation['id_campana'] ?? 'N/A'} • Donante: #${donation['id_donante'] ?? 'N/A'}',
                        style: const TextStyle(color: lightBlue, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Menú de estado
                PopupMenuButton<String>(
                  onSelected: (String newStatus) {
                    _updateDonationStatus(
                      donation['id_donacion'],
                      newStatus,
                      index,
                    );
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'pendiente',
                      child: Row(
                        children: [
                          Icon(Icons.pending, color: accent, size: 18),
                          SizedBox(width: 8),
                          Text('Pendiente'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'validado',
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: successColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Validado'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'rechazado',
                      child: Row(
                        children: [
                          Icon(Icons.cancel, color: errorColor, size: 18),
                          SizedBox(width: 8),
                          Text('Rechazado'),
                        ],
                      ),
                    ),
                  ],
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: lightBlue,
                      size: 16,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToArticleDetail(int articleId) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ArticleDetailScreen(articleId: articleId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // Método para actualizar el estado de la donación
  Future<void> _updateDonationStatus(
    int donationId,
    String newStatus,
    int index,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _showErrorSnackBar('No se encontró token de autenticación');
      return;
    }

    try {
      HapticFeedback.lightImpact();

      final response = await http.patch(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/donaciones/estado/$donationId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'estado_validacion': newStatus}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Actualizar el estado local
        setState(() {
          donations[index]['estado_validacion'] = newStatus;
        });

        _showSuccessSnackBar(
          'Estado actualizado a: ${newStatus.toUpperCase()}',
        );
      } else {
        _showErrorSnackBar('Error al actualizar el estado');
      }
    } catch (e) {
      _showErrorSnackBar('Error de conexión: $e');
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryDark.withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.inventory_2_rounded, size: 64, color: lightBlue),
                SizedBox(height: 16),
                Text(
                  'No hay estantes disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Los estantes aparecerán aquí cuando estén configurados',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: lightBlue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShelfCard(Map<String, dynamic> shelf) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToShelfDetail(shelf['id_estante']),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shelves, size: 20, color: accent),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: Text(
                    shelf['nombre'] ?? 'Estante sin nombre',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryDark,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${shelf['cantidad_filas']} × ${shelf['cantidad_columnas']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: lightBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
