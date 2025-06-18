import '../../domain/entities/shelf.dart';

class ShelfModel extends Shelf {
  const ShelfModel({
    required super.id,
    required super.name,
    required super.rows,
    required super.columns,
  });

  factory ShelfModel.fromJson(Map<String, dynamic> json) {
    return ShelfModel(
      id: json['id_estante'],
      name: json['nombre'] ?? 'Estante sin nombre',
      rows: json['cantidad_filas'],
      columns: json['cantidad_columnas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_estante': id,
      'nombre': name,
      'cantidad_filas': rows,
      'cantidad_columnas': columns,
    };
  }
}
