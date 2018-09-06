//
//  MMCardTextField.swift
//  MMTextField
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
    case none
}

extension MMCardType {
    
    var allowedNumberCount: Int {
        return self == .americanExpress ? 15 : 16
    }
    
    var seperatorCharectorCount: Int {
        return self == .americanExpress ? 2 : 3
    }
    
    var totalCharectorsCount: Int {
        return allowedNumberCount + seperatorCharectorCount
    }
}

protocol MMCardTextFieldDelegate {
    func image(forCardType type: MMCardType) -> UIImage?
}

@IBDesignable
public class MMCardTextField: UITextField, UITextFieldDelegate {
    
    var cardFieldDelegate: MMCardTextFieldDelegate?
    
    @IBInspectable var seperatorString: String = " " { // sepeartor charector
        didSet {
            designTextField()
        }
    }
    @IBInspectable var placeHolderString: String = "*" { // a placeholder format string based on card type
        didSet {
            designTextField()
        }
    }
    
    var currentCardType: MMCardType = .none

    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextField()
        designTextField()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextField()
        designTextField()
    }
    
    // MARK: - Private Helpers
    private func prepareTextField() {
        self.delegate = self
        self.borderStyle = .line
        setupCardImageView()
    }
    
    private func designTextField() {
       placeholder = placeHolderString(forCardType: currentCardType)
    }
    
    private func placeHolderString(forCardType cardType: MMCardType) -> String {
        var finalPlaceHolderString = ""
        for i in 1...cardType.totalCharectorsCount {
            if cardType != .americanExpress && i % 5 == 0 { // non amex card spacing
               finalPlaceHolderString += seperatorString
            } else if cardType == .americanExpress { // amex card
                if i == 5 || i == 12 { // hard coded for now, TODO: Find a equation here
                    finalPlaceHolderString += seperatorString
                }
            } else {
                finalPlaceHolderString += placeHolderString
            }
        }
        return finalPlaceHolderString
    }
    
    private func setupCardImageView() {
        let cardImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        cardImageView.backgroundColor = .green
        self.leftView = cardImageView
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard Int(string) != nil || string.count == 0 else { // handle space char
            return false
        }
        
        let newString = (text ?? "") + string
        if newString.count > currentCardType.totalCharectorsCount { // don't allow to exceed maximum charectors
           return false
        }
        
        // handle paste operation
        // assumption, paste happens on multiple charectors
        if string.count > 1 {
           let trimmedNumString = string.numericValues()
            if trimmedNumString.count == 0 {
                return false // as if no numbers on pasted string
            }
            // handle formatting
        }
        
        return true
    }
}

extension String {
    
    func numericValues() -> String {
        return self.filter { strChar in
            return Int("\(strChar)") == nil
        }
    }
    
    func alphabets() -> String {
        return self.filter { strChar in
            return Int("\(strChar)") != nil
        }
    }
}

