//
//  UserProfile.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/02.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct User {

    // MARK: - Properties

    let email: String
    let photoUrl: String?
    let nickname: String

    // MARK: - Init
    
    init (value: [String: Any] ) {
        self.email = value["email"] as! String
        self.nickname = value["nickname"] as! String
        self.photoUrl = value["photoUrl"] as? String
      }
    
    func InsertUser(){
        
    }
}




