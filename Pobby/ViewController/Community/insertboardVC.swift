//
//  insertboardVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/21.
//

import UIKit
import DropDown

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class insertboardVC: UIViewController {
    
    let dropDown = DropDown()

    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var Contents: UITextView!
    @IBOutlet weak var selectedImage: UILabel!
    
    var image : UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        TitleField.setUnderLine()
        Contents.layer.borderWidth = 0.5
        Contents.layer.cornerRadius = 11
        Contents.layer.borderColor = UIColor.gray.cgColor
        UploadButton.layer.cornerRadius = 20
        
    }
    
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {//3
      dropDown.dataSource = ["후기", "양도", "나눔", "용병 교환", "건의 사항","기타 잡담"]//4
      dropDown.anchorView = sender //5
      dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
      dropDown.show() //7
      dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
        guard let _ = self else { return }
        sender.setTitle(item, for: .normal) //9
      }
    }
    @IBAction func insertImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func insertBoard(_ sender: Any) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        let user = Auth.auth().currentUser
        if selectedImage.text != nil ,let imageSelected = self.image {
            guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
            let storageRef = Storage.storage().reference(forURL: "gs://pobby-14be9.appspot.com/board")
            let storageProfileRef = storageRef.child(selectedImage.text!)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metadata, completion: {(StorageMetadata,error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
            })
        }
        
        ref = db.collection("Board").addDocument(data: [
            "category": self.dropDown.selectedItem!,
            "title": self.TitleField.text!,
            "contents":self.Contents.text!,
            "date": Timestamp(date: Date()),
            "view": 0,
            "userID": user?.email ?? "",
            "photoUrl" : "gs://pobby-14be9.appspot.com/board/\(selectedImage.text!)",
            "comment" : [],
            "commentN" : 0
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
}


extension insertboardVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelectored = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageSelectored
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageOriginal
        }
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            selectedImage.text = url.lastPathComponent
            }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
