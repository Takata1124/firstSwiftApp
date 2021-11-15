//
//  TempoViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/15.
//

import UIKit
import Firebase
import FirebaseAuth

class TempoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func ConfirmUserSign() {
        
        if Auth.auth().currentUser?.uid != nil {
//            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//            signUpViewController.modalPresentationStyle = .fullScreen
//            self.present(signUpViewController, animated: true, completion: nil)
            print("ログインに成功しました")
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func SignInAction(_ sender: Any) {
        
        ConfirmUserSign()
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
