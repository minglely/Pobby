//
//  UserProfile.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/02.
//

import Foundation

struct UserProfile {
    var userId: String
    var emailAddress: String
    var fullName: String
    var profilePhotoURL: String
   
    // MARK: - Firebase Keys
    
    enum UserInfoKey {
        static let email = "email"
        static let name = "name"
        static let profilePhotoURL = "profilePhotoURL"
        static let age = "age"
    }
    
    
    init(userId: String, fullName: String, emailAddress: String, profilePicture: String) {
        self.userId = userId
        self.emailAddress = emailAddress
        self.fullName = fullName
        self.profilePhotoURL = profilePicture
    }
    
//    init?(userId: String, userInfo: [String: Any]) {
//        let fullname = userInfo[UserInfoKey.name] as? String ?? ""
//        let dateJoined = userInfo[UserInfoKey.dateJoined] as? Int ?? 0
//        let photoURL = userInfo[UserInfoKey.photoURL] as? String ?? ""
//        let emailAddress = userInfo[UserInfoKey.email] as? String ?? ""
//        self = UserProfile(userId: userId, fullName: fullname, emailAddress: emailAddress, profilePicture: profilePhotoURL)
//    }
}
