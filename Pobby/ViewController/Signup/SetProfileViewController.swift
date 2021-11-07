//
//  SetProfileViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/03.
//
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class SetProfileViewController: UIViewController {

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var nicknamefield: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var image : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray
        nextButton.layer.cornerRadius = 20
        nicknamefield.addTarget(self, action: #selector(SetProfileViewController.textFieldDidChange(_:)), for: .editingChanged)
        setupAvatar()
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let nickname = nicknamefield.text, !nickname.isEmpty else {
            self.nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(red: 152/255, green: 88/255, blue: 245/255, alpha: 1)

    }
    
    func setupAvatar() {
        Avatar.layer.cornerRadius = 40
        Avatar.clipsToBounds = true
        Avatar.backgroundColor = UIColor.gray
        Avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        Avatar.addGestureRecognizer(tapGesture)
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
                            "nickname":nicknamefield.text!,
                            "photoUrl":"gs://pobby-14be9.appspot.com/user_img/\(user?.email ?? "")"])
        self.performSegue(withIdentifier: "end", sender: self)

    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        }
    }

extension SetProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelectored = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageSelectored
            Avatar.image = imageSelectored
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageOriginal
            Avatar.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
