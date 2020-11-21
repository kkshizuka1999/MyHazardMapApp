//
//  addInformationViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/11/21.
//

import UIKit
import CropViewController

class addInformationViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var ImageButton: UIButton!
    
    @IBOutlet weak var TextView: UITextView!
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    
    @IBAction func ImageButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageButton.contentMode = .scaleAspectFit
        if let editImage = info[.editedImage] as? UIImage {
            ImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            ImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        // Style the elements
        Utilities.styleTextView(TextView)
        Utilities.styleImageButton(ImageButton)
        Utilities.styleFilledButton(RegisterButton)
        Utilities.styleHollowButton(CancelButton)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
