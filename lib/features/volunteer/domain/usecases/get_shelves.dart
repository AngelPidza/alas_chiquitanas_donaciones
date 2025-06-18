import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shelf.dart';
import '../repositories/inventory_repository.dart';

class GetShelves extends UseCase<List<Shelf>, NoParams> {
  final InventoryRepository repository;

  GetShelves(this.repository);

  @override
  Future<Either<Failure, List<Shelf>>> call(NoParams params) async {
    return await repository.getShelves();
  }
}
