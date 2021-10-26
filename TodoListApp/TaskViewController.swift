//
//  TaskViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/17.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class TaskViewController: UIViewController, UITextViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var navbar_task: UINavigationBar!
    
    @IBAction func inputTextButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func nextView(_ sender: Any) {
        
        performSegue(withIdentifier: "goNextNext", sender: nil)
    }
    
    var textVC: String?
    var TODO: [String?] = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"]
    private var users = [User]()
    private var reverseArray = [User]()
    let viewclass = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageText.layer.borderColor = UIColor.black.cgColor
        messageText.layer.borderWidth = 1.0
        messageText.layer.cornerRadius = 20
        messageText.delegate = self
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        messageTable.separatorColor = .black
        
        navbar_task?.delegate = viewclass
        navbar_task?.barTintColor = .rgb(red: 200, green: 200, blue: 200)
//        navbar_task?.isTranslucent = true
        navbar_task?.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
        
        guard let untext = textVC else { return }
        print(untext)
        navbar_task?.items![0].title? = untext
        
//        title = "\(untext)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser?.uid == nil {
            viewdidloadSign()
        }
        fetchUserInfoFromFirestore()
        print(users)
    }
    
    func viewdidloadSign() {
        
        print("呼ばれた")
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    private func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("user情報の取得に失敗しました\(err)")
                return
            }
            
            print("user情報の取得に成功しました")
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                
                self.users.append(user)
                self.messageTable.reloadData()
                
                self.users.forEach({ (user) in
                    print(user.username)
                })
            })
            print(type(of: self.users))
            print(self.users.count)
        }
    }
    
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//        return .topAttached
//    }
//
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            TODO.append(textView.text)
            messageTable?.reloadData()
            textView.resignFirstResponder()
            textView.text = ""
            return false
        }
        return true
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = UIScreen.main.bounds.height - keyboardFrame.cgRectValue.minY - 100
        messageText.transform = CGAffineTransform(translationX: 0, y: min(0, -keyboardHeight))
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = UIScreen.main.bounds.height - keyboardFrame.cgRectValue.minY
        messageText.transform = CGAffineTransform(translationX: 0, y: min(0, +keyboardHeight))
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        print(users)
        print(users[0].username)
        
        var usercount: Int = users.count
        
        for i in 0..<usercount {
            usercount = usercount - i - 1
            print(usercount)
            reverseArray.append(users[usercount])
            usercount = users.count
        }
        
//        reverseArray.append(users[1])
        print(reverseArray[0].username)
//        cell.user = users[indexPath.row]
        cell.user = reverseArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
//        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
//        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "chatRoomViewController")
//        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
}
