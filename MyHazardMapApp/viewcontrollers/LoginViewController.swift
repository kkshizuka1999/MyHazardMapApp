//
//  LoginViewController.swift
//  CustomLonginDemo
//
//  Created by IKEchannel on 2020/11/07.
//

//ログイン画面
import UIKit
import FirebaseAuth
import Firebase

//各種ボタンやフィールドの配置
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
    
    //UI整理
    func setUpElements() {
        
        //エラーラベルを隠す
        ErrorLabel.alpha = 0
        
        // 各種設定
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
        
        //全ての項目が入力されているか確認
        if EmailTextField.text?.trimmingCharacters(in: .whitespaces) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            //されてなかったらエラーを返す
            return "Please fill in all fields."
            
        }
        
        return nil
        
    }
    
    //画面回転の設定
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //ログインボタンがタップされてからの動き
    @IBAction func LoginTaped(_ sender: Any) {
        
        //項目が全て入っているか確認
        
        let error = validateFiedls()

        //項目に不備があればエラーを返す
        if error != nil {
            
            ErrorLabel.text = error!
            ErrorLabel.alpha = 1
            
        } else {
            
            //Firebaseに投げる情報を定義
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //サインイン（入力情報とDB上の情報を照合）
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    
                    // エラー処理
                    self.ErrorLabel.text = error!.localizedDescription
                    
                    self.ErrorLabel.alpha = 1
                    
                } else {
                    
                    //画面遷移
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mapViewController = storyboard.instantiateViewController(identifier: "MapVC") as? MapViewController
                    
                    self.view.window?.rootViewController = mapViewController
                    
                    self.view.window?.makeKeyAndVisible()
                    
                }
            }
        }
    }
}
