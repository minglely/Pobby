//
//  ViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/10/16.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let user = Auth.auth().currentUser {
        } else {
            performSegue(withIdentifier: "Login", sender: self)

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

    


    




