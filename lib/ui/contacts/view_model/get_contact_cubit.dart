import 'package:contacts/business/general/i_general_manager.dart';
import 'package:contacts/ui/contacts/model/get_user_result_model.dart';
import 'package:contacts/ui/contacts/model/user_result_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetContactState {}

class GetContactInitial extends GetContactState {}

class GetContactLoading extends GetContactState {}

class GetContactComplete extends GetContactState {
  UserResultModel? model;
  GetContactComplete({required this.model});
}

class GetContactError extends GetContactState {
  String? message;
  GetContactError({this.message});
}

class GetContactCubit extends Cubit<GetContactState> {
  IGeneralManager generalManager;

  GetContactCubit(this.generalManager) : super(GetContactInitial());

  Future<void> getContact({required String id}) async {
    emit(GetContactLoading());
    try {
      final response = await generalManager.getContactWithId(id: id);
      if (response.success == true) {
        emit(GetContactComplete(model: response.data));
      } else {
        emit(GetContactError(message: response.data?.message));
      }
    } catch (e) {
      emit(GetContactError(message: e.toString()));
    }
  }
}
