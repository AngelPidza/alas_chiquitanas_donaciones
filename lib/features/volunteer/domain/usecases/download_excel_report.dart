import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/inventory_repository.dart';

class DownloadExcelReport extends UseCase<File, NoParams> {
  final InventoryRepository repository;

  DownloadExcelReport(this.repository);

  @override
  Future<Either<Failure, File>> call(NoParams params) async {
    return await repository.downloadExcelReport();
  }
}
