// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donation_request_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DonationRequestState {

 List<DonationRequest> get donationRequests; bool get isLoadingDonationRequest; String? get errorMessage; String? get successMessage;
/// Create a copy of DonationRequestState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationRequestStateCopyWith<DonationRequestState> get copyWith => _$DonationRequestStateCopyWithImpl<DonationRequestState>(this as DonationRequestState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationRequestState&&const DeepCollectionEquality().equals(other.donationRequests, donationRequests)&&(identical(other.isLoadingDonationRequest, isLoadingDonationRequest) || other.isLoadingDonationRequest == isLoadingDonationRequest)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(donationRequests),isLoadingDonationRequest,errorMessage,successMessage);

@override
String toString() {
  return 'DonationRequestState(donationRequests: $donationRequests, isLoadingDonationRequest: $isLoadingDonationRequest, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $DonationRequestStateCopyWith<$Res>  {
  factory $DonationRequestStateCopyWith(DonationRequestState value, $Res Function(DonationRequestState) _then) = _$DonationRequestStateCopyWithImpl;
@useResult
$Res call({
 List<DonationRequest> donationRequests, bool isLoadingDonationRequest, String? errorMessage, String? successMessage
});




}
/// @nodoc
class _$DonationRequestStateCopyWithImpl<$Res>
    implements $DonationRequestStateCopyWith<$Res> {
  _$DonationRequestStateCopyWithImpl(this._self, this._then);

  final DonationRequestState _self;
  final $Res Function(DonationRequestState) _then;

/// Create a copy of DonationRequestState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? donationRequests = null,Object? isLoadingDonationRequest = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
donationRequests: null == donationRequests ? _self.donationRequests : donationRequests // ignore: cast_nullable_to_non_nullable
as List<DonationRequest>,isLoadingDonationRequest: null == isLoadingDonationRequest ? _self.isLoadingDonationRequest : isLoadingDonationRequest // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _DonationRequestState implements DonationRequestState {
  const _DonationRequestState({final  List<DonationRequest> donationRequests = const [], this.isLoadingDonationRequest = false, this.errorMessage, this.successMessage}): _donationRequests = donationRequests;
  

 final  List<DonationRequest> _donationRequests;
@override@JsonKey() List<DonationRequest> get donationRequests {
  if (_donationRequests is EqualUnmodifiableListView) return _donationRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_donationRequests);
}

@override@JsonKey() final  bool isLoadingDonationRequest;
@override final  String? errorMessage;
@override final  String? successMessage;

/// Create a copy of DonationRequestState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationRequestStateCopyWith<_DonationRequestState> get copyWith => __$DonationRequestStateCopyWithImpl<_DonationRequestState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationRequestState&&const DeepCollectionEquality().equals(other._donationRequests, _donationRequests)&&(identical(other.isLoadingDonationRequest, isLoadingDonationRequest) || other.isLoadingDonationRequest == isLoadingDonationRequest)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_donationRequests),isLoadingDonationRequest,errorMessage,successMessage);

@override
String toString() {
  return 'DonationRequestState(donationRequests: $donationRequests, isLoadingDonationRequest: $isLoadingDonationRequest, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$DonationRequestStateCopyWith<$Res> implements $DonationRequestStateCopyWith<$Res> {
  factory _$DonationRequestStateCopyWith(_DonationRequestState value, $Res Function(_DonationRequestState) _then) = __$DonationRequestStateCopyWithImpl;
@override @useResult
$Res call({
 List<DonationRequest> donationRequests, bool isLoadingDonationRequest, String? errorMessage, String? successMessage
});




}
/// @nodoc
class __$DonationRequestStateCopyWithImpl<$Res>
    implements _$DonationRequestStateCopyWith<$Res> {
  __$DonationRequestStateCopyWithImpl(this._self, this._then);

  final _DonationRequestState _self;
  final $Res Function(_DonationRequestState) _then;

/// Create a copy of DonationRequestState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? donationRequests = null,Object? isLoadingDonationRequest = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_DonationRequestState(
donationRequests: null == donationRequests ? _self._donationRequests : donationRequests // ignore: cast_nullable_to_non_nullable
as List<DonationRequest>,isLoadingDonationRequest: null == isLoadingDonationRequest ? _self.isLoadingDonationRequest : isLoadingDonationRequest // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
