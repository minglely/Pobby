//
//  HomeViewController.swift

//  Created by 김민주 on 2020/11/03.
import UIKit

import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var banner: UICollectionView!
    @IBOutlet weak var ticketing: UICollectionView!
    @IBOutlet weak var broadcast: UICollectionView!
    @IBOutlet weak var bestborad: UICollectionView!
    @IBOutlet weak var bestpetition: UICollectionView!
    
    var nowPage: Int = 0
    
    var bannersArray: [UIImage] = [
        UIImage(named: "img1.png")!,
        UIImage(named: "img2.png")!,
        UIImage(named: "img3.png")!
    ]
    var ticketingArray = [ticket_schedule]()
    var broadcastArray = [broadcast_schedule]()
    var bestboardArray = [Board]()
    var bestpetitionArray = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings

        getbannerImage()
        getTicket_schedule()
        getBroadcast_schedule()
        getbestPetition()
        getbestBoard()
        
        banner.delegate = self
        banner.dataSource = self
        bannerTimer()

        ticketing.delegate = self
        ticketing.dataSource = self
        
        broadcast.delegate = self
        broadcast.dataSource = self
        
        bestpetition.delegate = self
        bestpetition.dataSource = self
        
        bestborad.delegate = self
        bestborad.dataSource = self
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.ticketing.reloadData()
        self.ticketing.collectionViewLayout.invalidateLayout()
        self.ticketing.layoutSubviews()
        
        self.broadcast.reloadData()
        self.broadcast.collectionViewLayout.invalidateLayout()
        self.broadcast.layoutSubviews()
        
        self.bestpetition.reloadData()
        self.bestpetition.collectionViewLayout.invalidateLayout()
        self.bestpetition.layoutSubviews()
        
        self.bestborad.reloadData()
        self.bestborad.collectionViewLayout.invalidateLayout()
        self.bestborad.layoutSubviews()
    }
    
    //베너 이미지 받아오기
    func getbannerImage() {
        let storage = Storage.storage()
        var reference: StorageReference!
        for n in 1...3 {
            reference = storage.reference(forURL: "gs://pobby-14be9.appspot.com/banner/banner\(n).jpg")
            reference.downloadURL { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                self.bannersArray[n-1] = image!
            }
        }
    }
    //베너 시간
    func bannerTimer() {
            let _: Timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
                self.bannerMove()
        }
    }
    //베너 자동 이동
    func bannerMove() {
        // 현재페이지가 마지막 페이지일 경우
        if nowPage == bannersArray.count-1 {
        // 맨 처음 페이지로 돌아감
            banner.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            return
        }
        // 다음 페이지로 전환
        nowPage += 1
        banner.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    
    let today = Date()
    
    func getTicket_schedule() -> Void {
        let db = Firestore.firestore()
        db.collection("Ticketing_schedule")
            .whereField("time", isGreaterThan: today)
            .order(by: "time", descending: false).limit(to: 5)
            .getDocuments() { ( querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                    var Ticket = ticket_schedule()
                    Ticket.title = documentData["title"] as? String
                    Ticket.detail = documentData["detail"] as? String
                    Ticket.ticketUrl = documentData["ticketUrl"] as? String
                    
                    let timestamp: Timestamp = documentData["time"] as! Timestamp
                    Ticket.time =  timestamp.dateValue()
                    
                    let storage = Storage.storage()
                    var reference: StorageReference!
                    let photourl = documentData["photoUrl"] as? String
                    reference = storage.reference(forURL: photourl!)
                    reference.downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                    Ticket.photo = image!
                        self.ticketingArray.append(Ticket)
                    }
                }
              }
            }
    }
    
    func getBroadcast_schedule() -> Void {
        let db = Firestore.firestore()
        db.collection("Broadcast_schedule")
            .whereField("time", isGreaterThan: today)
            .order(by: "time", descending: false).limit(to: 5)
            .getDocuments() { ( querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                    var broadcast = broadcast_schedule()
                    broadcast.title = documentData["title"] as? String
                    broadcast.detail = documentData["detail"] as? String
                    
                    let timestamp: Timestamp = documentData["time"] as! Timestamp
                    broadcast.time =  timestamp.dateValue()
                    

                    let storage = Storage.storage()
                    var reference: StorageReference!
                    let photourl = documentData["photoUrl"] as? String
                    reference = storage.reference(forURL: photourl!)
                    reference.downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                    
                        broadcast.photo = image!
                        self.broadcastArray.append(broadcast)
                    }
                }
              }
            }

    }
    
    func getbestPetition() -> Void {
        self.bestpetitionArray.removeAll()
        let db = Firestore.firestore()
        db.collection("Petition").order(by: "signed", descending: true)
            .getDocuments() { ( querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        let documentData = document.data()
                        var petition = Petition()
                        petition.category = documentData["category"] as? String
                        petition.title = documentData["title"] as? String
                        petition.petition = documentData["petition"] as? String
                        petition.contents = documentData["contents"] as? String
                        petition.signed = documentData["signed"] as? Int
                            
                        let timestamp: Timestamp = documentData["time"] as! Timestamp
                        petition.time = timestamp.dateValue()
                    
                        petition.userID = documentData["userID"] as? String
                        self.bestpetitionArray.append(petition)
                }
            }
            // reload the collection view
            self.bestpetition.reloadData()
            self.bestpetition.collectionViewLayout.invalidateLayout()
            self.bestpetition.layoutSubviews()
          }
        
    }

    func getbestBoard() -> Void {
        self.bestboardArray.removeAll()
        let db = Firestore.firestore()
        db.collection("Board").order(by: "commentN", descending: true)
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
                        self.bestboardArray.append(board)
                }
            }
            self.bestborad.reloadData()
            self.bestborad.collectionViewLayout.invalidateLayout()
            self.bestborad.layoutSubviews()
          }
        
    }
    
    

   //콜렉션 뷰 레이아웃
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ticketing.dequeueReusableCell(withReuseIdentifier: "ticketingCell", for: indexPath as IndexPath) as! ticketingCollectionVcell
        if indexPath.row < ticketingArray.count {
            let ticketing = ticketingArray[indexPath.row]

            cell.ticketingImageView.image = ticketing.photo!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd"
            let day = dateFormatter.string(from:ticketing.time!)
            dateFormatter.dateFormat = "HH:mm"
            let time =  dateFormatter.string(from:ticketing.time!)

            cell.ticketingInfo.text = "\(day) | \(time)"
        }
        if (collectionView == broadcast ) {
            let cell = broadcast.dequeueReusableCell(withReuseIdentifier: "broadcastCell", for: indexPath as IndexPath) as! broadcastingCollectionVcell
            if indexPath.row < broadcastArray.count {
                let broadcast = broadcastArray[indexPath.row]

                cell.broadcastImage.image = broadcast.photo!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM.dd"
                let day = dateFormatter.string(from:broadcast.time!)
                dateFormatter.dateFormat = "HH:mm"
                let time =  dateFormatter.string(from:broadcast.time!)

                cell.broadcastInfo.text = "\(day) | \(time)"
                return cell
            }
        }
        if (collectionView == banner) {
            let cell = banner.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath as IndexPath) as! bannerCollectionViewCell
            cell.bannerImageView.image = bannersArray [indexPath.row]
            return cell
        }
        if (collectionView == bestpetition) {
            let cell = bestpetition.dequeueReusableCell(withReuseIdentifier: "BpetitionCell", for: indexPath as IndexPath) as! bestpetitionCell
            cell.rankLabel.text = "\(indexPath.row+1)"
            if indexPath.row < bestpetitionArray.count {
                let Bpetition = bestpetitionArray[indexPath.row]
                cell.title.text = Bpetition.title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY.MM.dd"
                let day = dateFormatter.string(from:Bpetition.time!)
                cell.date.text = day
                
                cell.signed.text = "청원 \(Bpetition.signed ?? 0)명"
                
                let current = Date()
                let DL = Bpetition.time! + (86400 * 30)
                let timeInterval = DL.timeIntervalSince(current)
                            
                cell.deadline.text = "마감까지 D - \(Int(timeInterval/86400)) "
                
            }
            return cell
        }
        if (collectionView == bestborad) {
            let cell = bestborad.dequeueReusableCell(withReuseIdentifier: "Bboardcell", for: indexPath as IndexPath) as! bestboardCell
            cell.rankLabel.text = "\(indexPath.row+1)"
            if indexPath.row < bestboardArray.count {
                let Bboard = bestboardArray[indexPath.row]
                cell.title.text = Bboard.title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let time = dateFormatter.string(from:Bboard.date!)
                cell.time.text = time
                
                cell.comment.text = "\(Bboard.comments.count)"
 
                
            }

            return cell
        }
        return cell
        
    }
    
    //콜렉션뷰 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.banner {
            return bannersArray.count
        }
        if collectionView == self.ticketing  {
            return ticketingArray.count
        }
        return 5
    }

    //콜렉션뷰 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == banner{
            return CGSize(width: banner.frame.size.width  , height:  banner.frame.height)
        }
        else if collectionView == self.ticketing || collectionView == self.broadcast{
            return CGSize(width: 128, height: 180)
        }
        else if collectionView == self.bestborad || collectionView == self.bestpetition  {
            return CGSize(width: 330, height: 50)
        }
        return CGSize(width: 330, height: 50)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ticketingDetailVC" {
        let ticketingDetailVC = segue.destination as! ticketingDetailVC
           let cell = sender as! ticketingCollectionVcell
           let indexPath = ticketing.indexPath(for: cell)
           let ticket_schedule = ticketingArray[(indexPath?.row)!]
        ticketingDetailVC.ticket = ticket_schedule
       }
        if segue.identifier == "broadcastDetailVC" {
         let broadcastDetailVC = segue.destination as! broadcastDetailVC
            let cell = sender as! broadcastingCollectionVcell
            let indexPath = broadcast.indexPath(for: cell)
            let broadcast_schedule = broadcastArray[(indexPath?.row)!]
            broadcastDetailVC.broadcast = broadcast_schedule
        }
        if segue.identifier == "bestBoardDetail" {
         let vc = segue.destination as! boardDetailVC
            let cell = sender as! bestboardCell
            let indexPath = bestborad.indexPath(for: cell)
            let Bestboard = bestboardArray[(indexPath?.row)!]
            vc.boardD = Bestboard
        }
        if segue.identifier == "bestpetitionDetail" {
         let vc = segue.destination as! PetitionDetailVC
            let cell = sender as! bestpetitionCell
            let indexPath = bestpetition.indexPath(for: cell)
            let Bpetition = bestpetitionArray [(indexPath?.row)!]
            vc.Petition = Bpetition
        }
   }
        
        //컬렉션뷰 감속 끝났을 때 현재 페이지 체크
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }

}


