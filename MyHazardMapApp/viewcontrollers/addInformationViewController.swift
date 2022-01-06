//
//  addInformationViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import CropViewController

class addInformationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
    
    @IBOutlet weak var StackViewforImage: UIStackView!
    
    @IBOutlet weak var placeNameTextField: UITextField!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var CameraButton: UIButton!
    
    @IBOutlet weak var LibraryButton: UIButton!
    
    @IBOutlet weak var TextView: UITextView!
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    var image: UIImage?
    
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "pushMapForAdd", sender: nil)
        
    }
    
    @IBAction func CamButtonTapped(_ sender: Any) {
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func LibButtonTapped(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func CancelButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushMapForAdd" {
            let vc = segue.destination as? mapForAddViewController
            // 遷移先のクラスのプロパティに値を代入する
            vc?.pickedImage = ImageView.image
            vc?.placeName = placeNameTextField.text
            vc?.information = TextView.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    func setUpElements() {
        
        // Style the elements
        Utilities.styleTextView(TextView)
        Utilities.styleStackView(StackViewforImage)
        Utilities.styleImageView(ImageView)
        Utilities.styleFilledButton(RegisterButton)
        Utilities.styleHollowButton(CancelButton)
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
