import 'package:dartz/dartz.dart';
import '../entities/campaign.dart';
import '../entities/donation_request.dart';
import '/core/error/failures.dart';

abstract class DonorHomeRepository {
  Future<Either<Failure, List<Campaign>>> getCampaigns();

  Future<Either<Failure, List<DonationRequest>>> getDonationRequests();
}
