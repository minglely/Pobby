//
//  mycommentVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class mycommentVC: UIViewController {
    
    @IBOutlet weak var mycommentBoard: UITableView!
    
    var mycommentboardArray = [Board]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mycommentBoard.delegate = self
        mycommentBoard.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        getmycommentData()
    }
    
    func getmycommentData() {
        self.mycommentboardArray.removeAll()
        
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        
        db.collection("Board").whereField("commentN",isGreaterThan: 0)
            .getDocuments() { ( querySnapshot, error) in
        if let error = error {
            print(error.localizedDescription)
        }else {
            for document in querySnapshot!.documents {
                let documentData = document.data()

                let comments = documentData["comment"] as! [[String: Any]]
                for (_,comment) in comments.enumerated()
                {
                    if user?.email == comment["userID"] as? String
                    {
                        var board = Board(comments: [])
                        board.category = (documentData["category"] as! String)
                        board.title = (documentData["title"] as! String)
                        board.contents = (documentData["contents"] as! String)
                        board.view = (documentData["view"] as! Int)
                        board.photo = (documentData["photoUrl"] as! String)
                        let timestamp: Timestamp = documentData["date"] as! Timestamp
                        board.date = timestamp.dateValue()
                        board.userID = (documentData["userID"] as! String)
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
                            board.comments.append(c)
                        }
                        self.mycommentboardArray.append(board)
                    }
                }
            }
        }
            self.mycommentBoard.reloadData()
            self.mycommentBoard.layoutSubviews()
          }
    }


}


extension mycommentVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mycommentboardArray.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = mycommentBoard.dequeueReusableCell(withIdentifier: "mycommentcell", for: indexPath) as! mycommnetCell
            if indexPath.row < mycommentboardArray.count {
                let Board = mycommentboardArray[indexPath.row]
                cell.boardtitle.text = "[\(Board.category ?? "")] \(Board.title ?? "")"
              
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let time = dateFormatter.string(from:Board.date ?? Date())
                cell.commenttime.text = time
                
                for (_,comment) in Board.comments.enumerated()
                {
                    if Auth.auth().currentUser?.email == comment.userID as? String
                    {
                        cell.mycomment.text = comment.contents
                    }
                }
            }
            return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80 //Item Cell height
        } else {
            return 55 //Loading Cell height
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "boardDetail") {
            if let destination: boardDetailVC = segue.destination as? boardDetailVC {
                if let selectedRow = mycommentBoard.indexPathForSelectedRow?.row {
                    destination.boardD = mycommentboardArray[selectedRow]
                }
            }
        }
    }
}

