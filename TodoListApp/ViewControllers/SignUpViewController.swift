//
//  SignUpViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/25.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import PKHUD

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyButton: UIButton!
    
    
    var eyeconClick: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews() {
        
        //        profileImageButton.layer.cornerRadius = 75
        //        profileImageButton.layer.borderWidth = 1
        //        profileImageButton.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        //
        ////        profileImageButton.isHidden = true
        //
        //        profileImageButton.addTarget(self, action: #selector(tappedProfileImageButton), for: .touchUpInside)
        ////        registerButton.addTarget(self, action: #selector(tappedRegisterButoon), for: .touchUpInside)
        ///
        auth = Auth.auth()
        //
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        registerButton.isEnabled  = false
        registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        
        //        emailTextField.becomeFirstResponder()
        passwordTextField.isSecureTextEntry = true
        
        alreadyButton.isEnabled = true
    }
    
    var auth: Auth!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if auth.currentUser != nil {
            auth.currentUser?.reload(completion: { error in
                if error == nil {
                    
                    if self.auth.currentUser?.isEmailVerified == true {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                        
                        self.alreadyButton.isEnabled = true
                        
                        print("移動")
                        //                        self.performSegue(withIdentifier: "Timeline", sender: self.auth().currentUser!)
                        
                    } else if self.auth.currentUser?.isEmailVerified == false {
                        
                        let alert = UIAlertController(title: "まだメール認証が完了していません。", message: "確認用メールを送信しているので確認をお願いします。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        self.alreadyButton.isEnabled = false
                    }
                }
            })
        }
    }
    
    private func showErrorIfNeeded(_ errorOrNil: Error?) {
        // エラーがなければ何もしません
        guard let error = errorOrNil else { return }
        
        let message = "エラーが起きました" // ここは後述しますが、とりあえず固定文字列
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    @IBAction func tappedalready(_ sender: Any) {
        
        print("tapped")
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginviewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginviewController.modalPresentationStyle = .fullScreen
        self.present(loginviewController, animated: true, completion: nil)
        
    }
    
    @objc private func tappedProfileImageButton() {
        print("tapped")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func registerAccount() {
        
        let name = usernameTextField.text ?? ""
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if err == nil, let res = res {
                res.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        let alert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
            
            if let err = err {
                print("認証情報の保存に失敗しました\(err)")
                return
            }
            
            print("認証情報の保存に成功しました")
            
            guard let uid = res?.user.uid else { return }
            guard let username = self.usernameTextField.text else { return }
            let docData = [
                "email": email,
                "username": username,
                "createdAt": Timestamp(),
                "profileImageUrl": ""
            ] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("データベースへの保存に失敗しました(\(err)")
                    return
                }
                
                print("FireStoreへの情報の保存が成功しました")
                
                //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                    let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                //                    self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        
        print("tapped")
        
        if auth.currentUser != nil {
            auth.currentUser?.reload(completion: { error in
                if error == nil {
                    
                    if self.auth.currentUser?.isEmailVerified == true {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true, completion: nil)
                        
                        self.alreadyButton.isEnabled = true
                        
                        print("移動")
                        //                        self.performSegue(withIdentifier: "Timeline", sender: self.auth().currentUser!)
                        
                    } else if self.auth.currentUser?.isEmailVerified == false {
                        
                        let alert = UIAlertController(title: "まだメール認証が完了していません。", message: "確認用メールを送信しているので確認をお願いします。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        self.alreadyButton.isEnabled = false
                    }
                }
            })
        }
    }
    
    
    
    //    @IBAction private func didTapSignUpButton() {
    //
    //        let email = emailTextField.text ?? ""
    //        let password = passwordTextField.text ?? ""
    //        let name = usernameTextField.text ?? ""
    //
    //        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
    //            guard let self = self else { return }
    //            if let user = result?.user {
    //                let req = user.createProfileChangeRequest()
    //                req.displayName = name
    //                req.commitChanges() { [weak self] error in
    //                    guard let self = self else { return }
    //                    if error == nil {
    //                        user.sendEmailVerification() { [weak self] error in
    //                            guard let self = self else { return }
    //                            if error == nil {
    //                                // 仮登録完了画面へ遷移する処理
    //                                let storyboard = UIStoryboard(name: "Tempo", bundle: nil)
    //                                let tempoviewController = storyboard.instantiateViewController(withIdentifier: "TempoViewController") as! TempoViewController
    //                                self.present(tempoviewController, animated: true, completion: nil)
    //                            }
    //                            self.showErrorIfNeeded(error)
    //                        }
    //                    }
    //                    self.showErrorIfNeeded(error)
    //                }
    //            }
    //            self.showErrorIfNeeded(error)
    //        }
    //    }
    
    @objc private func tappedRegisterButoon() {
        
        let image = profileImageButton.imageView?.image ?? UIImage(named: "5085302_s")
        guard let uploadImage = image?.jpegData(compressionQuality: 0.3) else { return }
        
        HUD.show(.progress)
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uploadImage, metadata: nil) {(metadata, err) in
            if let err = err {
                print("Firestorageへの情報の保存に失敗しました\(err)")
                HUD.hide()
                return
            }
            
            print("Firestorageへの情報の保存に成功しました")
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    print("FireStorageからのダウンロードに失敗しました\(err)")
                    HUD.hide()
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                print("urlString", urlString)
                self.createUserToFirebase(profileImage: urlString)
            }
        }
    }
    
    private func createUserToFirebase(profileImage: String) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました\(err)")
                return
            }
            
            print("認証情報の保存に成功しました")
            
            guard let uid = res?.user.uid else { return }
            guard let username = self.usernameTextField.text else { return }
            let docData = [
                "email": email,
                "username": username,
                "createdAt": Timestamp(),
                "profileImageUrl": profileImage
            ] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("データベースへの保存に失敗しました(\(err)")
                    return
                }
                
                print("FireStoreへの情報の保存が成功しました")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //        print("text", textField.text)
        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? false
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
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

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.setTitle("", for: .normal)
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}
