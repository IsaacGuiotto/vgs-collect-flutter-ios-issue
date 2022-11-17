//
//  ActivateCardPlugin.swift
//  Runner
//
//  Created by Isaac Santos on 17/11/22.
//

import Flutter
import Foundation

class ActivateCardPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = ActivateCardFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "activate-card-view")
    }
    
}
