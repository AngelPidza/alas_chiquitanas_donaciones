import 'package:equatable/equatable.dart';

class Shelf extends Equatable {
  final int id;
  final String name;
  final int rows;
  final int columns;

  const Shelf({
    required this.id,
    required this.name,
    required this.rows,
    required this.columns,
  });

  @override
  List<Object?> get props => [id, name, rows, columns];
}
