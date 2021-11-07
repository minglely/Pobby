//
//  WritePetitionVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/13.
//

import UIKit
import DropDown

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class WritePetitionVC: UIViewController, UITextViewDelegate {

    let dropDown = DropDown()

    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var PetitionField: UITextField!
    @IBOutlet weak var UploadButton: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var Contents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]

        placeholderSetting()
        
    }
    override func viewWillLayoutSubviews() {
        TitleField.setUnderLine()
        PetitionField.setUnderLine()
        Contents.layer.borderWidth = 0.5
        Contents.layer.cornerRadius = 11
        Contents.layer.borderColor = UIColor.gray.cgColor
        UploadButton.layer.cornerRadius = 20
        
    }
    
    //카테고리선택 드롭박스
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {//3
      dropDown.dataSource = ["DVD", "OST", "기타 MD"]//4
      dropDown.anchorView = sender //5
      dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
      dropDown.show() //7
      dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
        guard let _ = self else { return }
        sender.setTitle(item, for: .normal) //9
      }
    }
    
    //텍스트 뷰 설정
    func placeholderSetting() {
     Contents.delegate = self // txtvReview가 유저가 선언한 outlet
     Contents.text = "추가로 기입하실 내용이 있다면 작성해주세요.\n원하는 부분이 있을 경우, 자세하게 적어주시면 상품 펀딩까지 이어지는데 더 효과적입니다!"
     Contents.textColor = UIColor.lightGray
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if Contents.textColor == UIColor.lightGray {
         Contents.text = nil
         Contents.textColor = UIColor.black
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if Contents.text.isEmpty {
         Contents.text = "추가로 기입하실 내용이 있다면 작성해주세요.\n원하는 부분이 있을 경우, 자세하게 적어주시면 상품 펀딩까지 이어지는데 더 효과적입니다!"
         Contents.textColor = UIColor.lightGray
        }
    }
 
    
    @IBAction func savepetition(_ sender: Any) {
        // 데이터 전송하기
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        //유저 닉네임 받기
        let user = Auth.auth().currentUser
        ref = db.collection("Petition").addDocument(data: [
            "category": self.dropDown.selectedItem!,
            "title": self.TitleField.text!,
            "petition":self.PetitionField.text!,
            "contents":self.Contents.text!,
            "time": Timestamp(date: Date()),
            "signed": 0,
            "userID": user?.email ?? "",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
            }
            
        }
        navigationController?.popViewController(animated: true)

    }
 
}

extension UITextField {
    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width-10, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


