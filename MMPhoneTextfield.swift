//
//  MMPhoneTextfield.swift
//  NetworkTemplate
//
//  Created by Muthuraj Muthulingam on 26/08/18.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

class MMPhoneTextfield: UITextField {
    
    var phoneFieldUpdated: ((_ isValidEmail: Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.delegate = self
        autocapitalizationType = .none
        autocorrectionType = .default
        keyboardType = .numberPad
    }
}

extension MMPhoneTextfield: CustomTextFieldRules {
    func isValid() -> Bool {
        return self.text?.isValidPhone() ?? false
    }
}

extension MMPhoneTextfield: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // don't allow space char
        if string == " " {
            return false
        }
        
        // don't allow non numeric charector
        if Int(string) == nil && string != ""  {
            // not numberhh
           return false
        }
        
        // handle paste operation
        if string.count > 1 { // assuming paste operation happens on multiple charectors
            self.text = string.trim(numbers: false)
            return false
        }
        
        // give away event to receivers
        if let unwrappedPhoneCallbakClosure = phoneFieldUpdated,
            let unwrappedText = self.text {
            let newText = unwrappedText + string
            unwrappedPhoneCallbakClosure(newText.isValidPhone())
        }
        return true
    }
}
