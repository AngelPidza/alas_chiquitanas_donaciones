import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/error/exceptions.dart';
import '../models/campaign_model.dart';
import '/core/network/dio_client.dart';

abstract class DonorHomeRemoteDataSource {
  Future<List<CampaignModel>> getCampaigns();
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
}
