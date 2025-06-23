import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/campaign.dart';

part 'campaigns_state.freezed.dart';

@freezed
abstract class CampaignsState with _$CampaignsState {
  const factory CampaignsState({
    @Default([]) List<Campaign> campaigns,
    @Default(false) bool isLoadingCampaigns,
    String? errorMessage,
    String? successMessage,
    @Default(false) bool shouldRedirectToLogin, // ← Nuevo campo
  }) = _CampaignsState;
}
