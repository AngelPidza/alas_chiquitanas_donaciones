import 'package:equatable/equatable.dart';

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
class Campaign extends Equatable {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String organizer;
  final String? imageUrl;

  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.organizer,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    startDate,
    endDate,
    organizer,
    imageUrl,
  ];
}
