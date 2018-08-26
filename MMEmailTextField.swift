//
//  MMEmailTextField.swift
//  NetworkTemplate
//
//  Created by Muthuraj Muthulingam on 23/08/18.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

protocol ValidityRules {
    func isValid() -> Bool
}

protocol CustomTextFieldRules: ValidityRules {
    func initialize()
}

extension CustomTextFieldRules where Self: UITextField {
    func initialize() {
        self.delegate = self as? UITextFieldDelegate
        autocapitalizationType = .none
        autocorrectionType = .default
    }
}

public class MMEmailTextField: UITextField {
    
    var emailFieldUpdated: ((_ isValidEmail: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
}

extension MMEmailTextField: CustomTextFieldRules {
    func isValid() -> Bool {
        return self.text?.isValidEmail() ?? false
    }
}

extension MMEmailTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let unwrappedEmailCallbakClosure = emailFieldUpdated,
            let unwrappedText = self.text {
            let newText = unwrappedText + string
            unwrappedEmailCallbakClosure(newText.isValidEmail())
        }
        return true
    }
}

extension String {
    func isValidEmail() -> Bool {
        return validate(against: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    func isValidPhone() -> Bool {
        return validate(against: "^\\d{3}-\\d{3}-\\d{4}$")
    }
    
    private func validate(against regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}
