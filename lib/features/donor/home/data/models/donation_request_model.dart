// {
//     "id_solicitud": 20,
//     "id_donante": 1,
//     "donante": "Carlos Gómez Vargas",
//     "Ubicacion": "37.421998, -122.084000",
//     "Detalle_solicitud": "Detalle de solicitud",
//     "latitud": 37.4219983,
//     "longitud": -122.084,
//     "foto_url": "http://backenddonaciones.onrender.com/api/imagenes-solicitud-recogida/6859468bb19fab0e05675a7b"
// },
import '../../domain/entities/donation_request.dart';

class DonationRequestModel extends DonationRequest {
  const DonationRequestModel({
    required super.requestId,
    required super.donorId,
    required super.donorName,
    required super.location,
    required super.requestDetails,
    required super.latitude,
    required super.longitude,
    required super.imageUrl,
  });

  factory DonationRequestModel.fromJson(Map<String, dynamic> json) {
    return DonationRequestModel(
      requestId: json['id_solicitud'],
      donorId: json['id_donante'],
      donorName: json['donante'],
      location: json['Ubicacion'] ?? '',
      requestDetails: json['Detalle_solicitud'] ?? '',
      latitude: json['latitud'] ?? 0.0,
      longitude: json['longitud'] ?? 0.0,
      imageUrl: json['foto_url'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'id_solicitud': requestId,
    'id_donante': donorId,
    'donante': donorName,
    'Ubicacion': location,
    'Detalle_solicitud': requestDetails,
    'latitud': latitude,
    'longitud': longitude,
    'foto_url': imageUrl,
  };
}
