import 'package:flutter_donaciones_1/features/donor/home/domain/entities/donation_request.dart';
import 'package:flutter_donaciones_1/features/donor/home/domain/usecases/get_donations_request.dart';
import 'package:flutter_donaciones_1/features/donor/home/presentation/providers/donation_request_state.dart';
import 'package:flutter_donaciones_1/injection_container.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/usecases/usecase.dart';
part 'donation_request_provider.g.dart';

@riverpod
GetDonationsRequest getDonationsRequest(ref) => sl<GetDonationsRequest>();

@riverpod
class DonationRequestNotifier extends _$DonationRequestNotifier {
  @override
  DonationRequestState build() {
    return DonationRequestState();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadDonationRequests()]);
  }

  Future<void> loadDonationRequests() async {
    print('[DonationRequestNotifier] Iniciando carga de solicitudes...');
    state = state.copyWith(isLoadingDonationRequest: true, errorMessage: null);

    final result = await ref.read(getDonationsRequestProvider).call(NoParams());

    result.fold(
      (failure) {
        print(
          '[DonationRequestNotifier] Error al cargar solicitudes: ${failure.message}',
        );
        state = state.copyWith(
          isLoadingDonationRequest: false,
          errorMessage: failure.message,
        );
      },
      (campaigns) {
        print(
          '[DonationRequestNotifierw] Solicitudes cargadas: ${campaigns.length}',
        );
        state = state.copyWith(
          isLoadingDonationRequest: false,
          donationRequests: campaigns,
        );
      },
    );
  }

  Future<void> refreshCampaigns() async {
    print('Token de usuario: ${sl<SharedPreferences>().getString('token')}');
    await Future.wait([loadDonationRequests()]);
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

@riverpod
bool isLoadingDonationRequest(ref) {
  final state = ref.watch(donationRequestNotifierProvider);
  return state.isLoadingCampaigns;
}

@riverpod
List<DonationRequest> donationRequests(ref) {
  return ref.watch(
    donationRequestNotifierProvider.select((state) => state.donationRequests),
  );
}
