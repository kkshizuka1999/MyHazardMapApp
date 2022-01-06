//
//  SignUpViewController.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

import UIKit
import FirebaseAuth
import Firebase


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
        
    @IBOutlet weak var LastNameTextField: UITextField!
        
    @IBOutlet weak var EmailTextField: UITextField!
        
    @IBOutlet weak var PasswordTextField: UITextField!
        
    @IBOutlet weak var SignUpButton: UIButton!
        
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    
    func setUpElements() {
        
        // Hide the error label
        ErrorLabel.alpha = 0
        
        // style the elements
        Utilities.styleTextField(FirstNameTextField)
        Utilities.styleTextField(LastNameTextField)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleFilledButton(SignUpButton)
        
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
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" || LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
            
        }
        
        //Check if the password is secure
        
        let CleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(CleanedPassword) == false {
            //Password isn't secure inough
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
            
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
    
    @IBAction func SignUpTaped(_ sender: Any) {
        //Validate the fields
        let error = validateFiedls()

        //There is something wrong with the fields, show error message
        if error != nil {
            
            ErrorLabel.text = error!
            ErrorLabel.alpha = 1
            
        } else {
            
            //create cleaned versions of the data
            let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
                //check for errors
                if err != nil {
                
                //there was an error creating the user
                    self.showError("Error creating user")
                    
                } else {
                    
                // User was created successfully, now store the firest name and last name
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                    if error != nil {
                        //Show error message
                        self.showError("Error saving user data")
                    }
                    
                }
                
                //Transition to the home screen
                self.transitionToMap()
                    
                }
            }
        }
    }
    
    func showError(_ message: String) {
        
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
        
    }
    
    func transitionToMap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: "MapVC") as? MapViewController
        
        view.window?.rootViewController = mapViewController
        view.window?.makeKeyAndVisible()
        
    }
}

