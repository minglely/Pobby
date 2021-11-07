//
//  SetAdressViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/11/03.
//

import UIKit

class welcometopobbyVC: UIViewController {

    @IBOutlet weak var startbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startbutton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
