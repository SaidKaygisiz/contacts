import 'dart:io';
import 'package:contacts/core/constants.dart';
import 'package:contacts/core/model/data_result.dart';
import 'package:contacts/core/network/i_network.dart';
import 'package:contacts/ui/contacts/model/get_user_result_model.dart';
import 'package:contacts/ui/contacts/model/register_user_body_model.dart';
import 'package:contacts/ui/contacts/model/update_user_body_model.dart';
import 'package:contacts/ui/contacts/model/upload_image_result_model.dart';
import 'package:contacts/ui/contacts/model/user_result_model.dart';
import 'i_general_manager.dart';

class GeneralManager implements IGeneralManager {
  final INetwork network;

  GeneralManager(this.network);

  @override
  Future<DataResult<UserResultModel>> addContact({required RegisterUserBodyModel bodyModel}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseUrl}/api/User");
      final response = await network.postWithModel(bodyModel, UserResultModel(), url, headers: {
        "Content-Type": "application/json",
        "ApiKey": "${AppConstants.apiKey}",
      });
      return DataResult.noneMessage(response, true);
    } catch (e) {
      return DataResult.justMessage("Beklenmeyen hata!", false);
    }
  }

  @override
  Future<DataResult<GetContactsResultModel>> getContacts({String? search}) async {
    try {
      var url;
      if (search == null) {
        url = Uri.parse("${AppConstants.baseUrl}/api/User?skip=0&take=100");
      } else {
        url = Uri.parse("${AppConstants.baseUrl}/api/User?search=${search}&skip=0&take=100");
      }
      final response = await network.get(GetContactsResultModel(), url, headers: {
        "Content-Type": "application/json",
        "ApiKey": "${AppConstants.apiKey}",
      });
      return DataResult.noneMessage(response, true);
    } catch (e) {
      return DataResult.justMessage("Beklenmeyen hata!", false);
    }
  }

  @override
  Future<DataResult<UserResultModel>> deleteContact({required String id}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseUrl}/api/User/${id}");
      final response = await network.delete(UserResultModel(), url, headers: {
        "Content-Type": "application/json",
        "ApiKey": "${AppConstants.apiKey}",
      });
      return DataResult.noneMessage(response, true);
    } catch (e) {
      return DataResult.justMessage("Beklenmeyen hata!", false);
    }
  }

  @override
  Future<DataResult<UserResultModel>> updateContact(
      {required UpdateUserBodyModel bodyModel, required String id}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseUrl}/api/User/${id}");
      final response = await network.putWithModel(bodyModel, UserResultModel(), url, headers: {
        "Content-Type": "application/json",
        "ApiKey": "${AppConstants.apiKey}",
      });
      return DataResult.noneMessage(response, true);
    } catch (e) {
      return DataResult.justMessage("Beklenmeyen hata!", false);
    }
  }

  @override
  Future<DataResult<UserResultModel>> getContactWithId({required String id}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseUrl}/api/User/${id}");
      final response = await network.get(UserResultModel(), url, headers: {
        "Content-Type": "application/json",
        "ApiKey": "${AppConstants.apiKey}",
      });
      return DataResult.noneMessage(response, true);
    } catch (e) {
      return DataResult.justMessage("Beklenmeyen hata!", false);
    }
  }

  @override
  Future<DataResult<UploadImageResultModel>> uploadImage({required File file}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseUrl}/api/User/UploadImage");
      final response = await network.postFile(UploadImageResultModel(), file, url, headers: {
        "Content-Type": "multipart/form-data",
        "ApiKey": "${AppConstants.apiKey}",
      });
      return DataResult.noneMessage(response, true);
    } catch (e) {
      return DataResult.justMessage("Beklenmeyen hata!", false);
    }
  }
}
