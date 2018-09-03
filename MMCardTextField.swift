//
//  MMCardTextField.swift
//  NetworkTemplate
//
//  Created by Muthuraj Muthulingam on 03/09/18.
//  Copyright © 2018 Muthuraj Muthulingam. All rights reserved.
//

import UIKit

enum MMCardType {
    case visa
    case masterCard
    case maestro
    case jcb
    case discover
    case americanExpress
    
    var cardNumberCount: Int {
        return self == .americanExpress ? 15 : 16
    }
}

protocol MMCardTextFieldDelegate {
    func image(forCardType type: MMCardType) -> UIImage?
}

@IBDesignable
public class MMCardTextField: UITextField, UITextFieldDelegate {
    
    var cardFieldDelegate: MMCardTextFieldDelegate?
    
    @IBInspectable var seperatorString: String = " "
    var currentCardType: MMCardType? = nil

    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextField()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextField()
    }
    
    // MARK: - Private Helpers
    private func prepareTextField() {
        self.delegate = self
        setupCardImageView()
    }
    
    private func setupCardImageView() {
        let cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cardImageView.backgroundColor = .green
        self.leftView = cardImageView
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let _ = Int(string) else {
            return false
        }
        
        // handle paste operation
        // assumption, paste happens on multiple charectors
        if string.count > 1 {
           let trimmedNumString = string.trim(numbers: true)
            if trimmedNumString.count == 0 {
                return false // as if no numbers on pasted string
            }
            // handle formatting
        }
        
        return true
    }
}
