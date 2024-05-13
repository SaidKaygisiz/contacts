import 'dart:io';

import 'package:contacts/core/model/i_model.dart';
import 'package:http/http.dart';

abstract class INetwork<T> {
  //GET
  Future<T> get(T model, Uri url, {Map<String, String> headers});
  //POST
  Future<T> postFile(T model,File file, Uri url, {Map<String, String> headers});
  Future<T> postWithModel<T extends IModel, R extends IModel>(R model, T resultModel, Uri url, {Map<String, String> headers});
  //PUT
  Future<T> putWithModel<T extends IModel, R extends IModel>(R model, T resultModel, Uri url, {Map<String, String> headers});
  //DELETE
  Future<T> delete(T model, Uri url, {Map<String, String> headers});

}