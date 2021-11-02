//
//  ChatRoomStoryViewController.swift
//  messagesApp
//
//  Created by t032fj on 2021/10/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ChatRoomStoryViewController: UIViewController, UINavigationBarDelegate {
    
    var user: User?
    var category: Category?
    var chatroom: ChatRoom?
    
    private var messages = [Message]()
    
    private lazy var chatInputAccessoryViwe: ChatInputAccessoryView = {
        
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var chatRoomTable: UITableView!
    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var changebutton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        fetchMessages()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidLoad()
//
//        chatInputAccessoryViwe.isHidden = false
//    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryViwe
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func setUpViews() {
        
        chatRoomTable.delegate = self
        chatRoomTable.dataSource = self
        chatRoomTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        chatRoomTable.backgroundColor = .white
        
        navbar_t.items![0].title = ""
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar_t.items![0].title = category?.categorytitle
        
        changebutton.setTitle("Edit", for: .normal)
    }
    
    private func fetchMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗しました")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    
                    let dic = documentChange.document.data()
                    let message = Message(dic: dic)
                    message.messageId = documentChange.document.documentID
                    self.messages.append(message)
                    self.chatRoomTable.reloadData()
                    
                case .modified:
                    
                    print("nothing")
                case .removed:
                    
                    print("nothing")
                }
            })
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func changemode(_ sender: Any) {
        
        if (chatRoomTable.isEditing == true) {
            chatRoomTable.isEditing = false
            changebutton.setTitle("Edit", for: .normal)
            
        } else {
            chatRoomTable.isEditing = true
            changebutton.setTitle("Editing", for: .normal)
        }
    }
}

extension ChatRoomStoryViewController: ChatInputAccessoryViewDelegate {
    
    func tappedBackButton() {
        
        chatInputAccessoryViwe.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func tappedSendButton(text: String) {
        
        guard let categoDocId = category?.categoryId else { return  }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        chatInputAccessoryViwe.removetext()
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": text
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document().setData(docData) { (err) in
            if let err = err {
                print("メッセージの保存に失敗しました")
                return
            }
            print("メッセージの保存に成功しました")
        }
    }
}

extension ChatRoomStoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTable.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "DoList", bundle: nil)
        let dolistViewController = storyboard.instantiateViewController(withIdentifier: "DoListViewController") as! DoListViewController
        dolistViewController.user = user
        dolistViewController.category = category
        dolistViewController.message = messages[indexPath.row]
        dolistViewController.modalPresentationStyle = .fullScreen
        self.present(dolistViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//
            guard let messId = messages[indexPath.row].messageId else { return }
            print(messId)
            
            guard let categoDocId = category?.categoryId else { return  }
            guard let uid = Auth.auth().currentUser?.uid else  { return }
            
            Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messId).delete()
            
            messages.remove(at: indexPath.row)
            chatRoomTable.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if chatRoomTable.isEditing {
            return .delete
        }
        return .none
    }

    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let list = messages[fromIndexPath.row]
        messages.remove(at: fromIndexPath.row)
        messages.insert(list, at: to.row)
        
        print(fromIndexPath)
        print(to.row)
        
        print(messages[fromIndexPath[1]].message)
        print(messages[to.row].message)
        
        guard let categoDocId = category?.categoryId else { return  }
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").getDocuments { (documents, err)  in
            
            documents?.documents.forEach { document in
                let dataDescription = document.data().map(String.init(describing:))
                print(dataDescription)

            }
            
        }
    }

    //並び替えを可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
