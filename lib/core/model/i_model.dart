abstract class IModel<T> {
  fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  int? statusCode;
  String? message;
}
