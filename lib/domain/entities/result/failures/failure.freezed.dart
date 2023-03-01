// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Failure {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$NoInternetConnectionFoundCopyWith<$Res> {
  factory _$$NoInternetConnectionFoundCopyWith(
          _$NoInternetConnectionFound value,
          $Res Function(_$NoInternetConnectionFound) then) =
      __$$NoInternetConnectionFoundCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoInternetConnectionFoundCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NoInternetConnectionFound>
    implements _$$NoInternetConnectionFoundCopyWith<$Res> {
  __$$NoInternetConnectionFoundCopyWithImpl(_$NoInternetConnectionFound _value,
      $Res Function(_$NoInternetConnectionFound) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NoInternetConnectionFound implements NoInternetConnectionFound {
  const _$NoInternetConnectionFound();

  @override
  String toString() {
    return 'Failure.noInternetConnectionFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoInternetConnectionFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) {
    return noInternetConnectionFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) {
    return noInternetConnectionFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) {
    if (noInternetConnectionFound != null) {
      return noInternetConnectionFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) {
    return noInternetConnectionFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) {
    return noInternetConnectionFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) {
    if (noInternetConnectionFound != null) {
      return noInternetConnectionFound(this);
    }
    return orElse();
  }
}

abstract class NoInternetConnectionFound implements Failure {
  const factory NoInternetConnectionFound() = _$NoInternetConnectionFound;
}

/// @nodoc
abstract class _$$ServerNotResponseCopyWith<$Res> {
  factory _$$ServerNotResponseCopyWith(
          _$ServerNotResponse value, $Res Function(_$ServerNotResponse) then) =
      __$$ServerNotResponseCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ServerNotResponseCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerNotResponse>
    implements _$$ServerNotResponseCopyWith<$Res> {
  __$$ServerNotResponseCopyWithImpl(
      _$ServerNotResponse _value, $Res Function(_$ServerNotResponse) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ServerNotResponse implements ServerNotResponse {
  const _$ServerNotResponse();

  @override
  String toString() {
    return 'Failure.serverNotResponse()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ServerNotResponse);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) {
    return serverNotResponse();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) {
    return serverNotResponse?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) {
    if (serverNotResponse != null) {
      return serverNotResponse();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) {
    return serverNotResponse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) {
    return serverNotResponse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) {
    if (serverNotResponse != null) {
      return serverNotResponse(this);
    }
    return orElse();
  }
}

abstract class ServerNotResponse implements Failure {
  const factory ServerNotResponse() = _$ServerNotResponse;
}

/// @nodoc
abstract class _$$TokenExpiredCopyWith<$Res> {
  factory _$$TokenExpiredCopyWith(
          _$TokenExpired value, $Res Function(_$TokenExpired) then) =
      __$$TokenExpiredCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TokenExpiredCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$TokenExpired>
    implements _$$TokenExpiredCopyWith<$Res> {
  __$$TokenExpiredCopyWithImpl(
      _$TokenExpired _value, $Res Function(_$TokenExpired) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TokenExpired implements TokenExpired {
  const _$TokenExpired();

  @override
  String toString() {
    return 'Failure.unAuthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TokenExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) {
    return unAuthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) {
    return unAuthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) {
    if (unAuthenticated != null) {
      return unAuthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) {
    return unAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) {
    return unAuthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) {
    if (unAuthenticated != null) {
      return unAuthenticated(this);
    }
    return orElse();
  }
}

abstract class TokenExpired implements Failure {
  const factory TokenExpired() = _$TokenExpired;
}

/// @nodoc
abstract class _$$UnknownFailureCopyWith<$Res> {
  factory _$$UnknownFailureCopyWith(
          _$UnknownFailure value, $Res Function(_$UnknownFailure) then) =
      __$$UnknownFailureCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnknownFailureCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailure>
    implements _$$UnknownFailureCopyWith<$Res> {
  __$$UnknownFailureCopyWithImpl(
      _$UnknownFailure _value, $Res Function(_$UnknownFailure) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UnknownFailure implements UnknownFailure {
  const _$UnknownFailure();

  @override
  String toString() {
    return 'Failure.unknownFailure()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnknownFailure);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) {
    return unknownFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) {
    return unknownFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) {
    if (unknownFailure != null) {
      return unknownFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) {
    return unknownFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) {
    return unknownFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) {
    if (unknownFailure != null) {
      return unknownFailure(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure() = _$UnknownFailure;
}

/// @nodoc
abstract class _$$InvalidInputValueCopyWith<$Res> {
  factory _$$InvalidInputValueCopyWith(
          _$InvalidInputValue value, $Res Function(_$InvalidInputValue) then) =
      __$$InvalidInputValueCopyWithImpl<$Res>;
  @useResult
  $Res call({dynamic type});
}

/// @nodoc
class __$$InvalidInputValueCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$InvalidInputValue>
    implements _$$InvalidInputValueCopyWith<$Res> {
  __$$InvalidInputValueCopyWithImpl(
      _$InvalidInputValue _value, $Res Function(_$InvalidInputValue) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
  }) {
    return _then(_$InvalidInputValue(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$InvalidInputValue implements InvalidInputValue {
  const _$InvalidInputValue({required this.type});

  @override
  final dynamic type;

  @override
  String toString() {
    return 'Failure.invalidInputValue(type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidInputValue &&
            const DeepCollectionEquality().equals(other.type, type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(type));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidInputValueCopyWith<_$InvalidInputValue> get copyWith =>
      __$$InvalidInputValueCopyWithImpl<_$InvalidInputValue>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) {
    return invalidInputValue(type);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) {
    return invalidInputValue?.call(type);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) {
    if (invalidInputValue != null) {
      return invalidInputValue(type);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) {
    return invalidInputValue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) {
    return invalidInputValue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) {
    if (invalidInputValue != null) {
      return invalidInputValue(this);
    }
    return orElse();
  }
}

abstract class InvalidInputValue implements Failure {
  const factory InvalidInputValue({required final dynamic type}) =
      _$InvalidInputValue;

  dynamic get type;
  @JsonKey(ignore: true)
  _$$InvalidInputValueCopyWith<_$InvalidInputValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HttpFailureCopyWith<$Res> {
  factory _$$HttpFailureCopyWith(
          _$HttpFailure value, $Res Function(_$HttpFailure) then) =
      __$$HttpFailureCopyWithImpl<$Res>;
  @useResult
  $Res call({int code, String msg});
}

/// @nodoc
class __$$HttpFailureCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$HttpFailure>
    implements _$$HttpFailureCopyWith<$Res> {
  __$$HttpFailureCopyWithImpl(
      _$HttpFailure _value, $Res Function(_$HttpFailure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? msg = null,
  }) {
    return _then(_$HttpFailure(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      msg: null == msg
          ? _value.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HttpFailure implements HttpFailure {
  const _$HttpFailure({required this.code, required this.msg});

  @override
  final int code;
  @override
  final String msg;

  @override
  String toString() {
    return 'Failure.httpFailure(code: $code, msg: $msg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpFailure &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.msg, msg) || other.msg == msg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, msg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpFailureCopyWith<_$HttpFailure> get copyWith =>
      __$$HttpFailureCopyWithImpl<_$HttpFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noInternetConnectionFound,
    required TResult Function() serverNotResponse,
    required TResult Function() unAuthenticated,
    required TResult Function() unknownFailure,
    required TResult Function(dynamic type) invalidInputValue,
    required TResult Function(int code, String msg) httpFailure,
  }) {
    return httpFailure(code, msg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noInternetConnectionFound,
    TResult? Function()? serverNotResponse,
    TResult? Function()? unAuthenticated,
    TResult? Function()? unknownFailure,
    TResult? Function(dynamic type)? invalidInputValue,
    TResult? Function(int code, String msg)? httpFailure,
  }) {
    return httpFailure?.call(code, msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noInternetConnectionFound,
    TResult Function()? serverNotResponse,
    TResult Function()? unAuthenticated,
    TResult Function()? unknownFailure,
    TResult Function(dynamic type)? invalidInputValue,
    TResult Function(int code, String msg)? httpFailure,
    required TResult orElse(),
  }) {
    if (httpFailure != null) {
      return httpFailure(code, msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoInternetConnectionFound value)
        noInternetConnectionFound,
    required TResult Function(ServerNotResponse value) serverNotResponse,
    required TResult Function(TokenExpired value) unAuthenticated,
    required TResult Function(UnknownFailure value) unknownFailure,
    required TResult Function(InvalidInputValue value) invalidInputValue,
    required TResult Function(HttpFailure value) httpFailure,
  }) {
    return httpFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult? Function(ServerNotResponse value)? serverNotResponse,
    TResult? Function(TokenExpired value)? unAuthenticated,
    TResult? Function(UnknownFailure value)? unknownFailure,
    TResult? Function(InvalidInputValue value)? invalidInputValue,
    TResult? Function(HttpFailure value)? httpFailure,
  }) {
    return httpFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoInternetConnectionFound value)?
        noInternetConnectionFound,
    TResult Function(ServerNotResponse value)? serverNotResponse,
    TResult Function(TokenExpired value)? unAuthenticated,
    TResult Function(UnknownFailure value)? unknownFailure,
    TResult Function(InvalidInputValue value)? invalidInputValue,
    TResult Function(HttpFailure value)? httpFailure,
    required TResult orElse(),
  }) {
    if (httpFailure != null) {
      return httpFailure(this);
    }
    return orElse();
  }
}

abstract class HttpFailure implements Failure {
  const factory HttpFailure(
      {required final int code, required final String msg}) = _$HttpFailure;

  int get code;
  String get msg;
  @JsonKey(ignore: true)
  _$$HttpFailureCopyWith<_$HttpFailure> get copyWith =>
      throw _privateConstructorUsedError;
}
