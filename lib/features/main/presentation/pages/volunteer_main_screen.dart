import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_donaciones_1/features/auth/presentation/pages/login_type_screen.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/dashboard_screen.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/inventary_screen.dart';
import 'package:flutter_donaciones_1/features/volunteer/presentation/pages/volunteer_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerMainScreen extends StatefulWidget {
  const VolunteerMainScreen({super.key});

  @override
  VolunteerMainScreenState createState() => VolunteerMainScreenState();
}

class VolunteerMainScreenState extends State<VolunteerMainScreen> {
  int _currentIndex = 0;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final token = prefs.getString('token');

    if (userId == null || token == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://backenddonaciones.onrender.com/api/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _userName = userData['NombreCompleto'];
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      VolunteerDashboardScreen(),
      InventoryScreen(),
      VolunteerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Voluntario: ${_userName ?? "Usuario"}'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
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
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Color(0xFF003566),
        selectedItemColor: Color(0xFFFFC300),
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
