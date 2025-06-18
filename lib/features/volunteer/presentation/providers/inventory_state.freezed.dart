// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryState {

 List<Warehouse> get warehouses; List<Shelf> get shelves; List<Donation> get donations; bool get isLoadingShelves; bool get isLoadingDonations; bool get isLoadingWarehouses; bool get isDownloading; String? get errorMessage; String? get successMessage;
/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStateCopyWith<InventoryState> get copyWith => _$InventoryStateCopyWithImpl<InventoryState>(this as InventoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryState&&const DeepCollectionEquality().equals(other.warehouses, warehouses)&&const DeepCollectionEquality().equals(other.shelves, shelves)&&const DeepCollectionEquality().equals(other.donations, donations)&&(identical(other.isLoadingShelves, isLoadingShelves) || other.isLoadingShelves == isLoadingShelves)&&(identical(other.isLoadingDonations, isLoadingDonations) || other.isLoadingDonations == isLoadingDonations)&&(identical(other.isLoadingWarehouses, isLoadingWarehouses) || other.isLoadingWarehouses == isLoadingWarehouses)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(warehouses),const DeepCollectionEquality().hash(shelves),const DeepCollectionEquality().hash(donations),isLoadingShelves,isLoadingDonations,isLoadingWarehouses,isDownloading,errorMessage,successMessage);

@override
String toString() {
  return 'InventoryState(warehouses: $warehouses, shelves: $shelves, donations: $donations, isLoadingShelves: $isLoadingShelves, isLoadingDonations: $isLoadingDonations, isLoadingWarehouses: $isLoadingWarehouses, isDownloading: $isDownloading, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $InventoryStateCopyWith<$Res>  {
  factory $InventoryStateCopyWith(InventoryState value, $Res Function(InventoryState) _then) = _$InventoryStateCopyWithImpl;
@useResult
$Res call({
 List<Warehouse> warehouses, List<Shelf> shelves, List<Donation> donations, bool isLoadingShelves, bool isLoadingDonations, bool isLoadingWarehouses, bool isDownloading, String? errorMessage, String? successMessage
});




}
/// @nodoc
class _$InventoryStateCopyWithImpl<$Res>
    implements $InventoryStateCopyWith<$Res> {
  _$InventoryStateCopyWithImpl(this._self, this._then);

  final InventoryState _self;
  final $Res Function(InventoryState) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? warehouses = null,Object? shelves = null,Object? donations = null,Object? isLoadingShelves = null,Object? isLoadingDonations = null,Object? isLoadingWarehouses = null,Object? isDownloading = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
warehouses: null == warehouses ? _self.warehouses : warehouses // ignore: cast_nullable_to_non_nullable
as List<Warehouse>,shelves: null == shelves ? _self.shelves : shelves // ignore: cast_nullable_to_non_nullable
as List<Shelf>,donations: null == donations ? _self.donations : donations // ignore: cast_nullable_to_non_nullable
as List<Donation>,isLoadingShelves: null == isLoadingShelves ? _self.isLoadingShelves : isLoadingShelves // ignore: cast_nullable_to_non_nullable
as bool,isLoadingDonations: null == isLoadingDonations ? _self.isLoadingDonations : isLoadingDonations // ignore: cast_nullable_to_non_nullable
as bool,isLoadingWarehouses: null == isLoadingWarehouses ? _self.isLoadingWarehouses : isLoadingWarehouses // ignore: cast_nullable_to_non_nullable
as bool,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _InventoryState implements InventoryState {
  const _InventoryState({final  List<Warehouse> warehouses = const [], final  List<Shelf> shelves = const [], final  List<Donation> donations = const [], this.isLoadingShelves = true, this.isLoadingDonations = true, this.isLoadingWarehouses = false, this.isDownloading = false, this.errorMessage, this.successMessage}): _warehouses = warehouses,_shelves = shelves,_donations = donations;
  

 final  List<Warehouse> _warehouses;
@override@JsonKey() List<Warehouse> get warehouses {
  if (_warehouses is EqualUnmodifiableListView) return _warehouses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_warehouses);
}

 final  List<Shelf> _shelves;
@override@JsonKey() List<Shelf> get shelves {
  if (_shelves is EqualUnmodifiableListView) return _shelves;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shelves);
}

 final  List<Donation> _donations;
@override@JsonKey() List<Donation> get donations {
  if (_donations is EqualUnmodifiableListView) return _donations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_donations);
}

@override@JsonKey() final  bool isLoadingShelves;
@override@JsonKey() final  bool isLoadingDonations;
@override@JsonKey() final  bool isLoadingWarehouses;
@override@JsonKey() final  bool isDownloading;
@override final  String? errorMessage;
@override final  String? successMessage;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryStateCopyWith<_InventoryState> get copyWith => __$InventoryStateCopyWithImpl<_InventoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryState&&const DeepCollectionEquality().equals(other._warehouses, _warehouses)&&const DeepCollectionEquality().equals(other._shelves, _shelves)&&const DeepCollectionEquality().equals(other._donations, _donations)&&(identical(other.isLoadingShelves, isLoadingShelves) || other.isLoadingShelves == isLoadingShelves)&&(identical(other.isLoadingDonations, isLoadingDonations) || other.isLoadingDonations == isLoadingDonations)&&(identical(other.isLoadingWarehouses, isLoadingWarehouses) || other.isLoadingWarehouses == isLoadingWarehouses)&&(identical(other.isDownloading, isDownloading) || other.isDownloading == isDownloading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_warehouses),const DeepCollectionEquality().hash(_shelves),const DeepCollectionEquality().hash(_donations),isLoadingShelves,isLoadingDonations,isLoadingWarehouses,isDownloading,errorMessage,successMessage);

@override
String toString() {
  return 'InventoryState(warehouses: $warehouses, shelves: $shelves, donations: $donations, isLoadingShelves: $isLoadingShelves, isLoadingDonations: $isLoadingDonations, isLoadingWarehouses: $isLoadingWarehouses, isDownloading: $isDownloading, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$InventoryStateCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory _$InventoryStateCopyWith(_InventoryState value, $Res Function(_InventoryState) _then) = __$InventoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<Warehouse> warehouses, List<Shelf> shelves, List<Donation> donations, bool isLoadingShelves, bool isLoadingDonations, bool isLoadingWarehouses, bool isDownloading, String? errorMessage, String? successMessage
});




}
/// @nodoc
class __$InventoryStateCopyWithImpl<$Res>
    implements _$InventoryStateCopyWith<$Res> {
  __$InventoryStateCopyWithImpl(this._self, this._then);

  final _InventoryState _self;
  final $Res Function(_InventoryState) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? warehouses = null,Object? shelves = null,Object? donations = null,Object? isLoadingShelves = null,Object? isLoadingDonations = null,Object? isLoadingWarehouses = null,Object? isDownloading = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_InventoryState(
warehouses: null == warehouses ? _self._warehouses : warehouses // ignore: cast_nullable_to_non_nullable
as List<Warehouse>,shelves: null == shelves ? _self._shelves : shelves // ignore: cast_nullable_to_non_nullable
as List<Shelf>,donations: null == donations ? _self._donations : donations // ignore: cast_nullable_to_non_nullable
as List<Donation>,isLoadingShelves: null == isLoadingShelves ? _self.isLoadingShelves : isLoadingShelves // ignore: cast_nullable_to_non_nullable
as bool,isLoadingDonations: null == isLoadingDonations ? _self.isLoadingDonations : isLoadingDonations // ignore: cast_nullable_to_non_nullable
as bool,isLoadingWarehouses: null == isLoadingWarehouses ? _self.isLoadingWarehouses : isLoadingWarehouses // ignore: cast_nullable_to_non_nullable
as bool,isDownloading: null == isDownloading ? _self.isDownloading : isDownloading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
