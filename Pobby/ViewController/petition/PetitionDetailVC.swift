//
//  PetitionDetailVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/14.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage


class PetitionDetailVC: UIViewController {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var petitionLabel: UILabel!
    @IBOutlet weak var contentsLabel: UITextView!
    @IBOutlet weak var signedProgress: UIProgressView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var signed: UILabel!
    
    var Petition : Petition?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()

        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        categoryLabel.text = Petition?.category
        titleLabel.text = Petition?.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: (Petition?.time)!)
        timeLabel.text = dateString
        petitionLabel.text = Petition?.petition
        contentsLabel.text = Petition?.contents
        signedProgress.clipsToBounds = true
        signedProgress.layer.cornerRadius = 12
        signed.text = "\(Petition?.signed ?? 0)명"
        let signed = Petition?.signed
        let fsigned = Float(signed!)
        signedProgress.setProgress(Float(fsigned/500), animated: false)
        
        let current = Date()
        let DL = Petition?.time ?? Date() + (86400 * 30)
        
        let timeInterval = DL.timeIntervalSince(current)
                    
        deadlineLabel.text = "마감까지 D - \(Int(timeInterval/86400)) "
        
        userimage.layer.cornerRadius = 20
        
        let docRef = Firestore.firestore().collection("User").document(Petition?.userID ?? "")
        
        docRef.getDocument{ [self] (document, error) in
            if let document = document, document.exists {
                self.userLabel.text = document.get("nickname") as! String
                let photourl = document.get("photoUrl") as! String

                let storage = Storage.storage()
                var reference: StorageReference!
                reference = storage.reference(forURL: photourl)
                reference.downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.userimage.image = image ?? nil
                }
        
            }
     }
    }

    @IBAction func signedPetition(_ sender: Any) {
        let db = Firestore.firestore()
        var documentid = ""
        db.collection("Petition").whereField("petition",isEqualTo: Petition?.petition!)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    documentid = document.documentID
                    let Ref = db.collection("Petition").document(documentid)
                    Ref.updateData([
                        "signed":(Petition?.signed)! + 1
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
        }
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(withIdentifier: "signedPopUPVC")
        popupVC.modalPresentationStyle = .overCurrentContext
        present(popupVC, animated: true, completion: nil)
    }
    
    }



