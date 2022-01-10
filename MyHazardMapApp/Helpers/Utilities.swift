//
//  Utilities.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

import Foundation
import UIKit

//UIの規格を整理
class Utilities {
    //テキストフィールド
    static func styleTextField(_ textfield: UITextField) {
        
        //下線を生成
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        //テキストフィールドからボーダーを削除
        textfield.borderStyle = .none
        
        //テキストフィールドにラインを追加
        textfield.layer.addSublayer(bottomLine)
        
    }
    //テキストビュー
    static func styleTextView(_ textview: UITextView) {
        // 枠のカラー
        textview.layer.borderColor = UIColor.black.cgColor

        // 枠の幅
        textview.layer.borderWidth = 1.0

        // 枠を角丸に
        textview.layer.cornerRadius = 10.0
        textview.layer.masksToBounds = true
    }
    
    //スタックビュー
    static func styleStackView(_ stackView: UIStackView) {
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.black.cgColor
    }
    
    //イメージビュー
    static func styleImageView(_ imageView: UIImageView) {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
    }
    
    //フィールドボタン
    static func styleFilledButton(_ button: UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        
    }
    
    //へこんだボタン
    static func styleHollowButton(_ button: UIButton) {
        
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    
    //情報追加ボタン
    static func styleAddInformationButton(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 27.5
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    //ログアウトボタン
    static func styleLogOutButton(_ button: UIButton) {
        
        //Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 15
        button.tintColor = UIColor.white
        
    }
    
    //パスワードの規定を設定
    static func isPasswordValid(_ password: String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
}
