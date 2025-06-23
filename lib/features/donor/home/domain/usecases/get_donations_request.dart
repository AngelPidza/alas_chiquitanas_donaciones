import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/donation_request.dart';
import '../repositories/donor_home_repository.dart';

class GetDonationsRequest extends UseCase<List<DonationRequest>, NoParams> {
  final DonorHomeRepository repository;

  GetDonationsRequest(this.repository);
  @override
  Future<Either<Failure, List<DonationRequest>>> call(NoParams params) {
    return repository.getDonationRequests();
  }
}
