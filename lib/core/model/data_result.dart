import 'package:contacts/core/model/result.dart';

class DataResult<T> extends Result {
  T? data;

  DataResult(T data, bool success, String message) : super(success, message) {
    this.data = data;
  }

  DataResult.noneMessage(T data, bool success) : super.noneMessage(success) {
    this.data = data;
    this.success = success;
  }

  DataResult.justMessage(String message, bool success) : super(success, message) {
    this.message = message;
    this.success = success;
  }
}