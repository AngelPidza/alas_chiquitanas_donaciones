import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/donation_request_model.dart';
import '../models/campaign_model.dart';
import '/core/network/dio_client.dart';

abstract class DonorHomeRemoteDataSource {
  Future<List<CampaignModel>> getCampaigns();
  Future<List<DonationRequestModel>> getDonationRequests();
}

class DonorHomeRemoteDataSourceImpl implements DonorHomeRemoteDataSource {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  DonorHomeRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  @override
  Future<List<CampaignModel>> getCampaigns() async {
    final response = await dioClient.get('/campanas');
    final List<dynamic> jsonResponse = response.data;
    return jsonResponse.map((json) => CampaignModel.fromJson(json)).toList();
  }

  @override
  Future<List<DonationRequestModel>> getDonationRequests() async {
    final response = await dioClient.get('/solicitudesRecoleccion');
    final List<dynamic> jsonResponse = response.data;
    return jsonResponse
        .map((json) => DonationRequestModel.fromJson(json))
        .toList();
  }
}
