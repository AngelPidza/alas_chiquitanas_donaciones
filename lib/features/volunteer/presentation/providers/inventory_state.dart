import 'package:flutter_donaciones_1/features/volunteer/domain/entities/warehouse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/shelf.dart';
import '../../domain/entities/donation.dart';

part 'inventory_state.freezed.dart';

@freezed
abstract class InventoryState with _$InventoryState {
  const factory InventoryState({
    @Default([]) List<Warehouse> warehouses,
    @Default([]) List<Shelf> shelves,
    @Default([]) List<Donation> donations,
    @Default(true) bool isLoadingShelves,
    @Default(true) bool isLoadingDonations,
    @Default(false) bool isLoadingWarehouses,
    @Default(false) bool isDownloading,
    String? errorMessage,
    String? successMessage,
  }) = _InventoryState;
}
