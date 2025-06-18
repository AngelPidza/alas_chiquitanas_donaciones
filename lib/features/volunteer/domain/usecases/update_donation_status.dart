import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

class UpdateDonationStatus extends UseCase<void, UpdateDonationParams> {
  final InventoryRepository repository;

  UpdateDonationStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateDonationParams params) async {
    return await repository.updateDonationStatus(
      params.donationId,
      params.status,
    );
  }
}

class UpdateDonationParams extends Equatable {
  final int donationId;
  final String status;

  const UpdateDonationParams({required this.donationId, required this.status});

  @override
  List<Object?> get props => [donationId, status];
}
