//
//  Information.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/11/30.
//

import Foundation
import Firebase

class Information {
    
    let PlaceLatitude: String
    let PlaceLongitude: String
    let PlaceName: String
    let createdAt: Timestamp
    let detailInformation: String
    let imageURL: String
    let postID: String
    let updatedAt: Timestamp
    let userId: String
    
    init(dic: [String: Any]) {
        
        self.PlaceLatitude = dic["PlaceLatitude"] as? String ?? ""
        self.PlaceLongitude = dic["PlaceLongitude"] as? String ?? ""
        self.PlaceName = dic["PlaceName"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.detailInformation = dic["detailInformation"] as? String ?? ""
        self.imageURL = dic["imageURL"] as? String ?? ""
        self.postID = dic["postID"] as? String ?? ""
        self.updatedAt = dic["updatedAt"] as? Timestamp ?? Timestamp()
        self.userId = dic["UserID"] as? String ?? ""
    }
    
}
