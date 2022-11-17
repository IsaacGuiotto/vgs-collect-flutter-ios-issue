//
//  ActivateCardFactory.swift
//  Runner
//
//  Created by Isaac Santos on 17/11/22.
//

import Flutter
import Foundation

class ActivateCardFactory: NSObject, FlutterPlatformViewFactory {
    // MARK: - Private vars
      /// Flutter binary messenger.
      private var messenger: FlutterBinaryMessenger

      // MARK: - Initialization
      /// Initializer.
      /// - Parameter messenger: `FlutterBinaryMessenger` object, Flutter binary messenger.
      init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
      }

      // MARK: - FlutterPlatformViewFactory
      // no:doc
      public func create(withFrame frame: CGRect,
                         viewIdentifier viewId: Int64,
                         arguments args: Any?) -> FlutterPlatformView {
        return ActivateCardView(messenger: messenger,
                                  frame: frame, viewId: viewId,
                                  args: args)
      }

      // no:doc
      public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
      }
}

