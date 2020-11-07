//
//  SignupViewController.swift
//  Pobby
//
//  Created by 김민주 on 2020/10/30.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController:  UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var backArrow: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if password.text != passwordConfirm.text {
        let alertController = UIAlertController(title: "패스워드가 다릅니다", message: "다시 시도해주세요", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
                }
        else{
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
         if error == nil {
            self.performSegue(withIdentifier: "setprofile", sender: self)
         }
         else{
           let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
           let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
               }
                    }
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
