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
import SideMenu

class ChatRoomStoryViewController: UIViewController, UINavigationBarDelegate {
    
    var user: User?
    var category: Category?
    var chatroom: ChatRoom?
    var indexpath: IndexPath?
    
    var backFlag: Bool = false
    
    var menu: SideMenuNavigationController?
    
    private var messages = [Message]()
    
    //    private lazy var chatInputAccessoryViwe: ChatInputAccessoryView = {
    //
    //        let view = ChatInputAccessoryView()
    //        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
    //        view.delegate = self
    //        return view
    //    }()
    
    @IBOutlet weak var chatRoomTable: UITableView!
    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var changebutton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var scrollButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCount = []
        setUpViews()
        
        fetchMessages()
        

        //        getFirebaseDoc()
        
        //        print("indexpath", indexpath)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        ScrollEnd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        //        if backFlag == true {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        
        let messagecount = messages.count - 1
        
        messList.removeAll()
        
        if messagecount < 1 {
            
            return
        }
        
        for i in 0...messagecount {
            
            //            let messkey = messages[i].key
            let messMessage = messages[i].message
            //            guard let messId = messages[i].messageId else { return }
            //            let messId = messages[i].messageId
            //            let messMesId = "\(messId!)/\(messMessage)"
            
            //            messList.updateValue(messMesId, forKey: messkey)
            messList.append(messMessage)
            //            messIdList.append(messId)
        }
        
        for i in 0...messagecount {
            
            let id = uniqueValues[i]
            let mess = messList[i]
            let check = checklist[i]
            
            print(id)
            print(mess)
            print(check)
            
            //                print("uni")
            //
            Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(id).updateData([
                
                "message": mess,
                "click": check
                //                    "click": check
            ])
            
            //                Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(id).updateData([
            //
            ////                    "message": mess
            //
            //
            //                ])
            
            //            let messkey = messages[i].key
            //            let messMessage = messages[i].message
            ////            guard let messId = messages[i].messageId else { return }
            ////            let messId = messages[i].messageId
            ////            let messMesId = "\(messId!)/\(messMessage)"
            //
            ////            messList.updateValue(messMesId, forKey: messkey)
            //            messList.append(messMessage)
            //            messIdList.append(messId)
        }
        //        }
        
        print("dissappear")
        
        
        //
        //        print(messagecount
    }
    
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewDidLoad()
    //
    //        chatInputAccessoryViwe.isHidden = false
    //    }
    
    //    override var inputAccessoryView: UIView? {
    //        get {
    //            return chatInputAccessoryViwe
    //        }
    //    }
    //
    //    override var canBecomeFirstResponder: Bool {
    //        return true
    //    }
    
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
        
        returnButton.layer.cornerRadius = 25
        addButton.layer.cornerRadius = 25
        scrollButton.layer.cornerRadius = 25
        
        scrollButton.addTarget(self, action: #selector(ScrollEnd), for: .touchUpInside)
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true

        SideMenuManager.default.leftMenuNavigationController = menu
//        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
//        menu?.leftSide = false
//
        
        //        let vc =  ViewController()
        //        vc.again = true
        
        //        backFlag = false
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    var inds = [Int]()
    var messes = [String]()
    var messList = [String]()
    var messIdList = [String]()
    var uniqueValues = [String]()
    var checklist = [Bool]()
    //    var messid: Any
    
    private func getFirebaseDoc() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").getDocuments { (documents, err) in
            if let err = err {
                print("err")
            }
            
            documents?.documents.forEach({ (document) in
                
                let dic = document.data()
                let message = Message(dic: dic)
                //                let mess = message.message
                message.messageId = document.documentID
                
                self.messIdList.append(message.messageId ?? "")
                //                self.checklist.append(message.click ?? false)
                
                let orderedSet = NSOrderedSet(array: self.messIdList)
                let uniqueValue = orderedSet.array as! [String]
                
                self.uniqueValues = uniqueValue
                
                print(self.uniqueValues)
                
                //                let messagecount = self.messages.count - 1
                //
                //                print(messagecount)
                //
                //                for i in 0...messagecount {
                //
                //                    self.messList = []
                //
                //        //            let messkey = messages[i].key
                ////                    let messMessage = self.messages[i].message
                //                    guard let messId = self.messages[i].messageId else { return }
                //        //            let messId = messages[i].messageId
                //        //            let messMesId = "\(messId!)/\(messMessage)"
                //
                //        //            messList.updateValue(messMesId, forKey: messkey)
                ////                    self.messList.append(messMessage)
                //                    self.messIdList.append(messId)
                //                }
                
                ////                print(messList)
                ////                print(messIdList)
                //        //
                //
                ////                self.messes.append(mess)
                ////////                self.chatRoomTable.reloadData()
                //////                print(self.messes)
            })
        }
    }
    
    @objc func ScrollEnd() {
        
        let messagecount = messages.count - 1
        
        chatRoomTable.scrollToRow(at: .init(row: messagecount, section: 0), at: .top, animated: false)
        print("scroll")
    }
    
    var messagesCount = [Int]()
    
    private func fetchMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        
        let database = Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages")
        
        database.addSnapshotListener { (snapshots, err) in
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
                    self.messagesCount.append(message.key)
                    self.messages.append(message)
                    self.checklist.append(message.click ?? false)
                    
                    //                    self.messList = []
                    //                    self.messIdList.removeAll()
                    self.getFirebaseDoc()
                    
                    self.chatRoomTable.reloadData()
                    print("add")
                    
                case .modified:
                    
                    print("modify")
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
            //            chatRoomTable.allowsSelectionDuringEditing = false
            addButton.isEnabled = true
            returnButton.isEnabled = true
            changebutton.setTitle("Edit", for: .normal)
            
        } else {
            chatRoomTable.isEditing = true
            //            chatRoomTable.allowsSelectionDuringEditing = true
            addButton.isEnabled = false
            returnButton.isEnabled = false
            changebutton.setTitle("Editing", for: .normal)
        }
    }
    
    @IBAction func returnButtonAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Taskを追加", message: "追加するTask名を入力してください", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            
            textField.addConstraint(heightConstraint)
            textField.placeholder = "入力"
            textField.font = UIFont.systemFont(ofSize: 17)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            
            if let textField = alertController.textFields?.first {
                if textField.text == "" {
                    return
                }
                
                guard let text = textField.text else { return }
                
                self.tappedSendButton(text: text)
                
                do {
                    print("完了")
                } catch {
                    print("error")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tappedSendButton(text: String) {
        
        guard let categoDocId = category?.categoryId else { return  }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        //        chatInputAccessoryViwe.removetext()
        var messcount: Int = 0
        
        if messages.count == 0 {
            
            messcount = 0
        } else {
            
            messcount = messagesCount.max()! + 1
        }
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": text,
            "click": false,
            "key": messcount
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document().setData(docData) { (err) in
            if let err = err {
                print("メッセージの保存に失敗しました")
                return
            }
            print("メッセージの保存に成功しました")
        }
        
        //        let storyboardmain = UIStoryboard.init(name: "Main", bundle: nil)
        //        let viewController = storyboardmain.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        //        let storyboard = UIStoryboard.init(name: "chatRoomStory", bundle: nil)
        //        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as! ChatRoomStoryViewController
        //        chatRoomViewController.user = user
        //        chatRoomViewController.category = categories[indexpath]
        
        //        chatRoomViewController.user = viewController.user
        
        //        guard let indexpath = indexpath else {
        //            return
        //        }
        
        //        let vc = self.presentingViewController as! ViewController
        //        vc.again = true
        //        print(type(of: indexpath.row))
        //        vc.index = indexpath.row
        
        //        self.dismiss(animated: true, completion: nil)
        
        
        //        viewController.tableView(viewController.categoryTable!, didSelectRowAt: indexpath as! IndexPath)
        
        //        self.category = viewController.categories[indexpath]
        
        //        self.modalPresentationStyle = .fullScreen
        //        viewController.present(self, animated: true, completion: nil)
        
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        let storyboard = UIStoryboard.init(name: "DoList", bundle: nil)
        //        let dolistViewController = storyboard.instantiateViewController(withIdentifier: "DoListViewController") as! DoListViewController
        //        dolistViewController.user = user
        //        dolistViewController.category = category
        //        dolistViewController.message = messages[0]
        //        dolistViewController.modalPresentationStyle = .fullScreen
        //        self.present(dolistViewController, animated: true, completion: nil)
        //        dolistViewController.dismiss(animated: true, completion: nil)
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
        
        //        var messList = [Int: Any]()
        //        let messagecount = messages.count - 1
        //
        ////        print(messagecount)
        //
        //        for i in 0...messagecount {
        //
        //            let messkey = messages[i].key
        //            let messMessage = messages[i].message
        //            let messId = messages[i].messageId
        //            let messMesId = "\(messId!)/\(messMessage)"
        //
        //            messList.updateValue(messMesId, forKey: messkey)
        //        }
        //
        ////        print(messList)
        //        let sortedDic = messList.sorted{ $0.key < $1.key }
        //
        //        if messList.count != 0 {
        //
        ////            print("kkk")
        //            let str: String = (sortedDic[indexPath.row].value as? String)!
        //            let arr:[String] = str.components(separatedBy: "/")
        //
        //            cell.cellText.text = arr[1]
        //
        //            cell.cellText.text = messages[indexPath.row].message
        //        }
        
        
        
        cell.cellText.text = messages[indexPath.row].message
        //
        ////        cell.message = messages[indexPath.row]
        cell.click = checklist[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        let clicked: Bool = checklist[indexPath.row]
        
        if clicked == false {
            
            checklist[indexPath.row] = true
            print("true")
            print(checklist)
            
            cell.click = checklist[indexPath.row]
            chatRoomTable.reloadData()
        } else {
            
            checklist[indexPath.row] = false
            print("false")
            print(checklist)
            
            cell.click = checklist[indexPath.row]
            chatRoomTable.reloadData()
        }
        
        
        
       
        
        //        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        //
        //        //        var docId: String?
        //        var chattext: String?
        //        chattext = messages[indexPath.row].message
        //        var clicked = messages[indexPath.row].click!
        //
        //        var listId: String?
        //        listId = messages[indexPath.row].messageId
        ////        print(listId)
        //        //        docId = dolists[indexPath.row].dolistId
        ////        print(clicked ?? "")
        //
        //        guard let uid = Auth.auth().currentUser?.uid else  { return }
        //        guard let categoDocId = category?.categoryId else { return }
        ////        guard let messageDcId = message?.messageId else { return }
        //
        ////        print(indexPath)
        //
        //        if clicked == false {
        //
        //            let docData = [
        //                //                "name": name,
        //                "createdAt": Timestamp(),
        //                "uid": uid,
        //                "message": chattext,
        //                "click": true
        //            ] as [String : Any]
        //
        //            print(listId)
        //
        ////            listId = dolists[indexPath.row].dolistId
        ////            print(listId)
        //            let dolis = Message(dic: docData)
        //            messages[indexPath.row] = dolis
        ////            dolists[indexPath.row].dolistId = listId
        //            cell.message = dolis
        //
        //            print("clickTrue")
        //            clicked = true
        //            Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(listId!).updateData([
        //
        //                "click": true
        //
        //            ])
        //
        //            chatRoomTable.reloadData()
        //
        //        } else if clicked == true {
        //
        //            let docData = [
        //                //                "name": name,
        //                "createdAt": Timestamp(),
        //                "uid": uid,
        //                "message": chattext,
        //                "click": false
        //            ] as [String : Any]
        //
        //            print(listId)
        //
        ////            listId = dolists[indexPath.row].dolistId
        ////            print(listId)
        ////            let dolis = DoList(dic: docData)
        ////            dolists[indexPath.row] = dolis
        ////            dolists[indexPath.row].dolistId = listId
        //
        ////            listId = dolists[indexPath.row].dolistId
        ////            print(listId)
        //
        //            let dolis = Message(dic: docData)
        //            messages[indexPath.row] = dolis
        ////            dolists[indexPath.row].dolistId = listId
        //            cell.message = dolis
        //
        //            print("clickFalse")
        //            clicked = false
        //            Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(listId!).updateData([
        //
        //                "click": false
        //            ])
        //
        //            chatRoomTable.reloadData()
        //        }
        //
        ////        let storyboard = UIStoryboard.init(name: "DoList", bundle: nil)
        ////        let dolistViewController = storyboard.instantiateViewController(withIdentifier: "DoListViewController") as! DoListViewController
        ////        dolistViewController.user = user
        ////        dolistViewController.category = category
        ////        dolistViewController.message = messages[indexPath.row]
        ////        dolistViewController.modalPresentationStyle = .fullScreen
        //        self.present(dolistViewController, animated: true, completion: nil)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //
            guard let messId = messages[indexPath.row].messageId else { return }
            //            print(messId)
            
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
        
        //        var messList = [String]()
        //        var messIdList = [String]()
        
        let list = messages[fromIndexPath.row]
        messages.remove(at: fromIndexPath.row)
        messages.insert(list, at: to.row)
        
        let checkli = checklist[fromIndexPath.row]
        checklist.remove(at: fromIndexPath.row)
        checklist.insert(checkli, at: to.row)
        
        messList.removeAll()
        
        let messagecount = messages.count - 1
        
        for i in 0...messagecount {
            
            //            let messkey = messages[i].key
            let messMessage = messages[i].message
            //            guard let messId = messages[i].messageId else { return }
            //            let messId = messages[i].messageId
            //            let messMesId = "\(messId!)/\(messMessage)"
            
            //            messList.updateValue(messMesId, forKey: messkey)
            messList.append(messMessage)
            //            messIdList.append(messId)
        }
        
        print(messList)
        //        print(messIdList)
        print(uniqueValues)
        print("編集")
        
//        //セルを編集した場合のフラグ
//        backFlag = true
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    ////
    //        print(messList)
    //        let sortedDic = messList.sorted{ $0.key < $1.key }
    //
    //        let beforekey = sortedDic[fromIndexPath.row].key
    //
    //        let str: String = (sortedDic[fromIndexPath.row].value as? String)!
    //        let arr:[String] = str.components(separatedBy: "/")
    //        let beforedoId: String = arr[0]
    //
    //        let afterkey = sortedDic[to.row].key
    //
    //        let afterstr: String = (sortedDic[to.row].value as? String)!
    //        let afterarr:[String] = afterstr.components(separatedBy: "/")
    //        let afterdoId: String = afterarr[0]
    
    
    //        let beforeId: String = sortedDic[fromIndexPath.row].value.components(separatedBy: "/")[0]
    //        guard let beforedcId = messages[fromIndexPath.row].messageId else { return }
    //        print(beforemessage)
    //        print(beforekey)
    ////        print(beforedcId)
    //        let aftermessage = messages[to.row].message
    //        let afterKey = messages[to.row].key
    //        guard let afterID = messages[to.row].messageId else { return }
    //        print(aftermessage)
    //        print(afterKey)
    //        print(afterID)
    
    //
    //        database.document(afterdoId).updateData([
    //
    //            "key": beforekey
    //        ])
    //        self.loadView()
    //
    //        messages = []
    //        setUpViews()
    //        fetchMessages()
    //
    //        chatRoomTable.isEditing = true
    //        addButton.isEnabled = false
    
    //        viewDidLoad()
    
    //        self.dismiss(animated: false, completion: nil)
    
    //        let storyboard = UIStoryboard.init(name: "chatRoomStory", bundle: nil)
    //        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as! ChatRoomStoryViewController
    ////        chatRoomViewController.user = user
    ////        chatRoomViewController.category = categories[indexPath.row]
    //
    //        chatRoomViewController.modalPresentationStyle = .fullScreen
    //        self.present(chatRoomViewController, animated: true, completion: nil)
    
    //        database.document(beforedcId).updateData([
    //
    //            "message": aftermessage
    //        ])
    //
    //        database.document(afterID).updateData([
    //
    //            "message": beforemessage
    //        ])
    
    //        chatRoomTable.reloadData()
    
    
    
    //    並び替えを可能にする
    //    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //
    //        return true
    //    }
    //
    
}



//        var messcount: Int = messages.count - 1
//
//        for i in 0...messcount {
//
//            let docData = [
//                "name": messages[i].name,
//                "createdAt": messages[i].createdAt,
//                "uid": messages[i].uid,
//                "message": messages[i].message
//
//            ] as [String : Any]
//
//            database.document().setData(docData) { (err) in
//                if let err = err {
//                    print("メッセージの保存に失敗しました")
//                    return
//                }
//                print("メッセージの保存に成功しました")
//            }
//        }
//
//        for i in 0...IDcount {
//
//            print(i)
//            let docId = datas[i]
//            print(docId)
//
////            database.document(docId ?? "").delete()
////            messages.removeFirst()
//        }

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

//extension ChatRoomStoryViewController: ChatInputAccessoryViewDelegate {
//
//    func tappedBackButton() {
//
//        chatInputAccessoryViwe.isHidden = true
//        dismiss(animated: true, completion: nil)
//    }
//
//    func tappedSendButton(text: String) {
//
//        guard let categoDocId = category?.categoryId else { return  }
//        guard let name = user?.username else { return }
//        guard let uid = Auth.auth().currentUser?.uid else  { return }
//
//        chatInputAccessoryViwe.removetext()
//
//        let docData = [
//            "name": name,
//            "createdAt": Timestamp(),
//            "uid": uid,
//            "message": text,
//            "click": false
//        ] as [String : Any]
//
//        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document().setData(docData) { (err) in
//            if let err = err {
//                print("メッセージの保存に失敗しました")
//                return
//            }
//            print("メッセージの保存に成功しました")
//        }
//    }
//}

//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//       let cell = tableView.cellForRow(at: indexPath)
//       cell!.accessoryType = .none
//   }

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
