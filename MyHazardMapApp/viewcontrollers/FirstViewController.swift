//
//  ViewController.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

import UIKit

class FirstViewController: UIViewController {

    //ユーザー登録ボタン配置
    @IBOutlet weak var SignUpButton: UIButton!
    
    //ログインボタン配置
    @IBOutlet weak var LoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    //UI設定
    func setUpElements() {
        
        Utilities.styleFilledButton(SignUpButton)
        Utilities.styleHollowButton(LoginButton)
        
    }
    
    //画面の回転設定
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

