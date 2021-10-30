//
//  ChatRoomStoryViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ChatRoomStoryViewController: UIViewController {
    
    var user: User?
    var chatroom: ChatRoom?
    
    private var customCell = "customCell"
    private var messages = [Message]()
    
    private lazy var chatInputAccessoryViwe: ChatInputAccessoryView = {
        
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var chatRoomTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomTable.delegate = self
        chatRoomTable.dataSource = self
        chatRoomTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: customCell)
        chatRoomTable.backgroundColor = .white
        
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryViwe
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchMessages() {
        
        guard let chatroomDocId = chatroom?.documentId else { return  }
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗しました")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let message = Message(dic: dic)
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
}

extension ChatRoomStoryViewController: ChatInputAccessoryViewDelegate {
    
    func tappedBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tappedSendButton(text: String) {

        guard let chatroomDocId = chatroom?.documentId else { return  }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        chatInputAccessoryViwe.removetext()
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": text
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").document()
            .setData(docData) { (err) in
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

}
