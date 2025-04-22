// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppException {

 String get message; String? get prefix; int? get code; Map<String, dynamic>? get data;
/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppExceptionCopyWith<AppException> get copyWith => _$AppExceptionCopyWithImpl<AppException>(this as AppException, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'AppException(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $AppExceptionCopyWith<$Res>  {
  factory $AppExceptionCopyWith(AppException value, $Res Function(AppException) _then) = _$AppExceptionCopyWithImpl;
@useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$AppExceptionCopyWithImpl<$Res>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._self, this._then);

  final AppException _self;
  final $Res Function(AppException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix! : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// @nodoc


class _AppException implements AppException {
  const _AppException({required this.message, this.prefix, this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override final  String message;
@override final  String? prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppExceptionCopyWith<_AppException> get copyWith => __$AppExceptionCopyWithImpl<_AppException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class _$AppExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory _$AppExceptionCopyWith(_AppException value, $Res Function(_AppException) _then) = __$AppExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String? prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class __$AppExceptionCopyWithImpl<$Res>
    implements _$AppExceptionCopyWith<$Res> {
  __$AppExceptionCopyWithImpl(this._self, this._then);

  final _AppException _self;
  final $Res Function(_AppException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = freezed,Object? code = freezed,Object? data = freezed,}) {
  return _then(_AppException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: freezed == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class NoInternetException implements AppException {
  const NoInternetException({this.message = "No Internet connection. Please check your network.", this.prefix = "Network", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoInternetExceptionCopyWith<NoInternetException> get copyWith => _$NoInternetExceptionCopyWithImpl<NoInternetException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoInternetException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.noInternet(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $NoInternetExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $NoInternetExceptionCopyWith(NoInternetException value, $Res Function(NoInternetException) _then) = _$NoInternetExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$NoInternetExceptionCopyWithImpl<$Res>
    implements $NoInternetExceptionCopyWith<$Res> {
  _$NoInternetExceptionCopyWithImpl(this._self, this._then);

  final NoInternetException _self;
  final $Res Function(NoInternetException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(NoInternetException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class RequestTimeoutException implements AppException {
  const RequestTimeoutException({this.message = "Oops! Something took too long to load.", this.prefix = "Timeout", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestTimeoutExceptionCopyWith<RequestTimeoutException> get copyWith => _$RequestTimeoutExceptionCopyWithImpl<RequestTimeoutException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestTimeoutException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.requestTimeout(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $RequestTimeoutExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $RequestTimeoutExceptionCopyWith(RequestTimeoutException value, $Res Function(RequestTimeoutException) _then) = _$RequestTimeoutExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$RequestTimeoutExceptionCopyWithImpl<$Res>
    implements $RequestTimeoutExceptionCopyWith<$Res> {
  _$RequestTimeoutExceptionCopyWithImpl(this._self, this._then);

  final RequestTimeoutException _self;
  final $Res Function(RequestTimeoutException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(RequestTimeoutException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class LocalStorageException implements AppException {
  const LocalStorageException({this.message = "Local storage error occurred.", this.prefix = "Storage", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalStorageExceptionCopyWith<LocalStorageException> get copyWith => _$LocalStorageExceptionCopyWithImpl<LocalStorageException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalStorageException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.localStorage(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $LocalStorageExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $LocalStorageExceptionCopyWith(LocalStorageException value, $Res Function(LocalStorageException) _then) = _$LocalStorageExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$LocalStorageExceptionCopyWithImpl<$Res>
    implements $LocalStorageExceptionCopyWith<$Res> {
  _$LocalStorageExceptionCopyWithImpl(this._self, this._then);

  final LocalStorageException _self;
  final $Res Function(LocalStorageException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(LocalStorageException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class BadRequestException implements AppException {
  const BadRequestException({this.message = "Invalid request.", this.prefix = "Bad Request", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadRequestExceptionCopyWith<BadRequestException> get copyWith => _$BadRequestExceptionCopyWithImpl<BadRequestException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequestException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.badRequest(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $BadRequestExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $BadRequestExceptionCopyWith(BadRequestException value, $Res Function(BadRequestException) _then) = _$BadRequestExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$BadRequestExceptionCopyWithImpl<$Res>
    implements $BadRequestExceptionCopyWith<$Res> {
  _$BadRequestExceptionCopyWithImpl(this._self, this._then);

  final BadRequestException _self;
  final $Res Function(BadRequestException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(BadRequestException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class UnauthorizedException implements AppException {
  const UnauthorizedException({this.message = "Unauthorized access.", this.prefix = "Auth", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedExceptionCopyWith<UnauthorizedException> get copyWith => _$UnauthorizedExceptionCopyWithImpl<UnauthorizedException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.unauthorized(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $UnauthorizedExceptionCopyWith(UnauthorizedException value, $Res Function(UnauthorizedException) _then) = _$UnauthorizedExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$UnauthorizedExceptionCopyWithImpl<$Res>
    implements $UnauthorizedExceptionCopyWith<$Res> {
  _$UnauthorizedExceptionCopyWithImpl(this._self, this._then);

  final UnauthorizedException _self;
  final $Res Function(UnauthorizedException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(UnauthorizedException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class InvalidInputException implements AppException {
  const InvalidInputException({this.message = "Invalid input provided.", this.prefix = "Input Error", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvalidInputExceptionCopyWith<InvalidInputException> get copyWith => _$InvalidInputExceptionCopyWithImpl<InvalidInputException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidInputException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.invalidInput(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $InvalidInputExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $InvalidInputExceptionCopyWith(InvalidInputException value, $Res Function(InvalidInputException) _then) = _$InvalidInputExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$InvalidInputExceptionCopyWithImpl<$Res>
    implements $InvalidInputExceptionCopyWith<$Res> {
  _$InvalidInputExceptionCopyWithImpl(this._self, this._then);

  final InvalidInputException _self;
  final $Res Function(InvalidInputException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(InvalidInputException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class FetchDataException implements AppException {
  const FetchDataException({this.message = "Unable to fetch data.", this.prefix = "Fetch Error", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchDataExceptionCopyWith<FetchDataException> get copyWith => _$FetchDataExceptionCopyWithImpl<FetchDataException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchDataException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.fetchData(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $FetchDataExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $FetchDataExceptionCopyWith(FetchDataException value, $Res Function(FetchDataException) _then) = _$FetchDataExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$FetchDataExceptionCopyWithImpl<$Res>
    implements $FetchDataExceptionCopyWith<$Res> {
  _$FetchDataExceptionCopyWithImpl(this._self, this._then);

  final FetchDataException _self;
  final $Res Function(FetchDataException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(FetchDataException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class CustomException implements AppException {
  const CustomException({required this.message, this.prefix = "Custom Status", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomExceptionCopyWith<CustomException> get copyWith => _$CustomExceptionCopyWithImpl<CustomException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.custom(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $CustomExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $CustomExceptionCopyWith(CustomException value, $Res Function(CustomException) _then) = _$CustomExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$CustomExceptionCopyWithImpl<$Res>
    implements $CustomExceptionCopyWith<$Res> {
  _$CustomExceptionCopyWithImpl(this._self, this._then);

  final CustomException _self;
  final $Res Function(CustomException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(CustomException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class UnknownException implements AppException {
  const UnknownException({this.message = "An unknown error occurred.", this.prefix = "Unknown", this.code, final  Map<String, dynamic>? data}): _data = data;
  

@override@JsonKey() final  String message;
@override@JsonKey() final  String prefix;
@override final  int? code;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownExceptionCopyWith<UnknownException> get copyWith => _$UnknownExceptionCopyWithImpl<UnknownException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownException&&(identical(other.message, message) || other.message == message)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,message,prefix,code,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'AppException.unknown(message: $message, prefix: $prefix, code: $code, data: $data)';
}


}

/// @nodoc
abstract mixin class $UnknownExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $UnknownExceptionCopyWith(UnknownException value, $Res Function(UnknownException) _then) = _$UnknownExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, String prefix, int? code, Map<String, dynamic>? data
});




}
/// @nodoc
class _$UnknownExceptionCopyWithImpl<$Res>
    implements $UnknownExceptionCopyWith<$Res> {
  _$UnknownExceptionCopyWithImpl(this._self, this._then);

  final UnknownException _self;
  final $Res Function(UnknownException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? prefix = null,Object? code = freezed,Object? data = freezed,}) {
  return _then(UnknownException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
