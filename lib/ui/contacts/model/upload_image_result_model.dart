import 'package:contacts/core/model/i_model.dart';

class UploadImageResultModelData {


  String? imageUrl;

  UploadImageResultModelData({
    this.imageUrl,
  });
  UploadImageResultModelData.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class UploadImageResultModel extends IModel{
/*
{
  "success": true,
  "messages": [
    "string"
  ],
  "data": {
    "imageUrl": "string"
  },
  "status": 100
}
*/

  bool? success;
  List<String?>? messages;
  UploadImageResultModelData? data;
  int? status;

  UploadImageResultModel({
    this.success,
    this.messages,
    this.data,
    this.status,
  });
  UploadImageResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['messages'] != null) {
      final v = json['messages'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      messages = arr0;
    }
    data = (json['data'] != null) ? UploadImageResultModelData.fromJson(json['data']) : null;
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
    return UploadImageResultModel.fromJson(json);
  }
}
