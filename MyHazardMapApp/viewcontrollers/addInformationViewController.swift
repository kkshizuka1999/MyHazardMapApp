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
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var CameraButton: UIButton!
    
    @IBOutlet weak var LibraryButton: UIButton!
    
    @IBOutlet weak var TextView: UITextView!
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    
    let imagePickerController = UIImagePickerController()
    
    var image: UIImage?
    
    @IBAction func RegisterButtonTapped(_ sender: Any) {
        saveToFireStore()
        dismiss(animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        // Do any additional setup after loading the view.
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
    
    fileprivate func upload(completed: @escaping(_ url: String?) -> Void) {
        let date = NSDate()
        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
        let storageRef = Storage.storage().reference().child("images").child("\(currentTimeStampInSecond).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.ImageView.image?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if error != nil {
                    completed(nil)
                    print("error: \(String(describing: error?.localizedDescription))")
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        completed(nil)
                        print("error: \(String(describing: error?.localizedDescription))")
                    }
                    completed(url?.absoluteString)
                })
            }
        }
    }
    
    fileprivate func saveToFireStore(){
        var imageURL: [String : Any] = [:]
        let content = TextView.text
        upload(){ url in
            guard let url = url else { return }
            imageURL["image"] = url
            let saveDocument = Firestore.firestore().collection("informations").document()
            saveDocument.setData([
                "imageURL": imageURL,
                "content": content as Any,
                "postID": saveDocument.documentID,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp()
            ]){ error in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                }
                print("image saved!")
            }
        }
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
