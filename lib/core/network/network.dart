import 'dart:convert';
import 'dart:io';
import 'package:contacts/core/model/i_model.dart';
import 'package:http/http.dart' as h;
import 'package:http/http.dart';
import 'i_network.dart';
import 'package:http/retry.dart';

class HttpNetwork<T extends IModel> implements INetwork<T> {
  Future<bool> refreshToken() async {
    return true;
  }

  @override
  Future<T> get(T model, Uri url, {Map<String, String>? headers}) async {
    final client = RetryClient(Client(), retries: 1, when: (response) {
      return response.statusCode == 401 ? true : false;
    }, onRetry: (req, res, retryCount) async {
      if (retryCount == 0 && res?.statusCode == 401) {
        var refreshControl = await refreshToken();
        if (!refreshControl) {
          req.finalize();
        }
      }
    });
    try {
      final response = await client.get(url, headers: headers);
      if (response.statusCode == 401) {
        model.statusCode = response.statusCode;
        return model;
      }
      final jsonModel = jsonDecode(response.body);
      return model.fromJson(jsonModel);
    } finally {
      client.close();
    }
  }

  Future<T> postFile(T model, File file, Uri url, {Map<String, String>? headers}) async {
    final client = RetryClient(Client(), retries: 1, when: (response) {
      return response.statusCode == 401 ? true : false;
    }, onRetry: (req, res, retryCount) async {
      if (retryCount == 0 && res?.statusCode == 401) {
        var refreshControl = await refreshToken();
        if (!refreshControl) {
          req.finalize();
        }
      }
    });
    try {
      var request = h.MultipartRequest('POST', url);
      request.files.add(await h.MultipartFile.fromPath('image', file.path));
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 401) {
        model.statusCode = response.statusCode;
        return model;
      }
      final jsonModel = jsonDecode(respStr);
      return model.fromJson(jsonModel);
    } finally {
      client.close();
    }
  }

  @override
  Future<T> postWithModel<T extends IModel, R extends IModel>(R model, T resultModel, Uri url,
      {Map<String, String>? headers}) async {
    final client = RetryClient(Client(), retries: 1, when: (response) {
      return response.statusCode == 401 ? true : false;
    }, onRetry: (req, res, retryCount) async {
      if (retryCount == 0 && res?.statusCode == 401) {
        var refreshControl = await refreshToken();
        if (!refreshControl) {
          req.finalize();
        }
      }
    });
    try {
      final jsonModel = jsonEncode(model.toJson());
      final response = await client.post(url, body: jsonModel, headers: headers);
      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return resultModel.fromJson(result);
      }
      resultModel.statusCode = response.statusCode;
      return resultModel;
    } finally {
      client.close();
    }
  }

  @override
  Future<T> putWithModel<T extends IModel, R extends IModel>(R model, T resultModel, Uri url,
      {Map<String, String>? headers}) async {
    final client = RetryClient(Client(), retries: 1, when: (response) {
      return response.statusCode == 401 ? true : false;
    }, onRetry: (req, res, retryCount) async {
      if (retryCount == 0 && res?.statusCode == 401) {
        var refreshControl = await refreshToken();
        if (!refreshControl) {
          req.finalize();
        }
      }
    });
    try {
      final jsonModel = jsonEncode(model.toJson());
      final response = await client.put(url, body: jsonModel, headers: headers);
      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return resultModel.fromJson(result);
      }
      resultModel.statusCode = response.statusCode;
      return resultModel;
    } finally {
      client.close();
    }
  }

  @override
  Future<T> delete(T model, Uri url, {Map<String, String>? headers}) async {
    final client = RetryClient(Client(), retries: 1, when: (response) {
      return response.statusCode == 401 ? true : false;
    }, onRetry: (req, res, retryCount) async {
      if (retryCount == 0 && res?.statusCode == 401) {
        var refreshControl = await refreshToken();
        if (!refreshControl) {
          req.finalize();
        }
      }
    });
    try {
      final response = await client.delete(url, headers: headers);

      if (response.statusCode == 401) {
        model.statusCode = response.statusCode;
        return model;
      }
      final jsonModel = jsonDecode(response.body);
      return model.fromJson(jsonModel);
    } finally {
      client.close();
    }
  }
}
