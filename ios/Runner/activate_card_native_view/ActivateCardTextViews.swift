//
//  ActivateCardTextViews.swift
//  Runner
//
//  Created by Isaac Santos on 17/11/22.
//

import Foundation
import UIKit
import VGSCollectSDK

/// Holds UI for custom card data collect view case.
class ActivateCardTextViews: UIView {

  // MARK: - Vars
  /// Stack view.
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical

    stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    stackView.distribution = .fill
    stackView.spacing = 16
    return stackView
  }()

    /// CVC text field.
  lazy var cvcTextField: VGSCVCTextField = {
    let field = VGSCVCTextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    field.cornerRadius = 8
    field.borderColor = UIColor(red: 0.02, green: 0.69, blue: 0.32, alpha: 1.00)
    field.font = UIFont.systemFont(ofSize: 15)
    // Update validation rules
    field.placeholder = "CVC/CVV"

    return field
  }()

  /// Exp date text field.
  lazy var expDateField: VGSExpDateTextField = {
    let field = VGSExpDateTextField()
    
    field.translatesAutoresizingMaskIntoConstraints = false
    field.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    field.cornerRadius = 8
    field.borderColor = UIColor(red: 0.02, green: 0.69, blue: 0.32, alpha: 1.00)
    field.font = UIFont.systemFont(ofSize: 15)
    // Update validation rules
    field.placeholder = "YYYY/MM"
    field.monthPickerFormat = .numbers
    field.yearPickeFormat = .long
    

    return field
  }()

  // MARK: - Initialization
  // no:doc
  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(stackView)
    stackView.addArrangedSubview(cvcTextField)
    stackView.addArrangedSubview(expDateField)

    cvcTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
    expDateField.heightAnchor.constraint(equalToConstant: 45).isActive = true
    cvcTextField.widthAnchor.constraint(equalToConstant: 240).isActive = true
    expDateField.widthAnchor.constraint(equalToConstant: 240).isActive = true
  }

  // no:doc
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public
  /// Configure fields with VGS Collect instance.
  /// - Parameter vgsCollect: `VGSCollect` object, VGS Collect instance.
  func configureFieldsWithCollect(_ vgsCollect: VGSCollect) {

    let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "data.attributes.expirationDate")
    expDateConfiguration.isRequiredValidOnly = true
    expDateConfiguration.type = .expDate
    expDateConfiguration.inputSource = .keyboard
    expDateConfiguration.inputDateFormat = .longYearThenMonth
    expDateConfiguration.outputDateFormat = .longYearThenMonth
    // Default .expDate format is "##/##"
    expDateConfiguration.formatPattern = "####/##"
    expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
        VGSValidationRuleCardExpirationDate(dateFormat: .longYearThenMonth, error: VGSValidationErrorType.expDate.rawValue)
    ])
      
    let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.cvv2")
    cvcConfiguration.isRequired = true
    cvcConfiguration.type = .cvc

    cvcTextField.configuration = cvcConfiguration
    expDateField.configuration = expDateConfiguration
  }
}
