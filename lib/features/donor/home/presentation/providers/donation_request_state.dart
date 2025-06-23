import '../../domain/entities/donation_request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_request_state.freezed.dart';

@freezed
abstract class DonationRequestState with _$DonationRequestState {
  const factory DonationRequestState({
    @Default([]) List<DonationRequest> donationRequests,
    @Default(false) bool isLoadingDonationRequest,
    String? errorMessage,
    String? successMessage,
  }) = _DonationRequestState;
}
