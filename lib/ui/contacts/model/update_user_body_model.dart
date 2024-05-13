import 'package:contacts/core/model/i_model.dart';

class UpdateUserBodyModel extends IModel{


  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profileImageUrl;

  UpdateUserBodyModel({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
  });
  UpdateUserBodyModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName']?.toString();
    lastName = json['lastName']?.toString();
    phoneNumber = json['phoneNumber']?.toString();
    profileImageUrl = json['profileImageUrl']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return UpdateUserBodyModel.fromJson(json);
  }
}
