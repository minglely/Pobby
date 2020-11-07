//  Created by 김민주 on 2020/10/27.
//

import UIKit
import Firebase
import FirebaseAuth



class LoginViewController: UIViewController  {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 20
        }
    
    
    override  func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser(){
            //온보딩 보여주기
            let vc = storyboard?.instantiateViewController(identifier: "welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
                   if user != nil{
                       print("login success")
                    self.dismiss(animated: true, completion: nil)
                   }
                   else{
                    let loginfail = UIAlertController(title: "로그인 실패", message: "이메일과 비밀번호를 확인해주세요", preferredStyle: UIAlertController.Style.alert)
                    let re = UIAlertAction(title: "확인", style: .default) { (action) in
                    }
                    loginfail.addAction(re)
                    self.present(loginfail, animated: false, completion: nil)
                }
            
                   }
             }        
    
    
    @IBAction func FindPassword(_ sender: Any) {
        
        let alert = UIAlertController(title: "준비중", message: "준비 중 입니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)

    }
}
    
class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
        
    }
    
    func setIsNotNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
}


