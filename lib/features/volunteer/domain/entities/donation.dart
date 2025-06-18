import 'package:equatable/equatable.dart';

class Donation extends Equatable {
  final int id;
  final String type;
  final String validationStatus;
  final DateTime donationDate;
  final int? campaignId;
  final int? donorId;

  const Donation({
    required this.id,
    required this.type,
    required this.validationStatus,
    required this.donationDate,
    this.campaignId,
    this.donorId,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    validationStatus,
    donationDate,
    campaignId,
    donorId,
  ];
}
