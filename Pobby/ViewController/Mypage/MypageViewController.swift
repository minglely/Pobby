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
import FirebaseStorage


class MypageViewController: UIViewController {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var Myboard: UIView!
    @IBOutlet weak var Mycomment: UIView!
    
    @IBOutlet weak var MyPetition: UIView!
    @IBOutlet weak var MyprofileEdit: UIView!
    @IBOutlet weak var Myhelp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        profileImage.layer.cornerRadius = 50

        setUserInfo()
    }
    
    func setUserInfo(){
        let user = Auth.auth().currentUser
        var nickname = ""
        
        let docRef = Firestore.firestore().collection("User").document(user?.email ?? "")
        
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                nickname = document.get("nickname") as! String
                let photourl = document.get("photoUrl") as! String

                self.nicknameLabel.text = nickname
                if( photourl != ""){
                    let storage = Storage.storage()
                    var reference: StorageReference!
                    reference = storage.reference(forURL: photourl)
                    reference.downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        self.profileImage.image = image ?? nil
                }
                }
            } else {
                print("유저 정보가 없습니다.")
            }
        }

    }
    
    
    
    @IBAction func logouttouch(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
        try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)}
        
        
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let loginNavController = storyboard.instantiateViewController(identifier: "LoginViewController")

           (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }

    @IBAction func gotoMyboard(_ sender: Any) {
    }
    @IBAction func gotoMycomment(_ sender: Any) {
    }
    
}
