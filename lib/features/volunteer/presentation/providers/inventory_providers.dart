import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:open_file/open_file.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/shelf.dart';
import '../../domain/entities/donation.dart';
import '../../domain/usecases/get_shelves.dart';
import '../../domain/usecases/get_donations.dart';
import '../../domain/usecases/update_donation_status.dart';
import '../../domain/usecases/download_excel_report.dart';
import '../../../../injection_container.dart';
import 'inventory_state.dart';

part 'inventory_providers.g.dart';

// Providers para los casos de uso
@riverpod
GetShelves getShelves(ref) => sl<GetShelves>();

@riverpod
GetDonations getDonations(ref) => sl<GetDonations>();

@riverpod
UpdateDonationStatus updateDonationStatus(ref) => sl<UpdateDonationStatus>();

@riverpod
DownloadExcelReport downloadExcelReport(ref) => sl<DownloadExcelReport>();

// Provider principal del inventario
@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  InventoryState build() {
    // Cargar datos iniciales
    return const InventoryState();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadShelves(), loadDonations()]);
  }

  Future<void> loadShelves() async {
    print('[InventoryNotifier] Iniciando carga de estantes...');
    state = state.copyWith(isLoadingShelves: true, errorMessage: null);

    final result = await ref.read(getShelvesProvider).call(NoParams());

    result.fold(
      (failure) {
        print(
          '[InventoryNotifier] Error al cargar estantes: ${failure.message}',
        );
        state = state.copyWith(
          isLoadingShelves: false,
          errorMessage: failure.message,
        );
      },
      (shelves) {
        print('[InventoryNotifier] Estantes cargados: ${shelves.length}');
        state = state.copyWith(isLoadingShelves: false, shelves: shelves);
      },
    );
  }

  Future<void> loadDonations() async {
    print('[InventoryNotifier] Iniciando carga de donaciones...');
    state = state.copyWith(isLoadingDonations: true, errorMessage: null);

    final result = await ref.read(getDonationsProvider).call(NoParams());

    result.fold(
      (failure) {
        print(
          '[InventoryNotifier] Error al cargar donaciones: ${failure.message}',
        );
        state = state.copyWith(
          isLoadingDonations: false,
          errorMessage: failure.message,
        );
      },
      (donations) {
        print('[InventoryNotifier] Donaciones cargadas: ${donations.length}');
        state = state.copyWith(isLoadingDonations: false, donations: donations);
      },
    );
  }

  Future<void> updateDonationStatusAction(
    int donationId,
    String newStatus,
    int index,
  ) async {
    final result = await ref
        .read(updateDonationStatusProvider)
        .call(UpdateDonationParams(donationId: donationId, status: newStatus));

    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        // Actualizar la lista local de donaciones
        final updatedDonations = List<Donation>.from(state.donations);
        if (index < updatedDonations.length) {
          final oldDonation = updatedDonations[index];
          updatedDonations[index] = Donation(
            id: oldDonation.id,
            type: oldDonation.type,
            validationStatus: newStatus,
            donationDate: oldDonation.donationDate,
            campaignId: oldDonation.campaignId,
            donorId: oldDonation.donorId,
          );
        }

        state = state.copyWith(
          donations: updatedDonations,
          successMessage: 'Estado actualizado a: ${newStatus.toUpperCase()}',
        );

        // Limpiar mensaje de éxito después de un tiempo
        Future.delayed(const Duration(seconds: 2), () {
          state = state.copyWith(successMessage: null);
        });
      },
    );
  }

  Future<void> downloadExcelReportAction() async {
    if (state.isDownloading) return;

    state = state.copyWith(isDownloading: true, errorMessage: null);

    final result = await ref.read(downloadExcelReportProvider).call(NoParams());

    result.fold(
      (failure) {
        state = state.copyWith(
          isDownloading: false,
          errorMessage: failure.message,
        );
      },
      (file) {
        state = state.copyWith(
          isDownloading: false,
          successMessage: 'Reporte descargado exitosamente',
        );

        OpenFile.open(file.path);

        // Limpiar mensaje de éxito
        Future.delayed(const Duration(seconds: 2), () {
          state = state.copyWith(successMessage: null);
        });
      },
    );
  }

  Future<void> refreshInventory() async {
    await Future.wait([loadShelves(), loadDonations()]);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

// Providers de estado derivados para optimización
@riverpod
bool isLoading(ref) {
  final state = ref.watch(inventoryNotifierProvider);
  return state.isLoadingShelves || state.isLoadingDonations;
}

@riverpod
List<Shelf> shelves(ref) {
  return ref.watch(inventoryNotifierProvider.select((state) => state.shelves));
}

@riverpod
List<Donation> donations(ref) {
  return ref.watch(
    inventoryNotifierProvider.select((state) => state.donations),
  );
}

@riverpod
bool isDownloading(ref) {
  return ref.watch(
    inventoryNotifierProvider.select((state) => state.isDownloading),
  );
}
