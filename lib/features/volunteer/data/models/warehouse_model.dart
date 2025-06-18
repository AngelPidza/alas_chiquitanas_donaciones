import '../../domain/entities/warehouse.dart';

class WarehouseModel extends Warehouse {
  const WarehouseModel({
    required super.id,
    required super.name,
    required super.location,
    required super.latitud,
    required super.longitud,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) => WarehouseModel(
    /*
    {
        "id_almacen": 6,
        "nombre_almacen": "Almacen #6",
        "ubicacion": "Av. 7mo Anillo, Calle 1",
        "latitud": null,
        "longitud": null
    },
  */
    id: json['id_almacen'],
    name: json['nombre_almacen'],
    location: json['ubicacion'] ?? '',
    latitud: json['latitud'] ?? 0.0,
    longitud: json['longitud'] ?? 0.0,
  );
}
