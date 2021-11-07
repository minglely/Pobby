//
//  PetitionVC.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/13.
//

import UIKit

import FirebaseCore
import FirebaseFirestore

class PetitionVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
        
    var PetitionArray = [Petition]()

    @IBOutlet weak var filter_DVD: UIButton!
    @IBOutlet weak var filter_OST: UIButton!
    @IBOutlet weak var filter_GOODS: UIButton!
    @IBOutlet weak var petitionCV: UICollectionView!    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
                
        filter_DVD.layer.cornerRadius = 10
        filter_DVD.layer.borderWidth = 1
        filter_DVD.layer.borderColor = UIColor.black.cgColor
        
        filter_OST.layer.cornerRadius = 10
        filter_OST.layer.borderWidth = 1
        filter_OST.layer.borderColor = UIColor.black.cgColor
        
        filter_GOODS.layer.cornerRadius = 10
        filter_GOODS.layer.borderWidth = 1
        filter_GOODS.layer.borderColor = UIColor.black.cgColor
        
        
        petitionCV.delegate = self
        petitionCV.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        getPetitionData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 콜렉션뷰 갯수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PetitionArray.count
    }
    //콜렉션뷰 레이아웃
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Access
        let cell = petitionCV.dequeueReusableCell(withReuseIdentifier: "PetitionCell", for: indexPath) as! PetitionCell
        let petition = PetitionArray[indexPath.row]
        
        cell.backcell.layer.borderWidth = 0.5
        cell.backcell.layer.backgroundColor = UIColor.white.cgColor
        cell.backcell.layer.borderColor = CGColor.init(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        cell.backcell.layer.cornerRadius = 25


        cell.signedProgress.clipsToBounds = true
        cell.signedProgress.layer.cornerRadius = 12
        let signed = petition.signed!
        let fsigned = Float(signed)
        cell.signedProgress.setProgress(Float(fsigned/500), animated: false)
        
        
        let current = Date()
        let DL = petition.time! + (86400 * 30)
        
        let timeInterval = DL.timeIntervalSince(current)
                    
        cell.deadline.text = "마감까지 D - \(Int(timeInterval/86400)) "
        cell.signedcount.text = "\(String(describing:signed)) 명"
        cell.category.text = "[\(petition.category!)]"
        cell.title.text = petition.title
        
        let docRef = Firestore.firestore().collection("User").document(petition.userID ?? "")
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                cell.username.text = document.get("nickname") as? String ?? ""
            } else {
            print("유저 정보가 없습니다.")
        }
    }
        //cell.username.text = petition.userID
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: petition.time!)
        cell.date.text = dateString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: petitionCV.bounds.size.width - 40, height: 145)
    }
    
    //콜렉션 터치 시
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "PetitionDetailVC" {
        let PetitionDetailVC = segue.destination as! PetitionDetailVC
           let cell = sender as! PetitionCell
           let indexPath = petitionCV.indexPath(for: cell)
           let Petition = PetitionArray[(indexPath?.row)!]
        PetitionDetailVC.Petition = Petition
       }
   }
    //콜렉션
    
    //데이타 받아오기
    func getPetitionData() -> Void {
        self.PetitionArray.removeAll()
        let db = Firestore.firestore()
        db.collection("Petition").order(by: "time", descending: true)
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
                        self.PetitionArray.append(petition)
                }
            }
            // 콜렉션 뷰 새로고침
            self.petitionCV.reloadData()
            self.petitionCV.collectionViewLayout.invalidateLayout()
            self.petitionCV.layoutSubviews()
          }
        }
    
    @IBAction func filteringDVD(_ sender: Any) {
        
        if let button = sender as? UIButton {
            if button.isSelected {
                getPetitionData()
                button.isSelected = false
            } else {
                self.PetitionArray.removeAll()
                let db = Firestore.firestore()
                db.collection("Petition").whereField("category", isEqualTo: "DVD").getDocuments() { ( querySnapshot, error) in
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
                        
                        self.PetitionArray.append(petition)
                        }
                    }
                    self.petitionCV.reloadData()
                    self.petitionCV.collectionViewLayout.invalidateLayout()
                    self.petitionCV.layoutSubviews()
                  }
                button.isSelected = true
            }
        }
    }
    
    @IBAction func filteringOST(_ sender: Any) {
        
        if let button = sender as? UIButton {
            if button.isSelected {
                getPetitionData()
                button.isSelected = false
            } else {
                self.PetitionArray.removeAll()
                let db = Firestore.firestore()
                db.collection("Petition").whereField("category", isEqualTo: "OST").getDocuments() { ( querySnapshot, error) in
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
                        
                        self.PetitionArray.append(petition)
                        }
                    }
                    self.petitionCV.reloadData()
                    self.petitionCV.collectionViewLayout.invalidateLayout()
                    self.petitionCV.layoutSubviews()
                  }
                button.isSelected = true
            }
        }
    }
    
    @IBAction func filteringGOODS(_ sender: Any) {
        
        if let button = sender as? UIButton {
            if button.isSelected {
                getPetitionData()
                button.isSelected = false
            } else {
                self.PetitionArray.removeAll()
                let db = Firestore.firestore()
                db.collection("Petition").whereField("category", isEqualTo: "기타 MD").getDocuments() { ( querySnapshot, error) in
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
                        
                        self.PetitionArray.append(petition)
                        }
                    }
                    self.petitionCV.reloadData()
                    self.petitionCV.collectionViewLayout.invalidateLayout()
                    self.petitionCV.layoutSubviews()
                  }
                button.isSelected = true
            }
        }
    }
}

