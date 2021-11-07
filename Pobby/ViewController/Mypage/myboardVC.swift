//
//  myboardVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class myboardVC: UIViewController {
    
    
    @IBOutlet weak var myboardTableView: UITableView!

    var myboardArray = [Board]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myboardTableView.delegate = self
        myboardTableView.dataSource = self
        
}
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        getmyboardData()
    }
    
    func getmyboardData() {
        self.myboardArray.removeAll()
        
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
        
        db.collection("Board").whereField("userID", isEqualTo: user?.email! ?? "").order(by: "date", descending: true)
            .getDocuments() { ( querySnapshot, error) in
        if let error = error {
            print(error.localizedDescription)
        }else {
            for document in querySnapshot!.documents {
                let documentData = document.data()
                var board = Board(comments: [])
                board.category = (documentData["category"] as! String)
                board.title = (documentData["title"] as! String)
                board.contents = (documentData["contents"] as! String)
                board.view = (documentData["view"] as! Int)
                board.photo = (documentData["photoUrl"] as! String)
                let timestamp: Timestamp = documentData["date"] as! Timestamp
                board.date = timestamp.dateValue()
                board.userID = (documentData["userID"] as! String)
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
                    board.comments.append(c)
                }
                self.myboardArray.append(board)
                }
            }
            self.myboardTableView.reloadData()
            self.myboardTableView.layoutSubviews()
          }
    }
}

extension myboardVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myboardArray.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = myboardTableView.dequeueReusableCell(withIdentifier: "tableviewitemcellid", for: indexPath) as! TableViewItemCell
            if indexPath.row < myboardArray.count {
                let Board = myboardArray[indexPath.row]
                cell.itemLabel.text = "[\(Board.category!)] \(Board.title!)"
                cell.commentLabel.text = "\(Board.comments.count)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let time = dateFormatter.string(from:Board.date!)
                cell.timeLabel.text = time
                cell.viewLabel.text = "\(Board.view!)"
                
            }
            return cell
      
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65 //Item Cell height
        } else {
            return 55 //Loading Cell height
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "boardDetail") {
            if let destination: boardDetailVC = segue.destination as? boardDetailVC {
                if let selectedRow = myboardTableView.indexPathForSelectedRow?.row {
                    destination.boardD = myboardArray[selectedRow]
                }
            }
        }
    }
}
