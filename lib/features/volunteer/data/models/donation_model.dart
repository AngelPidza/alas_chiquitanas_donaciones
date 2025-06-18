import '../../domain/entities/donation.dart';

class DonationModel extends Donation {
  const DonationModel({
    required super.id,
    required super.type,
    required super.validationStatus,
    required super.donationDate,
    super.campaignId,
    super.donorId,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id_donacion'],
      type: json['tipo_donacion'] ?? '',
      validationStatus: json['estado_validacion'] ?? '',
      donationDate: DateTime.parse(json['fecha_donacion']),
      campaignId: json['id_campana'],
      donorId: json['id_donante'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_donacion': id,
      'tipo_donacion': type,
      'estado_validacion': validationStatus,
      'fecha_donacion': donationDate.toIso8601String(),
      'id_campana': campaignId,
      'id_donante': donorId,
    };
  }
}
