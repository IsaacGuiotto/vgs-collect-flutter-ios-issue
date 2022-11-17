package com.verygoodsecurity.vgs_collect_flutter_demo

import android.os.Bundle
import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import androidx.annotation.LayoutRes
import android.graphics.Color
import com.google.gson.Gson
import com.verygoodsecurity.vgscollect.core.VGSCollect
import com.verygoodsecurity.vgscollect.core.VgsCollectResponseListener
import com.verygoodsecurity.vgscollect.core.HTTPMethod
import com.verygoodsecurity.vgscollect.core.model.network.VGSResponse
import com.verygoodsecurity.vgscollect.view.InputFieldView
import com.verygoodsecurity.vgscollect.widget.CardVerificationCodeEditText
import com.verygoodsecurity.vgscollect.widget.ExpirationDateEditText
import androidx.core.content.ContextCompat
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class ActivateCardView(
        context: Context,
        id: Int,
        creationParams: Map<String?, Any?>?,
        messenger: BinaryMessenger,
) : PlatformView, MethodChannel.MethodCallHandler, VgsCollectResponseListener  {

    protected val methodChannel = MethodChannel(messenger, "activate-card")
    private var collect: VGSCollect? = null
    protected val rootView: View = LayoutInflater.from(context).inflate(R.layout.activate_card_layout, null)
    val vgsCVC: CardVerificationCodeEditText  = rootView.findViewById(R.id.vgsCVC)
    val vgsExpiry: ExpirationDateEditText  = rootView.findViewById(R.id.vgsExpiry)

    private var result: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "send-request" -> sendRequest(call.arguments as? Map<*, *>, result)
            "isFormValid" -> isFormValid(result)
        }
    }

    override fun onResponse(response: VGSResponse?) {
        val resultData = mutableMapOf<String, Any>()
        if (response is VGSResponse.SuccessResponse) {
            resultData["STATUS"] = "SUCCESS"
            resultData["DATA"] = Gson().fromJson(response.body, HashMap::class.java)
        } else {
            resultData["STATUS"] = "FAILED"
        }
        result?.success(resultData)
        result = null
    }

    override fun dispose() {
        collect?.onDestroy()
    }

    override fun getView(): View {
        return rootView
    }

    private fun sendRequest(arguments: Map<*, *>?, result: MethodChannel.Result) {
        val baasId = arguments?.get("baasId")
        val token = arguments?.get("token")

        val headers = HashMap<String, String>()
        headers["Authorization"] = "Bearer " + token
        collect?.setCustomHeaders(headers)
        this.result = result

        collect?.asyncSubmit("/cards/$baasId/activate", HTTPMethod.POST)
    }

    private fun isFormValid(result: MethodChannel.Result) {
        result.success(isCVCValid() && isExpiryValid())
    }

    private fun isExpiryValid() = vgsExpiry.getState()?.isValid == true

    private fun isCVCValid() = vgsCVC.getState()?.isValid == true

    init {
        methodChannel.setMethodCallHandler(this)

        collect = VGSCollect(context, creationParams!!.get("vaultId") as? String ?: "", creationParams!!.get("enviroment") as? String ?: "")

        collect?.addOnResponseListeners(this)
        collect?.bindView(vgsCVC, vgsExpiry)


    }
}
