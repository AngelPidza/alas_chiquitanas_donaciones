import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../models/shelf_model.dart';
import '../models/donation_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<ShelfModel>> getShelves();
  Future<List<DonationModel>> getDonations();
  Future<void> updateDonationStatus(int donationId, String status);
  Future<File> downloadExcelReport();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  static const String baseUrl = 'https://backenddonaciones.onrender.com/api';

  InventoryRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  Map<String, String> _getHeaders() {
    final token = sharedPreferences.getString('token');
    if (token == null) {
      throw const AuthenticationFailure(
        'No se encontró token de autenticación',
      );
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<List<ShelfModel>> getShelves() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/estantes'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ShelfModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('Error al cargar estantes: ${response.statusCode}');
      }
    } catch (e) {
      if (e is AuthenticationFailure) rethrow;
      throw ServerFailure('Error de conexión: $e');
    }
  }

  @override
  Future<List<DonationModel>> getDonations() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/donaciones'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => DonationModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          'Error al cargar donaciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is AuthenticationFailure) rethrow;
      throw ServerFailure('Error de conexión: $e');
    }
  }

  @override
  Future<void> updateDonationStatus(int donationId, String status) async {
    try {
      final response = await client.patch(
        Uri.parse('$baseUrl/donaciones/estado/$donationId'),
        headers: _getHeaders(),
        body: json.encode({'estado_validacion': status}),
      );

      if (response.statusCode != 200) {
        throw ServerFailure(
          'Error al actualizar el estado: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is AuthenticationFailure) rethrow;
      throw ServerFailure('Error de conexión: $e');
    }
  }

  @override
  Future<File> downloadExcelReport() async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) {
        throw const AuthenticationFailure(
          'No se encontró token de autenticación',
        );
      }

      final response = await client.get(
        Uri.parse('$baseUrl/reportes/stock/excel'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/inventario.xlsx';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw ServerFailure(
          'Error al descargar reporte: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is AuthenticationFailure) rethrow;
      throw ServerFailure('Error al descargar: $e');
    }
  }
}
