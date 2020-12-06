//
//  InformationViewController.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/12/07.
//

import UIKit
import Firebase

class InformationViewController: UIViewController {
    
    var markerID: String!

    @IBOutlet weak var testtextview: UITextView!
    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("informations").document(markerID ?? "").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let information = Information.init(dic: dataDescription ?? [:])
                
                self.testtextview.text = information.PlaceName
                
                
            } else {
                print("Document does not exist")
            }
            
        }

        // Do any additional setup after loading the view.
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
