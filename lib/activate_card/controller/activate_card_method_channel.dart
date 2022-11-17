import 'package:flutter/services.dart';

class ActivateCardMethodChannelController {
  final MethodChannel channel;
  ActivateCardMethodChannelController()
      : channel = const MethodChannel("activate-card");

  Future<Map<dynamic, dynamic>> sendRequest(
      {required String cardBaasId, required String token}) async {
    return await channel.invokeMethod("send-request", {
      "baasId": cardBaasId,
      "token": token,
    });
  }

  Future<bool> validateForm() async {
    return await channel.invokeMethod("isFormValid");
  }
}
