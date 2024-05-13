import 'dart:io';

import 'package:contacts/business/general/i_general_manager.dart';
import 'package:contacts/ui/contacts/model/upload_image_result_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class ImageNotChange extends UploadImageState {}

class UploadImageComplete extends UploadImageState {
  UploadImageResultModel? model;
  UploadImageComplete({required this.model});
}

class UploadImageError extends UploadImageState {
  String? message;
  UploadImageError({this.message});
}

class UploadImageCubit extends Cubit<UploadImageState> {
  IGeneralManager generalManager;

  UploadImageCubit(this.generalManager) : super(UploadImageInitial());

  Future<void> uploadImage({required File file}) async {
    emit(UploadImageLoading());
    try {
      final response = await generalManager.uploadImage(file: file);
      if (response.success == true) {
        emit(UploadImageComplete(model: response.data));
      } else {
        emit(UploadImageError(message: response.data?.message));
      }
    } catch (e) {
      emit(UploadImageError(message: e.toString()));
    }
  }
}