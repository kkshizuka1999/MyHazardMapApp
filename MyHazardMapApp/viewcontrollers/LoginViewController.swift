//
//  LoginViewController.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        
        //Hide the error label
        ErrorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleFilledButton(LoginButton)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func validateFiedls() -> String? {
        
        //Check that all fields are filled in
        if EmailTextField.text?.trimmingCharacters(in: .whitespaces) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
            
        }
        
        return nil
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    @IBAction func LoginTaped(_ sender: Any) {
        
        //validate text fields
        
        let error = validateFiedls()

        //There is something wrong with the fields, show error message
        if error != nil {
            
            ErrorLabel.text = error!
            ErrorLabel.alpha = 1
            
        } else {
            
            //create cleaned versions of the data
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    
                    // Couldn't sign in
                    self.ErrorLabel.text = error!.localizedDescription
                    
                    self.ErrorLabel.alpha = 1
                    
                } else {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mapViewController = storyboard.instantiateViewController(identifier: "MapVC") as? MapViewController
                    
                    self.view.window?.rootViewController = mapViewController
                    
                    self.view.window?.makeKeyAndVisible()
                    
                }
            }
        }
    }
}
