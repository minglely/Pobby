//
//  MypageViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/03.
//

import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class MypageViewController: UIViewController {

    @IBOutlet weak var test: UIButton!
    @IBOutlet weak var testlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfo()
    }
    
    
    
    func setUserInfo(){
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
            testlabel.text = email
        }
    }
    
    
    
    @IBAction func logouttouch(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
        try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)}
    }


}
