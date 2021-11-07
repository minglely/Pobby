
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignupViewController:  UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var passwordConfirm1: UITextField!
    @IBOutlet weak var backArrow: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray
        nextButton.layer.cornerRadius = 20
        
        //이멜 비번 비번확인 다 입력할 시 다음버튼 활성화
        [email, password1, passwordConfirm1].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })

    }
    //이멜 비번 비번확인 다 입력할 시 다음버튼 활성화

    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = email.text, !email.isEmpty,
            let pw = password1.text, !pw.isEmpty,
            let pwc = passwordConfirm1.text, !pwc.isEmpty
        else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(red: 152/255, green: 88/255, blue: 245/255, alpha: 1)
    }
    
    //회원가입 function
    @IBAction func signUpAction(_ sender: Any) {
        //비밀번호& 비밀번호 확인이 다른 경우
        if password1.text != passwordConfirm1.text {
        let alertController = UIAlertController(title: "비밀번호가 다릅니다", message: "다시 시도해주세요", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }
        else{
            //Firebase Auth 생성
            Auth.auth().createUser(withEmail: email.text!, password: password1.text!){ (user, error) in
         if error == nil {
            //forestore에 유저데이터 입력
            let db = Firestore.firestore()
            db.collection("User").document(self.email.text!).setData([
                "email": self.email.text!,
                "nickname": "포비맨",
                "photoUrl": "",
                "making_date":Timestamp(date: Date()),
            ])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            //프로필정보 입력 창으로 이동
            self.performSegue(withIdentifier: "setprofile", sender: self)
         }
         else{
           let alertController = UIAlertController(title: "회원가입 실패", message: error?.localizedDescription, preferredStyle: .alert)
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
