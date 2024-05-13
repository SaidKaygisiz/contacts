import 'package:contacts/business/general/i_general_manager.dart';
import 'package:contacts/ui/contacts/model/get_user_result_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GetContactsState {}

class GetContactsInitial extends GetContactsState {}

class GetContactsLoading extends GetContactsState {}

class GetContactsComplete extends GetContactsState {
  GetContactsResultModel? model;
  GetContactsComplete({required this.model});
}

class GetContactsError extends GetContactsState {
  String? message;
  GetContactsError({this.message});
}

class GetContactsCubit extends Cubit<GetContactsState> {
  IGeneralManager generalManager;

  GetContactsCubit(this.generalManager) : super(GetContactsInitial());

  Future<void> getContacts({String? search}) async {
    emit(GetContactsLoading());
    try {
      final response = await generalManager.getContacts(search: search);
      if (response.success == true) {
        emit(GetContactsComplete(model: response.data));
      } else {
        emit(GetContactsError(message: response.data?.message));
      }
    } catch (e) {
      emit(GetContactsError(message: e.toString()));
    }
  }
}
