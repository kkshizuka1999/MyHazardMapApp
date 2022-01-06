//
//  InformationViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/12/07.
//

import UIKit
import Firebase
import Nuke

class InformationViewController: UIViewController {
    
    var markerID: String!

    @IBOutlet weak var stackViewForInformation: UIStackView!
    
    @IBOutlet weak var textview: UITextView!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var placename: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        textview.isEditable = false
        textview.isSelectable = false
        
        Firestore.firestore().collection("informations").document(markerID ?? "").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let information = Information.init(dic: dataDescription ?? [:])
                let url = URL(string: information.imageURL)
                
                Nuke.loadImage(with: url!, into: self.ImageView)
                
                self.placename.text = information.PlaceName
                
                self.textview.text = information.detailInformation
                
            } else {
                print("Document does not exist")
            }
            
        }

        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    // 回転方向の指定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setUpElements() {
        
        // Style the elements
        Utilities.styleTextView(textview)
        Utilities.styleImageView(ImageView)

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
