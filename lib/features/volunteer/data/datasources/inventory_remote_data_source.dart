import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/donation_model.dart';
import '../models/shelf_model.dart';
import '../models/warehouse_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<WarehouseModel>> getWarehouses();
  Future<List<ShelfModel>> getShelves();
  Future<List<DonationModel>> getDonations();
  Future<void> updateDonationStatus(int donationId, String status);
  Future<File> downloadExcelReport();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  InventoryRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<List<WarehouseModel>> getWarehouses() async {
    try {
      final response = await dioClient.get('/almacenes');
      final List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((json) => WarehouseModel.fromJson(json)).toList();
    } catch (error) {
      throw ServerFailure(error.toString());
    }
  }

  @override
  Future<List<ShelfModel>> getShelves() async {
    try {
      final response = await dioClient.get('/estantes');
      final List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((json) => ShelfModel.fromJson(json)).toList();
    } catch (error) {
      throw ServerFailure(error.toString());
    }
  }

  @override
  Future<List<DonationModel>> getDonations() async {
    try {
      final response = await dioClient.get('/donaciones');
      final List<dynamic> jsonResponse = response.data;
      return jsonResponse.map((json) => DonationModel.fromJson(json)).toList();
    } catch (error) {
      throw ServerFailure(error.toString());
    }
  }

  @override
  Future<void> updateDonationStatus(int donationId, String status) async {
    print(
      '[InventoryRemoteDataSource] Actualizando estado de donación: $donationId a $status...',
    );
    try {
      await dioClient.patch(
        '/donaciones/estado/$donationId',
        data: {'estado_validacion': status},
      );
    } catch (error) {
      throw ServerFailure(error.toString());
    }
  }

  @override
  Future<File> downloadExcelReport() async {
    try {
      final response = await dioClient.get(
        '/reportes/stock/excel',
        options: Options(responseType: ResponseType.bytes),
      );

      // Guardar el archivo en el dispositivo
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/reporte_stock_$timestamp.xlsx');

      await file.writeAsBytes(response.data);
      return file;
    } catch (error) {
      throw ServerFailure(error.toString());
    }
  }
}
