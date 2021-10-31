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
    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBAction func inputTextButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func nextView(_ sender: Any) {
        
        performSegue(withIdentifier: "goNextNext", sender: nil)
    }
    
    var textVC: String?
    var TODO: [String?] = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"]
    private var user: User? {
        didSet {
            navTitle.title = user?.username
        }
    }
    
    private var chatrooms = [ChatRoom]()
    private var chatRoomListener: ListenerRegistration?
    
    let viewclass = ViewController()
    
    private func setupViews() {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        ConformUserSign()
        fetchChatroomsInFromFirestore()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        fetchLoginUserInfo()
        
    }
    
    private func fetchChatroomsInFromFirestore() {
        
        chatRoomListener?.remove()
        chatrooms.removeAll()
        messageTable.reloadData()
        
        chatRoomListener = Firestore.firestore().collection("chatRooms")
            .addSnapshotListener { (snapshots, err) in
                
                if let err = err {
                    print("ChatRoom情報の取得に失敗しました")
                    return
                }
                
                print("chatRoom情報の取得に成功しました")
                
                snapshots?.documentChanges.forEach ({ (documentChange) in
                    
                    switch documentChange.type {
                    case .added:
                        
                        self.handleAddedDocumentChange(documentChange: documentChange)
                        
                    case .modified:
                        print("nothing")
                    case .removed:
                        print("nothing")
                    }
                    
                })
            }
    }
    
    private func handleAddedDocumentChange(documentChange: DocumentChange) {
        
        let dic = documentChange.document.data()
        let chatroom = ChatRoom(dic: dic)
        chatroom.documentId = documentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatroom.members.forEach { (memberUid) in
            
            if memberUid != uid {
                Firestore.firestore().collection("users").document(memberUid).getDocument { (snapshot, err) in
                    
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました")
                        return
                    }
                    
                    print("ユーザー情報の取得に成功しました")
                    guard let dic = snapshot!.data() else { return }
                    let user = User(dic: dic)
                    user.uid = snapshot?.documentID
                    
                    chatroom.partnerUser = user
                    self.chatrooms.append(chatroom)
                    
                    self.messageTable.reloadData()
                    print(self.chatrooms.count)
                    print(self.chatrooms)
                }
            }
        }
    }
    
    private func fetchLoginUserInfo() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("user情報の取得に失敗しました")
                return
            }
            
            guard let snapshot = snapshot else { return }
            guard let dic = snapshot.data() else { return }
            
            print("text:", dic)
            let user = User(dic: dic)
            self.user = user
        }
        
    }
    
    @IBAction func tapButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
//        userListViewController.modalPresentationStyle = .fullScreen
        self.present(userListViewController, animated: true, completion: nil)
        
    }
    
    func ConformUserSign() {
        
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
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
        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
//        print(users)
//        print(users[0].username)
//
//        var usercount: Int = users.count
//
//        for i in 0..<usercount {
//            usercount = usercount - i - 1
//            print(usercount)
//            reverseArray.append(users[usercount])
//            usercount = users.count
//        }
//
////        reverseArray.append(users[1])
//        print(reverseArray[0].username)
////        cell.user = users[indexPath.row]
//        cell.user = reverseArray[indexPath.row]
        
        cell.chatroom = chatrooms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        
        let storyboard = UIStoryboard.init(name: "chatRoomStory", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as! ChatRoomStoryViewController
        chatRoomViewController.user = user
        chatRoomViewController.chatroom = chatrooms[indexPath.row]
        chatRoomViewController.modalPresentationStyle = .fullScreen
        self.present(chatRoomViewController, animated: true, completion: nil)
    }
}
