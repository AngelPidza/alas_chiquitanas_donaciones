import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/campaign.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../injection_container.dart';
import '../../domain/usecases/get_campaigns.dart';
import 'campaigns_state.dart';

part 'campaigns_provider.g.dart';

@riverpod
GetCampaigns getCampaigns(ref) => sl<GetCampaigns>();

@riverpod
class CampaignsNotifier extends _$CampaignsNotifier {
  @override
  CampaignsState build() {
    // Cargar datos iniciales
    return const CampaignsState();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadCampaigns(), loadDonations()]);
  }

  Future<void> loadCampaigns() async {
    print('[InventoryNotifier] Iniciando carga de campañas...');
    state = state.copyWith(isLoadingCampaigns: true, errorMessage: null);

    final result = await ref.read(getCampaignsProvider).call(NoParams());

    result.fold(
      (failure) {
        print(
          '[CampaignsNotifier] Error al cargar campañas: ${failure.message}',
        );
        state = state.copyWith(
          isLoadingCampaigns: false,
          errorMessage: failure.message,
        );
      },
      (campaigns) {
        print('[CampaignsNotifier] Campañas cargados: ${campaigns.length}');
        state = state.copyWith(isLoadingCampaigns: false, campaigns: campaigns);
      },
    );
  }

  Future<void> loadDonations() async {
    // print('Token de usuario: ${sl<SharedPreferences>().getString('token')}');
    // print('[InventoryNotifier] Iniciando carga de donaciones...');
    // state = state.copyWith(isLoadingDonations: true, errorMessage: null);

    // final result = await ref.read(getDonationsProvider).call(NoParams());

    // result.fold(
    //   (failure) {
    //     print('''[InventoryNotifier]
    //       Error al cargar donaciones: ${failure.message}
    //       ''');
    //     state = state.copyWith(
    //       isLoadingDonations: false,
    //       errorMessage: failure.message,
    //     );
    //   },
    //   (donations) {
    //     print('[InventoryNotifier] Donaciones cargadas: ${donations.length}');
    //     state = state.copyWith(isLoadingDonations: false, donations: donations);
    //   },
    // );
  }

  Future<void> refreshCampaigns() async {
    print('Token de usuario: ${sl<SharedPreferences>().getString('token')}');
    await Future.wait([loadCampaigns(), loadDonations()]);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

// Providers de estado derivados para optimización
@riverpod
bool isLoadingCampaigns(ref) {
  final state = ref.watch(campaignsNotifierProvider);
  return state.isLoadingCampaigns;
}

@riverpod
List<Campaign> campaigns(ref) {
  return ref.watch(
    campaignsNotifierProvider.select((state) => state.campaigns),
  );
}

// @riverpod
// List<Donation> donations(ref) {
//   return ref.watch(
//     inventoryNotifierProvider.select((state) => state.donations),
//   );
// }
