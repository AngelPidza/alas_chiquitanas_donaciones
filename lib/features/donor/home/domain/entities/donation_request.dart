import 'package:equatable/equatable.dart';

class DonationRequest extends Equatable {
  final int requestId;
  final int donorId;
  final String donorName;
  final String location;
  final String requestDetails;
  final double latitude;
  final double longitude;
  final String imageUrl;

  const DonationRequest({
    required this.requestId,
    required this.donorId,
    required this.donorName,
    required this.location,
    required this.requestDetails,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    requestId,
    donorId,
    donorName,
    location,
    requestDetails,
    latitude,
    longitude,
    imageUrl,
  ];
}
