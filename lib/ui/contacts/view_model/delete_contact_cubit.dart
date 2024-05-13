import 'package:contacts/business/general/i_general_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteContactState {}

class DeleteContactInitial extends DeleteContactState {}

class DeleteContactLoading extends DeleteContactState {}

class DeleteContactComplete extends DeleteContactState {}

class DeleteContactError extends DeleteContactState {
  String? message;
  DeleteContactError({this.message});
}

class DeleteContactCubit extends Cubit<DeleteContactState> {
  IGeneralManager generalManager;

  DeleteContactCubit(this.generalManager) : super(DeleteContactInitial());

  Future<void> deleteContact({required String id}) async {
    emit(DeleteContactLoading());
    try {
      final response = await generalManager.deleteContact(id: id);
      if (response.data?.success == true) {
        emit(DeleteContactComplete());
      } else {
        emit(DeleteContactError(message: response.data?.message));
      }
    } catch (e) {
      emit(DeleteContactError(message: e.toString()));
    }
  }
}
