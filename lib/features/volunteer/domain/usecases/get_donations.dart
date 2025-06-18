import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/donation.dart';
import '../repositories/inventory_repository.dart';

class GetDonations extends UseCase<List<Donation>, NoParams> {
  final InventoryRepository repository;

  GetDonations(this.repository);

  @override
  Future<Either<Failure, List<Donation>>> call(NoParams params) async {
    return await repository.getDonations();
  }
}
