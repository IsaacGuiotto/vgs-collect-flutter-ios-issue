//
//  ActivateCardView.swift
//  Runner
//
//  Created by Isaac Santos on 17/11/22.
//

import Flutter
import Foundation
import UIKit
import VGSCollectSDK

class ActivateCardView: NSObject, FlutterPlatformView {
    // MARK: - Vars
    /// VGS Show instance.
    var vgsCollect: VGSCollect?
    
    /// Show view.
    let activateCardTextViews: ActivateCardTextViews
    
    /// Flutter binary messenger.
    let messenger: FlutterBinaryMessenger
    
    /// Flutter method channel.
    let channel: FlutterMethodChannel
    
    /// View id.
    let viewId: Int64
    
    init(messenger: FlutterBinaryMessenger,
         frame: CGRect,
         viewId: Int64,
         args: Any?) {
        self.messenger = messenger
        self.viewId = viewId
        self.activateCardTextViews = ActivateCardTextViews()
        
        self.channel = FlutterMethodChannel(name: "activate-card",
                                            binaryMessenger: messenger)
        super.init()
        
        
        guard let payload = args as? [String: Any],
              let vaultID = payload["vaultId"] as? String,
              let enviroment = payload["enviroment"] as? String else {
            assertionFailure("Invalid vaultId")
            return
        }
        
        let vgsCollect = VGSCollect(id: vaultID, environment: enviroment)
        self.activateCardTextViews.configureFieldsWithCollect(vgsCollect)
        self.vgsCollect = vgsCollect
        
        channel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "send-request":
                self?.sendRequest(with: call.arguments, result: result)
            case "isFormValid":
                self?.isFormValid(with: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    public func view() -> UIView {
        return activateCardTextViews
    }
    
    /// Redact card with Flutter result completion block object.
    /// - Parameter result: `FlutterResult` object, Flutter result completion block object.
    private func sendRequest(with args: Any?, result: @escaping FlutterResult)  {
        guard let payload = args as? [String: Any],
              let baasId = payload["baasId"] as? String,
              let token = payload["token"] as? String else {
            assertionFailure("Invalid tokens")
            return
        }
        vgsCollect?.customHeaders = ["Authorization": "Bearer " + token]
        
        vgsCollect?.sendData(path: "/cards/\(baasId)/activate", completion: { response in
            switch response {
            case .success(_, let data, _):
                if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    print("SUCCESS: \(jsonData)")
                    let payload: [String: Any] = [
                        "STATUS": "SUCCESS",
                        "DATA": jsonData
                    ]
                    result(payload)
                }
                return
            case .failure(let code, _, _, let error):
                var errorInfo: [String : Any] = [:]
                errorInfo["collect_error_code"] = code
                
                if let message = error?.localizedDescription {
                    errorInfo["collect_error_message"] = message
                }
                switch code {
                case 400..<499:
                    // Wrong request. This also can happend when your Routs not setup yet or your <vaultId> is wrong
                    print("Error: Wrong Request, code: \(code)")
                case VGSErrorType.inputDataIsNotValid.rawValue:
                    if let error = error as? VGSError {
                        
                        print("Error: Input data is not valid. Details:\n \(error)")
                    }
                default:
                    print("Error: Something went wrong. Code: \(code)")
                }
                print("Submit request error: \(code), \(String(describing: error))")
                
                let payload: [String: Any]  = [
                    "STATUS": "FAILED",
                    "ERROR": errorInfo
                ]
                result(payload)
                return
            }
        })
    }
        
        private func isFormValid(with result: @escaping FlutterResult) {
            let invalidFields = vgsCollect!.textFields.compactMap{$0.state.isValid}.filter({$0 == false})
            result(invalidFields.isEmpty)
        }
        
    }

