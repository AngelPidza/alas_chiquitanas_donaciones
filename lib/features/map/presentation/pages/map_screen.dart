import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final int campaignId;

  const MapScreen({super.key, required this.campaignId});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<dynamic> collectionPoints = [];
  bool isLoading = true;
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadCollectionPoints();
  }

  Future<void> _loadCollectionPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Token no encontrado')));
        return;
      }

      final response = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/puntos-de-recoleccion/campana/${widget.campaignId}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final points = json.decode(response.body);
        setState(() {
          collectionPoints = points;
          _createMarkers();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar puntos de recolección')),
      );
    }
  }

  void _createMarkers() {
    markers.clear();
    for (int i = 0; i < collectionPoints.length; i++) {
      final point = collectionPoints[i];
      final coordinates = point['direccion'].split(', ');
      if (coordinates.length == 2) {
        final lat = double.tryParse(coordinates[0]);
        final lng = double.tryParse(coordinates[1]);

        if (lat != null && lng != null) {
          markers.add(
            Marker(
              markerId: MarkerId(point['id_punto'].toString()),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: point['nombre_punto'],
                snippet: 'Punto de recolección',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntos de Recolección'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF000814), Color(0xFF001D3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC300)),
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Color(0xFFFFC300),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF000814)),
                      SizedBox(width: 8),
                      Text(
                        '${collectionPoints.length} puntos de recolección encontrados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000814),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: markers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64,
                                color: Color(0xFF003566),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay puntos de recolección disponibles',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF003566),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: markers.first.position,
                            zoom: 12,
                          ),
                          markers: markers,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                ),
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(16),
                    itemCount: collectionPoints.length,
                    itemBuilder: (context, index) {
                      final point = collectionPoints[index];
                      return Container(
                        width: 200,
                        margin: EdgeInsets.only(right: 12),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  point['nombre_punto'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF000814),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Coordenadas: ${point['direccion']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF003566),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
