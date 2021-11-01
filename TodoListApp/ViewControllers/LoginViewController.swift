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
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    var eyeconClick: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    @IBAction func eyeconAction(_ sender: Any) {
        if (eyeconClick == true) {
            passwordTextField.isSecureTextEntry = false
            eyeconClick = false
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeconClick = true
        }
    }
    
    @objc private func tappedDontHaveAccountButton() {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpView() {
        
        donthaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
        //        emailTextField.becomeFirstResponder()
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        registerButton.isEnabled  = false
        registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        
        //        loginLabel.tintColor = UIColor.red
        loginLabel.isHidden = true
    }
    
    @objc private func tappedLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        HUD.show(.progress)
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                HUD.hide()
                print("ログインに失敗しました")
                self.loginLabel.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.loginLabel.isHidden = true
                }
                return
            }
            
            HUD.hide()
            print("ログインに成功しました")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let taskViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            taskViewController.modalPresentationStyle = .fullScreen
            self.present(taskViewController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //        print("text", textField.text)
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        //        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? false
        
        if emailIsEmpty || passwordIsEmpty {
            registerButton.isEnabled  = false
            registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
