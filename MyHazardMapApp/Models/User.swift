//
//  User.swift
//  MyHazardMapApp
//
//  Created by IKEchannel on 2020/11/24.
//

import Foundation

class User {
    
    let uid: String
    let lastname: String
    let firstname: String
    
    init(dic: [String: Any]) {
        
        self.uid = dic["uid"] as? String ?? ""
        self.lastname = dic["lastname"] as? String ?? ""
        self.firstname = dic["firstname"] as? String ?? ""
        
    }
    
}
