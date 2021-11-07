//
//  boardDetailVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/20.
//

import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class boardDetailVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var boardD = Board(comments: [])

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contents: UITextView!
    
    @IBOutlet weak var commentcount: UILabel!
    @IBOutlet weak var commentInput: UITextView!
    @IBOutlet weak var commentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        setView()

    }
    
    func setView() {
        titleLabel.text = "[\(boardD.category!)] \(boardD.title!)"
        commentLabel.text = "\(boardD.comments.count)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from:boardD.date!)
        timeLabel.text = time
        viewLabel.text = "\(boardD.view!)"
        contents.text = boardD.contents
        adjustUITextViewHeight(arg: contents)
        
        let storage = Storage.storage()
        var reference: StorageReference!
        reference = storage.reference(forURL: boardD.photo!)
        reference.downloadURL { (url, error) in
            if url != nil{
                let data = NSData(contentsOf: url!)
                if let image = UIImage(data: data! as Data)
                {
                    self.imageView.image = image
                }
            } else {
                print("들어오나요?")
                self.imageView.autoresizesSubviews = true;
                self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.imageView.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: 2)
            }

        }
        
        commentcount.text = "\(boardD.comments.count)"
        
        commentInput.layer.cornerRadius = 15
        commentInput.layer.borderWidth = 1
        commentInput.layer.borderColor = UIColor.lightGray.cgColor
        
        commentCollectionView.frame = CGRect(x: 0, y: 0, width: 334,         height: commentCollectionView.contentSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        boardD.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = commentCollectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath as IndexPath) as! commentCell
        cell.backView.layer.cornerRadius = 15
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let userID = boardD.comments[indexPath.row].userID {
            let docRef = Firestore.firestore().collection("User").document(userID)
            docRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    cell.nickname.text = document.get("nickname") as? String ?? ""
                } else {
                print("유저 정보가 없습니다.")
            }
            }
            
        }
            
        cell.comment.text = "\(boardD.comments[indexPath.row].contents!)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd HH:mm"
        let time = dateFormatter.string(from:boardD.comments[indexPath.row].date!)
        cell.time.text = time
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 334, height: 118)
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func updateComment()
    {
        boardD.comments.removeAll()
        let db = Firestore.firestore()
        db.collection("Board").whereField("title",isEqualTo: boardD.title!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let documentData = document.data()
                        let comments = documentData["comment"] as! [[String: Any]]
                        for (_,comment) in comments.enumerated()
                        {
                            var c = Board.comment()
                            if let Contents = comment["contents"] as? String  {
                                c.contents = Contents
                            }
                            if let ID = comment["userID"] as? String {
                                c.userID = ID
                            }
                            if let Date = comment["date"] as? Timestamp {
                                c.date = Date.dateValue()
                            }
                            self.boardD.comments.append(c)
                            print(self.boardD.comments.count)
                        }
                    }
                }
                self.commentLabel.text = "\(self.boardD.comments.count)"
                self.commentcount.text = "\(self.boardD.comments.count)"
                
                self.commentCollectionView.reloadData()
                self.commentCollectionView.collectionViewLayout.invalidateLayout()
                self.commentCollectionView.layoutSubviews()
            }



    }
    
    
    @IBAction func insertComment(_ sender: Any) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
    
        db.collection("Board").whereField("title",isEqualTo: boardD.title!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                for document in querySnapshot!.documents {
                    let documentid = document.documentID
                    let Ref = db.collection("Board").document(documentid)
                    Ref.updateData([
                        "comment": FieldValue.arrayUnion([[
                            "contents" : self.commentInput.text!,
                            "date" : Date(),
                            "userID" : user?.email! as Any
                        ]]),
                        "commentN" : self.boardD.comments.count + 1
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            self.updateComment()
                            
                        }
                    }
                }
            }
        }
    
    }
    

}
