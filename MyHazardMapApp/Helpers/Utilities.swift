//
//  Utilities.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

import Foundation
import UIKit

class Utilities {
    static func styleTextField(_ textfield: UITextField) {
        
        //Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        //Remove border on text field
        textfield.borderStyle = .none
        
        //Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleTextView(_ textview: UITextView) {
        // 枠のカラー
        textview.layer.borderColor = UIColor.black.cgColor

        // 枠の幅
        textview.layer.borderWidth = 1.0

        // 枠を角丸にする場合
        textview.layer.cornerRadius = 10.0
        textview.layer.masksToBounds = true
    }
    
    static func styleStackView(_ stackView: UIStackView) {
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
    }
    
    static func styleImageView(_ imageView: UIImageView) {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    static func styleFilledButton(_ button: UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleHollowButton(_ button: UIButton) {
        
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    
    static func styleAddInformationButton(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 27.5
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    static func styleLogOutButton(_ button: UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.white
        
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
}
