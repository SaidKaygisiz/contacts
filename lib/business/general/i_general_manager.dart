import 'dart:io';
import 'package:contacts/core/model/data_result.dart';
import 'package:contacts/ui/contacts/model/get_user_result_model.dart';
import 'package:contacts/ui/contacts/model/register_user_body_model.dart';
import 'package:contacts/ui/contacts/model/update_user_body_model.dart';
import 'package:contacts/ui/contacts/model/upload_image_result_model.dart';
import 'package:contacts/ui/contacts/model/user_result_model.dart';

abstract class IGeneralManager {
  Future<DataResult<UserResultModel>> addContact({required RegisterUserBodyModel bodyModel});
  Future<DataResult<GetContactsResultModel>> getContacts({String? search});
  Future<DataResult<UserResultModel>> getContactWithId({required String id});
  Future<DataResult<UserResultModel>> updateContact({required UpdateUserBodyModel bodyModel, required String id});
  Future<DataResult<UserResultModel>> deleteContact({required String id});
  Future<DataResult<UploadImageResultModel>> uploadImage({required File file});
}
