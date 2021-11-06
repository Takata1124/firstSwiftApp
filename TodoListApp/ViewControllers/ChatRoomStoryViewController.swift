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
    
//    private func fetchBoolMessages() {
//
//        guard let uid = Auth.auth().currentUser?.uid else  { return }
//        guard let categoDocId = category?.categoryId else { return  }
//
//        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").addSnapshotListener { (snapshots, err) in
//            if let err = err {
//                print("メッセージの取得に失敗しました")
//                return
//            }
//
//            snapshots?.documentChanges.forEach({ (documentChange) in
//                switch documentChange.type {
//                case .added:
//
//                    let dic = documentChange.document.data()
//                    let message = Message(dic: dic)
//                    message.messageId = documentChange.document.documentID
//                    self.messages.append(message)
//                    self.chatRoomTable.reloadData()
//
//                case .modified:
//
//                    print("nothing")
//                case .removed:
//
//                    print("nothing")
//                }
//            })
//        }
//    }
    
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
            "message": text,
            "click": false
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
        
//        print("tapped")
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: "DoList", bundle: nil)
        let dolistViewController = storyboard.instantiateViewController(withIdentifier: "DoListViewController") as! DoListViewController
        dolistViewController.user = user
        dolistViewController.category = category
        dolistViewController.message = messages[indexPath.row]
        dolistViewController.modalPresentationStyle = .fullScreen
        self.present(dolistViewController, animated: true, completion: nil)
        
//        let cell = tableView.cellForRow(at: indexPath)
//        let selectedIndexPaths = tableView.indexPathsForSelectedRows
//        if selectedIndexPaths != nil && (selectedIndexPaths?.contains(indexPath))! {
//            if let paths = selectedIndexPaths {
//                for path in paths {
//                    if indexPath.section == path.section {
//                        let checkedCell = tableView.cellForRow(at: path)
//                        checkedCell?.accessoryType = .none
//                    }
//                }
//            }
//        }
//        cell?.accessoryType = .checkmark
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//       let cell = tableView.cellForRow(at: indexPath)
//       cell!.accessoryType = .none
//   }
    
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
        
        guard let categoDocId = category?.categoryId else { return  }
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        var datas = [String]()
        
        let databaseMessage = Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages")
        
        var Intcount: Int = messages.count - 1
        for i in 0...Intcount {
            print(i)
            guard let messId = messages[i].messageId else { return }
            print(messId)
            
//            databaseMessage.document(messId).delete()
            
            datas.append(messId)
//            chatRoomTable.reloadData()
        }
        
        print(datas)
                        
        let list = messages[fromIndexPath.row]
        messages.remove(at: fromIndexPath.row)
        messages.insert(list, at: to.row)
        
//        print(fromIndexPath)
        print("toindex", to.row)
        
        var toIndexPath: Int = to.row
//
//        print(messages[fromIndexPath[1]].message)
//        print(messages[to.row].message)
        
//        print(messages)
//        print(messages[0])
//        print(messages[0].message)
        
        var messcount: Int = messages.count - 1
        
        for i in 0...messcount {
            
            let docData = [
                "name": messages[i].name,
                "createdAt": messages[i].createdAt,
                "uid": messages[i].uid,
                "message": messages[i].message
            ] as [String : Any]
            
            databaseMessage.document().setData(docData) { (err) in
                if let err = err {
                    print("メッセージの保存に失敗しました")
                    return
                }
                print("メッセージの保存に成功しました")
            }
        }
        
        var IDcount: Int = datas.count - 1
//        var count = -1
        
//        repeat {
//            count += 1
//            let docId = datas[count]
//            databaseMessage.document(docId).delete()
//
//          // 繰り返し実行されるコード
//        } while count < IDcount
        
        for i in 0...IDcount {
            
//            if i < toIndexPath {
//                print(i)
//                let docId = datas[i]
//                print(docId)
//
//                databaseMessage.document(docId).delete()
//                messages.removeFirst()
//            } else if i == toIndexPath {
//
//                continue
//            } else {
//
//                print(i)
//                let docId = datas[i - 1]
//                print(docId)
//
//                databaseMessage.document(docId).delete()
//                messages.remove(at: 1)
//
//    //            datas.append(messId)
//    //            chatRoomTable.reloadData()
//            }
            
            print(i)
            let docId = datas[i]
            print(docId)
        
            databaseMessage.document(docId).delete()
            messages.removeFirst()
        }
        
        print(datas)
        
    }


    //並び替えを可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//        var numbersString: [String] = []
//        var numbersInt: [Int] = []

//        numbersString = messages.map({ (value: Message) -> String in
//                        return value.tostring
//                    })
                    // [1, 2, 3]
        
//        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").addDocument(data: messages[0])
        
        
//        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").getDocuments { (documents, err)  in
//
//            documents?.documents.forEach { document in
//                let dataDescription = document.data()
//                print(dataDescription)
////                let dataDescription = document.data().map(String.init(describing:))
////                print(dataDescription)
//                print(dataDescription[0])
//
////                let docData = [
////                    "name": ,
////                    "createdAt": Timestamp(),
////                    "uid": uid,
////                    "message": text
////                ] as [String : Any]
//
////                docData = dataDescription[0]
////                self.messages.append(message)
//
//
//
//                self.datas.append(dataDescription)
//                print(self.datas)
//            }
//
//        }
//    }
