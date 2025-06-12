import 'package:flutter/material.dart';
import 'package:flutter_donaciones_1/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_donaciones_1/features/auth/presentation/pages/volunteer_login_screen.dart';

class LoginTypeScreen extends StatelessWidget {
  const LoginTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000814),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200, // Puedes ajustar el tamaño general del círculo aquí
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFFFC300),
                  shape: BoxShape.circle,
                ),
                //Meter una imagen
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/alas.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'App de Donaciones',
                style: TextStyle(fontSize: 18, color: Color(0xFFFFD60A)),
              ),
              SizedBox(height: 48),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen(userType: 'donante'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Color(0xFFFFC300),
                        ),
                        child: Text(
                          'Soy Donante',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000814),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VolunteerLoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Soy Voluntario',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000814),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
