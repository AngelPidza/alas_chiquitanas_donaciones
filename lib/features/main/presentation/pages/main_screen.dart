import 'package:flutter/material.dart';
import 'package:flutter_donaciones_1/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_donaciones_1/features/donor/presentation/pages/campaigns_screen.dart';
import 'package:flutter_donaciones_1/features/donor/presentation/pages/my_donations_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('donante_nombre');
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen(userType: 'donante')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [CampaignsScreen(), MyDonationsScreen()];

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${_userName ?? "Usuario"}'),
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
            icon: Icon(Icons.campaign),
            label: 'Campañas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Mis Donaciones',
          ),
        ],
      ),
    );
  }
}
