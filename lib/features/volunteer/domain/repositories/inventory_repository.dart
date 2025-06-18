import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/error/failures.dart';
import '../entities/shelf.dart';
import '../entities/donation.dart';
import '../entities/warehouse.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<Warehouse>>> getWarehouses();
  Future<Either<Failure, List<Shelf>>> getShelves();
  Future<Either<Failure, List<Donation>>> getDonations();
  Future<Either<Failure, void>> updateDonationStatus(
    int donationId,
    String status,
  );
  Future<Either<Failure, File>> downloadExcelReport();
}
