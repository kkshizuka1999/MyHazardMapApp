//
//  ViewController.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(SignUpButton)
        Utilities.styleHollowButton(LoginButton)
        
    }
    
    


}

