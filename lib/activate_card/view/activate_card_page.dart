import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/activate_card_cubit.dart';
import '../controller/activate_card_method_channel.dart';

// ignore: must_be_immutable
class NativeActivateCardView extends StatelessWidget {
  final ActivateCardCubit bloc;
  final String token;
  final String baasId;

  NativeActivateCardView({
    super.key,
    required this.bloc,
    required this.token,
    required this.baasId,
  });

  final ActivateCardMethodChannelController _activateCardController =
      ActivateCardMethodChannelController();

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    String viewType = 'activate-card-view';
    const Map<String, dynamic> creationParams = {
      "vaultId": "tntazhyknp1",
      "enviroment": "sandbox"
    };
    // Pass parameters to the platform side.

    return BlocListener<ActivateCardCubit, ActivateCardState>(
      bloc: bloc,
      listenWhen: (oldS, newS) =>
          oldS.sendRequest != newS.sendRequest ||
          oldS.validate != newS.validate ||
          oldS.error != newS.error ||
          oldS.success != newS.success,
      listener: (context, state) async {
        if (state.success) {
          print("Success");
        } else {
          if (state.validate) {
            final validate = await _activateCardController.validateForm();
            bloc.onValidateForm(validate);
          }

          if (state.sendRequest) {
            sendRequest(token, baasId);
          }

          // if (state.error.isNotEmpty) {
          //   showDialog(
          //       context: context,
          //       builder: (context) => ErrorDialog(
          //           titleText: state.errorTitle, contentText: state.error));
          // }
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Platform.isIOS
            ? UiKitView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                onPlatformViewCreated: _createActivateCardController,
                creationParamsCodec: const StandardMessageCodec(),
              )
            : AndroidView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                onPlatformViewCreated: _createActivateCardController,
                creationParamsCodec: const StandardMessageCodec(),
              ),
      ),
    );
  }

  void _createActivateCardController(int id) {
    _activateCardController.channel.setMethodCallHandler(invokedMethods);
  }

  sendRequest(String token, String baasId) async {
    final result = await _activateCardController.sendRequest(
        cardBaasId: baasId, token: token);
    var resultData = Map<String, dynamic>.from(result);
    final resultStatus = resultData["STATUS"];
    if (resultStatus == "SUCCESS") {
      bloc.onSuccess();
    } else {
      bloc.onErrorChanged("Oops", "Something went wrong. Try again");
    }
  }

  Future<dynamic> invokedMethods(MethodCall methodCall) async {
    methodCall.arguments;
    switch (methodCall.method) {
      default:
        break;
    }
  }
}
