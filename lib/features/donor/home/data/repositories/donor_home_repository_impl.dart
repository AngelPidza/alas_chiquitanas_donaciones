import 'package:dartz/dartz.dart';
import 'package:flutter_donaciones_1/core/error/exceptions.dart';

import '../../domain/entities/campaign.dart';
import '/core/error/failures.dart';
import '../../domain/repositories/donor_home_repository.dart';
import '../datasources/donor_home_remote_data_source.dart';

class DonorHomeRepositoryImpl implements DonorHomeRepository {
  final DonorHomeRemoteDataSource remoteDataSource;

  DonorHomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Campaign>>> getCampaigns() async {
    try {
      final campaigns = await remoteDataSource.getCampaigns();
      return Right(campaigns);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TokenExpiredException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error'));
    }
  }
}
