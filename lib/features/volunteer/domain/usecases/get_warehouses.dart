import 'package:dartz/dartz.dart';
import 'package:flutter_donaciones_1/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/warehouse.dart';
import '../repositories/inventory_repository.dart';

class GetWarehouses extends UseCase<List<Warehouse>, NoParams> {
  final InventoryRepository repository;

  GetWarehouses(this.repository);
  @override
  Future<Either<Failure, List<Warehouse>>> call(NoParams params) {
    return repository.getWarehouses();
  }
}
