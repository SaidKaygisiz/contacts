import 'package:contacts/business/general/i_general_manager.dart';
import 'package:contacts/ui/contacts/model/register_user_body_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddContactState {}

class AddContactInitial extends AddContactState {}

class AddContactLoading extends AddContactState {}

class AddContactComplete extends AddContactState {}

class AddContactError extends AddContactState {
  String? message;
  AddContactError({this.message});
}

class AddContactCubit extends Cubit<AddContactState> {
  IGeneralManager generalManager;

  AddContactCubit(this.generalManager) : super(AddContactInitial());

  Future<void> addContact({required RegisterUserBodyModel bodyModel}) async {
    emit(AddContactLoading());
    try {
      final response = await generalManager.addContact(bodyModel: bodyModel);
      if (response.data?.success == true) {
        emit(AddContactComplete());
      } else {
        emit(AddContactError(message: response.data?.message));
      }
    } catch (e) {
      emit(AddContactError(message: e.toString()));
    }
  }
}
