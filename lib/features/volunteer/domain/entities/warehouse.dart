// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:equatable/equatable.dart';

class Warehouse extends Equatable {
  /*
    {
        "id_almacen": 6,
        "nombre_almacen": "Almacen #6",
        "ubicacion": "Av. 7mo Anillo, Calle 1",
        "latitud": null,
        "longitud": null
    },
  */

  final int id;
  final String name;
  final String location;
  final double latitud;
  final double longitud;

  const Warehouse({
    required this.id,
    required this.name,
    required this.location,
    required this.latitud,
    required this.longitud,
  });

  @override
  List<Object?> get props => [id, name, location, latitud, longitud];
}
