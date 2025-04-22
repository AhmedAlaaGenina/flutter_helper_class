import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination_package/networking/dio/networking_freezed/networking_freezed.dart';

part 'result.freezed.dart';

@Freezed()
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppFailure failure) = Failure<T>;
    
  const Result._(); 

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}
