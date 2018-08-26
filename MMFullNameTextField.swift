//
//  MMNameTextField.swift
//  Entrada
//
//  Created by Muthuraj Muthulingam on 23/08/18.
//  Copyright © 2018 Entrada, Inc. All rights reserved.
//

import UIKit

@IBDesignable
class MMFullNameTextField: UITextField {
    
    @IBInspectable private var seperator: String = " " // space char by default
    
    // for initialization through Code
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    // for initiziation through Xib/Storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.delegate = self
        autocorrectionType = .no
        autocapitalizationType = .words
    }
}

extension MMFullNameTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        debugPrint("Text field started editing")
    }
    
    // As we need control over this method, it is necessary to call it when overriden
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Avoid space at the beginning
        if (self.text == nil  || self.text == "") && string == " " {
            return  false
        }
        
        // Avoid having numerical charector
        if let _ = Int(string) {
            return false
        }
        
        // handle paste operation
        if string.count > 1 { // assuming paste operation happens on multiple charectors
            self.text = string.trim(numbers: false)
            return false
        }
        
        // Avoid having more than one seperator in the string
        if  let currentText = self.text,
            currentText.contains(seperator) && string == " " {
            return false
        }
        
        // construct formal string and return
        if let currentString = self.text,
            !currentString.isEmpty,
            string == " " {
            // replace string with preferred seperator
            self.text = currentString + seperator
            return false
        }
        
        // free to change the charector
        return true
    }
}

extension String {
    
    func trim(numbers: Bool) -> String {
        return self.filter { strChar in
            return  numbers ? Int("\(strChar)") == nil : Int("\(strChar)") != nil
        }
    }
}
