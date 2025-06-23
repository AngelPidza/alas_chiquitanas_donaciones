import '../../domain/entities/campaign.dart';

/*
    {
        "id_campana": 1,
        "nombre_campana": "Campaña de Reciclaje",
        "descripcion": "Reciclaje de ropa usada para familias necesitadas",
        "fecha_inicio": "2025-06-01T00:00:00.000Z",
        "fecha_fin": "2025-06-30T00:00:00.000Z",
        "organizador": "Juan Pérez",
        "imagen_url": null
    },
*/
class CampaignModel extends Campaign {
  const CampaignModel({
    required super.id,
    required super.name,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.organizer,
    super.imageUrl,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id_campana'],
      name: json['nombre_campana'],
      description: json['descripcion'],
      startDate: DateTime.parse(json['fecha_inicio']),
      endDate: DateTime.parse(json['fecha_fin']),
      organizer: json['organizador'],
      imageUrl: json['imagen_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_campana': id,
      'nombre_campana': name,
      'descripcion': description,
      'fecha_inicio': startDate.toIso8601String(),
      'fecha_fin': endDate.toIso8601String(),
      'organizador': organizer,
      'imagen_url': imageUrl,
    };
  }
}
