//
//  editProfileVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/22.
//

import UIKit

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class editProfileVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var changebutton: UIButton!
    
    var image : UIImage? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfo()
        setupAvatar()
    }
    func setUserInfo(){
        let user = Auth.auth().currentUser
        var nickname = ""
        
        let docRef = Firestore.firestore().collection("User").document(user?.email ?? "")
        
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                nickname = document.get("nickname") as! String
                let photourl = document.get("photoUrl") as! String

                self.nickname.text = nickname
                let storage = Storage.storage()
                var reference: StorageReference!
                reference = storage.reference(forURL: photourl)
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.imageView.image = image ?? nil
                }
            } else {
                print("유저 정보가 없습니다.")
            }
        }

    }

    
    func setupAvatar() {
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.gray
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        imageView.addGestureRecognizer(tapGesture)
    }
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func InsertProfile(_ sender: Any) {
        let user = Auth.auth().currentUser
        guard let imageSelected = self.image else {
            print("선택된 이미지가 없습니다.")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        let storageRef = Storage.storage().reference(forURL: "gs://pobby-14be9.appspot.com/user_img")
        let storageProfileRef = storageRef.child(user?.email ?? "")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion: {(StorageMetadata,error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
        })
        let docRef = Firestore.firestore().collection("User").document(user?.email ?? "")
        docRef.updateData([
                            "nickname":nickname.text!,
                            "photoUrl":"gs://pobby-14be9.appspot.com/user_img/\(user?.email ?? "")"])
        self.performSegue(withIdentifier: "end", sender: self)

    }
}
    

extension editProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelectored = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageSelectored
            imageView.image = imageSelectored
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageOriginal
            imageView.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
