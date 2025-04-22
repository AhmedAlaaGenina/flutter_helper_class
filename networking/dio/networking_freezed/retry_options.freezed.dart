// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retry_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RetryOptions {

 int get maxRetries; Duration get retryDelay;
/// Create a copy of RetryOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetryOptionsCopyWith<RetryOptions> get copyWith => _$RetryOptionsCopyWithImpl<RetryOptions>(this as RetryOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetryOptions&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.retryDelay, retryDelay) || other.retryDelay == retryDelay));
}


@override
int get hashCode => Object.hash(runtimeType,maxRetries,retryDelay);

@override
String toString() {
  return 'RetryOptions(maxRetries: $maxRetries, retryDelay: $retryDelay)';
}


}

/// @nodoc
abstract mixin class $RetryOptionsCopyWith<$Res>  {
  factory $RetryOptionsCopyWith(RetryOptions value, $Res Function(RetryOptions) _then) = _$RetryOptionsCopyWithImpl;
@useResult
$Res call({
 int maxRetries, Duration retryDelay
});




}
/// @nodoc
class _$RetryOptionsCopyWithImpl<$Res>
    implements $RetryOptionsCopyWith<$Res> {
  _$RetryOptionsCopyWithImpl(this._self, this._then);

  final RetryOptions _self;
  final $Res Function(RetryOptions) _then;

/// Create a copy of RetryOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxRetries = null,Object? retryDelay = null,}) {
  return _then(_self.copyWith(
maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,retryDelay: null == retryDelay ? _self.retryDelay : retryDelay // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// @nodoc


class _RetryOptions implements RetryOptions {
  const _RetryOptions({required this.maxRetries, required this.retryDelay});
  

@override final  int maxRetries;
@override final  Duration retryDelay;

/// Create a copy of RetryOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetryOptionsCopyWith<_RetryOptions> get copyWith => __$RetryOptionsCopyWithImpl<_RetryOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetryOptions&&(identical(other.maxRetries, maxRetries) || other.maxRetries == maxRetries)&&(identical(other.retryDelay, retryDelay) || other.retryDelay == retryDelay));
}


@override
int get hashCode => Object.hash(runtimeType,maxRetries,retryDelay);

@override
String toString() {
  return 'RetryOptions(maxRetries: $maxRetries, retryDelay: $retryDelay)';
}


}

/// @nodoc
abstract mixin class _$RetryOptionsCopyWith<$Res> implements $RetryOptionsCopyWith<$Res> {
  factory _$RetryOptionsCopyWith(_RetryOptions value, $Res Function(_RetryOptions) _then) = __$RetryOptionsCopyWithImpl;
@override @useResult
$Res call({
 int maxRetries, Duration retryDelay
});




}
/// @nodoc
class __$RetryOptionsCopyWithImpl<$Res>
    implements _$RetryOptionsCopyWith<$Res> {
  __$RetryOptionsCopyWithImpl(this._self, this._then);

  final _RetryOptions _self;
  final $Res Function(_RetryOptions) _then;

/// Create a copy of RetryOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxRetries = null,Object? retryDelay = null,}) {
  return _then(_RetryOptions(
maxRetries: null == maxRetries ? _self.maxRetries : maxRetries // ignore: cast_nullable_to_non_nullable
as int,retryDelay: null == retryDelay ? _self.retryDelay : retryDelay // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
