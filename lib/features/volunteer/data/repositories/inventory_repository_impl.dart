import 'package:dartz/dartz.dart';
import '/features/volunteer/domain/entities/warehouse.dart';
import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shelf.dart';
import '../../domain/entities/donation.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;

  InventoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Warehouse>>> getWarehouses() async {
    try {
      return remoteDataSource.getWarehouses().then(
        (warehouses) => Right(warehouses),
      );
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Shelf>>> getShelves() async {
    try {
      final shelves = await remoteDataSource.getShelves();
      return Right(shelves);
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Donation>>> getDonations() async {
    try {
      final donations = await remoteDataSource.getDonations();
      return Right(donations);
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateDonationStatus(
    int donationId,
    String status,
  ) async {
    try {
      await remoteDataSource.updateDonationStatus(donationId, status);
      return const Right(null);
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, File>> downloadExcelReport() async {
    try {
      final file = await remoteDataSource.downloadExcelReport();
      return Right(file);
    } on AuthenticationFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }
}
