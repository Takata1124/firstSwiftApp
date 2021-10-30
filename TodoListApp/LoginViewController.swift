//
//  LoginViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var donthaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        donthaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }
    
    @objc private func tappedDontHaveAccountButton() {
        
    }
    
    @objc private func tappedLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        HUD.show(.progress)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                HUD.hide()
                print("ログインに失敗しました")
                return
            }
            
            HUD.hide()
            print("ログインに成功しました")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let taskViewController = storyboard.instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
            taskViewController.modalPresentationStyle = .fullScreen
            self.present(taskViewController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
