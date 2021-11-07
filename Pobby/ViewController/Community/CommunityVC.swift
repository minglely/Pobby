//
//  CommunityVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/12/05.
//

import UIKit

import FirebaseCore
import FirebaseFirestore


class CommunityVC: UIViewController {

    @IBOutlet weak var write_Button: UIButton!
    @IBOutlet weak var ButtonView: UIView!
    @IBOutlet weak var boardTableView: UITableView!

    var boardArray = [Board]()

    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        ButtonView.layer.cornerRadius = 30

        //Register Loading Cell
        let loadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.boardTableView.register(loadingCellNib, forCellReuseIdentifier: "loadingcellid")
        
        boardTableView.delegate = self
        boardTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        getboardData()

    }
    
    func getboardData() {
        self.boardArray.removeAll()
        let db = Firestore.firestore()
        db.collection("Board").order(by: "date", descending: true)
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
                self.boardArray.append(board)
                }
            }
            self.boardTableView.reloadData()
            self.boardTableView.layoutSubviews()
          }
    }
    
}

extension CommunityVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return boardArray.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = boardTableView.dequeueReusableCell(withIdentifier: "tableviewitemcellid", for: indexPath) as! TableViewItemCell
            if indexPath.row < boardArray.count {
                let Board = boardArray[indexPath.row]
                cell.itemLabel.text = "[\(Board.category!)] \(Board.title!)"
                cell.commentLabel.text = "\(Board.comments.count)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let time = dateFormatter.string(from:Board.date!)
                cell.timeLabel.text = time
                cell.viewLabel.text = "\(Board.view!)"
                
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingcellid", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 65 //Item Cell height
        } else {
            return 55 //Loading Cell height
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "boardDetail", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "boardDetail") {
            if let destination: boardDetailVC = segue.destination as? boardDetailVC {
                if let selectedRow = boardTableView.indexPathForSelectedRow?.row {
                    destination.boardD = boardArray[selectedRow]
                }
            }
        }
    }
}

