class Result {
  bool? success;
  String? message;

  Result(bool success, String message) {
    this.success = success;
    this.message = message;
  }

  Result.noneMessage(bool success) {
    this.success = success;
  }
}
