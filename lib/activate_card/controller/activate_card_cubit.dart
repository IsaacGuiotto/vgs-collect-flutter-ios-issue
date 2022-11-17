import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activate_card_state.dart';

class ActivateCardCubit extends Cubit<ActivateCardState> {
  ActivateCardCubit() : super(const ActivateCardState.initial());

  refresh() => emit(const ActivateCardState.initial());

  onValidate() => emit(state.copyWith(validate: true, isLoading: true));

  onSuccess() => emit(state.copyWith(success: true, isLoading: false));

  onSuccessSetPass(String cardId) =>
      emit(state.copyWith(success: true, isLoading: false));

  onErrorChanged(String errorTitle, String error) => emit(state.copyWith(
      error: error,
      errorTitle: errorTitle,
      sendRequest: false,
      isLoading: false));

  onValidateForm(bool validate) {
    emit(state.copyWith(
        error: "", errorTitle: "", validate: false, sendRequest: false));
    if (validate) {
      emit(state.copyWith(sendRequest: true));
    } else {
      emit(state.copyWith(
          validate: false,
          errorTitle: "Invalid",
          error: "Something is wrong with the data you typed"));
    }
  }
}
