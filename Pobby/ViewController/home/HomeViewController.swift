//
//  HomeViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/03.
//

import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var testbutton: UIButton!
    
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


    

    @IBAction func testbuttonpusth(_ sender: Any) {
    }

    
}

