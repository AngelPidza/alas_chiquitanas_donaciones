// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campaigns_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CampaignsState {

 List<Campaign> get campaigns; bool get isLoadingCampaigns; String? get errorMessage; String? get successMessage; bool get shouldRedirectToLogin;
/// Create a copy of CampaignsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampaignsStateCopyWith<CampaignsState> get copyWith => _$CampaignsStateCopyWithImpl<CampaignsState>(this as CampaignsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampaignsState&&const DeepCollectionEquality().equals(other.campaigns, campaigns)&&(identical(other.isLoadingCampaigns, isLoadingCampaigns) || other.isLoadingCampaigns == isLoadingCampaigns)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&(identical(other.shouldRedirectToLogin, shouldRedirectToLogin) || other.shouldRedirectToLogin == shouldRedirectToLogin));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(campaigns),isLoadingCampaigns,errorMessage,successMessage,shouldRedirectToLogin);

@override
String toString() {
  return 'CampaignsState(campaigns: $campaigns, isLoadingCampaigns: $isLoadingCampaigns, errorMessage: $errorMessage, successMessage: $successMessage, shouldRedirectToLogin: $shouldRedirectToLogin)';
}


}

/// @nodoc
abstract mixin class $CampaignsStateCopyWith<$Res>  {
  factory $CampaignsStateCopyWith(CampaignsState value, $Res Function(CampaignsState) _then) = _$CampaignsStateCopyWithImpl;
@useResult
$Res call({
 List<Campaign> campaigns, bool isLoadingCampaigns, String? errorMessage, String? successMessage, bool shouldRedirectToLogin
});




}
/// @nodoc
class _$CampaignsStateCopyWithImpl<$Res>
    implements $CampaignsStateCopyWith<$Res> {
  _$CampaignsStateCopyWithImpl(this._self, this._then);

  final CampaignsState _self;
  final $Res Function(CampaignsState) _then;

/// Create a copy of CampaignsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? campaigns = null,Object? isLoadingCampaigns = null,Object? errorMessage = freezed,Object? successMessage = freezed,Object? shouldRedirectToLogin = null,}) {
  return _then(_self.copyWith(
campaigns: null == campaigns ? _self.campaigns : campaigns // ignore: cast_nullable_to_non_nullable
as List<Campaign>,isLoadingCampaigns: null == isLoadingCampaigns ? _self.isLoadingCampaigns : isLoadingCampaigns // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,shouldRedirectToLogin: null == shouldRedirectToLogin ? _self.shouldRedirectToLogin : shouldRedirectToLogin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _CampaignsState implements CampaignsState {
  const _CampaignsState({final  List<Campaign> campaigns = const [], this.isLoadingCampaigns = false, this.errorMessage, this.successMessage, this.shouldRedirectToLogin = false}): _campaigns = campaigns;
  

 final  List<Campaign> _campaigns;
@override@JsonKey() List<Campaign> get campaigns {
  if (_campaigns is EqualUnmodifiableListView) return _campaigns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_campaigns);
}

@override@JsonKey() final  bool isLoadingCampaigns;
@override final  String? errorMessage;
@override final  String? successMessage;
@override@JsonKey() final  bool shouldRedirectToLogin;

/// Create a copy of CampaignsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampaignsStateCopyWith<_CampaignsState> get copyWith => __$CampaignsStateCopyWithImpl<_CampaignsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampaignsState&&const DeepCollectionEquality().equals(other._campaigns, _campaigns)&&(identical(other.isLoadingCampaigns, isLoadingCampaigns) || other.isLoadingCampaigns == isLoadingCampaigns)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage)&&(identical(other.shouldRedirectToLogin, shouldRedirectToLogin) || other.shouldRedirectToLogin == shouldRedirectToLogin));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_campaigns),isLoadingCampaigns,errorMessage,successMessage,shouldRedirectToLogin);

@override
String toString() {
  return 'CampaignsState(campaigns: $campaigns, isLoadingCampaigns: $isLoadingCampaigns, errorMessage: $errorMessage, successMessage: $successMessage, shouldRedirectToLogin: $shouldRedirectToLogin)';
}


}

/// @nodoc
abstract mixin class _$CampaignsStateCopyWith<$Res> implements $CampaignsStateCopyWith<$Res> {
  factory _$CampaignsStateCopyWith(_CampaignsState value, $Res Function(_CampaignsState) _then) = __$CampaignsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Campaign> campaigns, bool isLoadingCampaigns, String? errorMessage, String? successMessage, bool shouldRedirectToLogin
});




}
/// @nodoc
class __$CampaignsStateCopyWithImpl<$Res>
    implements _$CampaignsStateCopyWith<$Res> {
  __$CampaignsStateCopyWithImpl(this._self, this._then);

  final _CampaignsState _self;
  final $Res Function(_CampaignsState) _then;

/// Create a copy of CampaignsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? campaigns = null,Object? isLoadingCampaigns = null,Object? errorMessage = freezed,Object? successMessage = freezed,Object? shouldRedirectToLogin = null,}) {
  return _then(_CampaignsState(
campaigns: null == campaigns ? _self._campaigns : campaigns // ignore: cast_nullable_to_non_nullable
as List<Campaign>,isLoadingCampaigns: null == isLoadingCampaigns ? _self.isLoadingCampaigns : isLoadingCampaigns // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,shouldRedirectToLogin: null == shouldRedirectToLogin ? _self.shouldRedirectToLogin : shouldRedirectToLogin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
