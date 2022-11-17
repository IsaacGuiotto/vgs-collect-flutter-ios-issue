part of 'activate_card_cubit.dart';

class ActivateCardState extends Equatable {
  final bool isLoading;
  final String error;
  final String errorTitle;
  final bool sendRequest;
  final bool success;
  final bool validate;

  const ActivateCardState({
    required this.isLoading,
    required this.error,
    required this.errorTitle,
    required this.sendRequest,
    required this.success,
    required this.validate,
  });

  const ActivateCardState.initial()
      : isLoading = false,
        error = "",
        errorTitle = "",
        sendRequest = false,
        success = false,
        validate = false;

  copyWith({
    bool? isLoading,
    String? error,
    String? errorTitle,
    bool? sendRequest,
    bool? success,
    bool? validate,
  }) {
    return ActivateCardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      errorTitle: errorTitle ?? this.errorTitle,
      sendRequest: sendRequest ?? this.sendRequest,
      success: success ?? this.success,
      validate: validate ?? this.validate,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        errorTitle,
        success,
        sendRequest,
        validate,
      ];
}
