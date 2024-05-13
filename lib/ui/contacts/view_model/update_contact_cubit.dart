import 'package:contacts/business/general/i_general_manager.dart';
import 'package:contacts/ui/contacts/model/update_user_body_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class UpdateContactState {}

class UpdateContactInitial extends UpdateContactState {}

class UpdateContactLoading extends UpdateContactState {}

class UpdateContactComplete extends UpdateContactState {}

class UpdateContactError extends UpdateContactState {
  String? message;
  UpdateContactError({this.message});
}

class UpdateContactCubit extends Cubit<UpdateContactState> {
  IGeneralManager generalManager;

  UpdateContactCubit(this.generalManager) : super(UpdateContactInitial());

  Future<void> updateContact({required UpdateUserBodyModel bodyModel, required String id}) async {
    emit(UpdateContactLoading());
    try {
      final response = await generalManager.updateContact(bodyModel: bodyModel, id: id);
      if (response.data?.success == true) {
        emit(UpdateContactComplete());
      } else {
        emit(UpdateContactError(message: response.data?.message));
      }
    } catch (e) {
      emit(UpdateContactError(message: e.toString()));
    }
  }
}
