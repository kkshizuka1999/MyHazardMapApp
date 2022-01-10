//
//  SignUpViewController.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

//ユーザー登録画面
import UIKit
import FirebaseAuth
import Firebase

//各種ボタンやフィールドの配置
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
    
    //UI整理
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
        
        //全ての項目が記入されているかチェック
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" || LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
            
        }
        
        //パスワードの設定
        
        let CleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //パスワードが規定通りでなければエラーを返す
        if Utilities.isPasswordValid(CleanedPassword) == false {
            //Password isn't secure inough
            return "Please make sure your password is at least 8 characters, contains a special character and a number"
            
        }
        
        return nil
        
    }
    
    //画面の回転設定
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //登録ボタンがタップされてからの動き
    @IBAction func SignUpTaped(_ sender: Any) {
        //項目が全て入力されているか
        let error = validateFiedls()

        //入力が正しく行われているか（規定通りか）
        if error != nil {
            
            ErrorLabel.text = error!
            ErrorLabel.alpha = 1
            
        } else {
            
            //Firebase上に投げる情報を定義
            let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Firebaseにユーザー情報を作成
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
                //エラー処理
                if err != nil {
                
                //エラーがあれば返す
                    self.showError("Error creating user")
                    
                } else {
                    
                // ユーザー作成が成功したら, Firebaseに氏名を登録
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                    if error != nil {
                        //エラー処理
                        self.showError("Error saving user data")
                    }
                    
                }
                
                //ホーム画面へ遷移
                self.transitionToMap()
                    
                }
            }
        }
    }
    
    func showError(_ message: String) {
        
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
        
    }
    
    //画面遷移の設定
    func transitionToMap() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: "MapVC") as? MapViewController
        
        view.window?.rootViewController = mapViewController
        view.window?.makeKeyAndVisible()
        
    }
}

