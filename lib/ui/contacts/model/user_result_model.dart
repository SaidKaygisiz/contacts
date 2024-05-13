import 'package:contacts/core/model/i_model.dart';

class UserResultModelData {

  String? id;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profileImageUrl;

  UserResultModelData({
    this.id,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
  });
  UserResultModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    createdAt = json['createdAt']?.toString();
    firstName = json['firstName']?.toString();
    lastName = json['lastName']?.toString();
    phoneNumber = json['phoneNumber']?.toString();
    profileImageUrl = json['profileImageUrl']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}

class UserResultModel extends IModel{

  bool? success;
  List<String?>? messages;
  UserResultModelData? data;
  int? status;

  UserResultModel({
    this.success,
    this.messages,
    this.data,
    this.status,
  });
  UserResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['messages'] != null) {
      final v = json['messages'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      messages = arr0;
    }
    data = (json['data'] != null) ? UserResultModelData.fromJson(json['data']) : null;
    status = json['status']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (messages != null) {
      final v = messages;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['messages'] = arr0;
    }
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
   return UserResultModel.fromJson(json);
  }
}
