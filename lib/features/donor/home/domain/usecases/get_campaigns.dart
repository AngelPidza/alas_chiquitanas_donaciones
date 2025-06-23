import 'package:dartz/dartz.dart';
import 'package:flutter_donaciones_1/features/donor/home/domain/repositories/donor_home_repository.dart';

import '/core/error/failures.dart';
import '../entities/campaign.dart';

import '/core/usecases/usecase.dart';

class GetCampaigns extends UseCase<List<Campaign>, NoParams> {
  final DonorHomeRepository repository;

  GetCampaigns(this.repository);
  @override
  Future<Either<Failure, List<Campaign>>> call(NoParams params) {
    return repository.getCampaigns();
  }
}
