import 'package:dartz/dartz.dart';
import '../entities/campaign.dart';
import '/core/error/failures.dart';

abstract class DonorHomeRepository {
  Future<Either<Failure, List<Campaign>>> getCampaigns();
}
