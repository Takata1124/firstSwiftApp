//
//  DoListViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/01.
//

import UIKit
import SideMenu
import Firebase
import FirebaseAuth
import FirebaseFirestore



class DoListViewController: UIViewController, UINavigationBarDelegate {
    

    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var dolistTable: UITableView!
    
    var user: User?
    var category: Category?
    var message: Message?
    var dolist: DoList?
    
    var dolists = [DoList]()

    var menu: SideMenuNavigationController?
    
    private lazy var chatInputAccessoryViwe: ChatInputAccessoryView = {
        
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        fetchdoList()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryViwe
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func setUpView() {
        
        navbar_t.items![0].title = ""
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar_t.items![0].title = message?.message
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        //        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        dolistTable.delegate = self
        dolistTable.dataSource = self
        dolistTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    private func fetchdoList() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        guard let messageDcId = message?.messageId else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messageDcId).collection("doList").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗しました")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                
                switch documentChange.type {
                case .added:
                    
                    let dic = documentChange.document.data()
                    let dolis = DoList(dic: dic)
                    dolis.dolistId = documentChange.document.documentID
                    self.dolists.append(dolis)
                    self.dolistTable.reloadData()
                    
                case .modified:
                    
//                    Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messageDcId).collection("doList")
//                    let dic = documentChange.document.data()
//                    let dolis = DoList(dic: dic)
//                    dolis.dolistId = documentChange.document.documentID
//                    self.dolists.append(dolis)
                    
//                    self.dolistTable.reloadData()
                    
                    print("modify")
                case .removed:
                    print("remove")
                }
            })
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    func closeViewController () {
        self.dismiss(animated: true, completion: nil)
        print("tappeded")
    }
}

var indexList: [Int] = []
//var clicked: Bool = false



extension DoListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dolistTable.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        cell.dolist = dolists[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
//        var docId: String?
        var chattext: String?
        chattext = dolists[indexPath.row].dolisttitle
        var clicked = dolists[indexPath.row].click!
        
        var listId: String?
        listId = dolists[indexPath.row].dolistId
//        docId = dolists[indexPath.row].dolistId
        print(clicked ?? "")
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        guard let messageDcId = message?.messageId else { return }
//        guard let name = user?.username else { return }
        
//        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messageDcId).collection("doList").getDocuments { (documents, err) in
//            if let err = err {
//                print("err")
//                return
//            }
//            documents?.documents.forEach { document in
//
//                let dic = document.document.data()
//                let dolis = DoList(dic: dic)
//                dolis.dolistId = document.document.documentID
//                self.dolists.append(dolis)
//                self.dolistTable.reloadData()
//
//        }
        
//        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").getDocuments { (documents, err)  in
//
//            documents?.documents.forEach { document in
//                let dataDescription = document.data()
//                print(dataDescription)
//                let dataDescription = document.data().map(String.init(describing:))
//                print(dataDescription)
//                print(dataDescription[0])
        
        print(indexPath)
        
        if clicked == false {
            
            let docData = [
//                "name": name,
                "createdAt": Timestamp(),
                "uid": uid,
                "dolisttitle": chattext,
                "click": true
            ] as [String : Any]
            
            listId = dolists[indexPath.row].dolistId
            print(listId)
            let dolis = DoList(dic: docData)
            dolists[indexPath.row] = dolis
            dolists[indexPath.row].dolistId = listId
//            cell.dolist = dolis
            
            print("clickTrue")
            clicked = true
            Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messageDcId).collection("doList").document(listId!).updateData([
      
                "click": true
                
            ])
            dolistTable.reloadData()
            
        } else {
            
            let docData = [
//                "name": name,
                "createdAt": Timestamp(),
                "uid": uid,
                "dolisttitle": chattext,
                "click": false
            ] as [String : Any]
            
            listId = dolists[indexPath.row].dolistId
            print(listId)
            let dolis = DoList(dic: docData)
            dolists[indexPath.row] = dolis
            dolists[indexPath.row].dolistId = listId
            
            print("clickFalse")
            clicked = false
            Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messageDcId).collection("doList").document(listId!).updateData([
      
                "click": false
            ])
            dolistTable.reloadData()
        }
        
//        cell.dolist = dolists[indexPath.row]
        
//        print("tapped")
        
        
//        print(type(of: indexPath))
        
//        if indexList.contains(indexPath.row) {
//
//            let indexPli = indexList.count - 1
//            for i in 0...indexPli {
//
//                if indexList[i] == indexPath.row {
//
//                    indexList.remove(at: i)
//                    cell?.accessoryType = .none
//                    break
//
//                } else {
//
//                    continue
//                }
//            }
//        } else {
//
//            indexList.append(indexPath.row)
//            cell?.accessoryType = .checkmark
//        }
    }
}

extension DoListViewController: ChatInputAccessoryViewDelegate {
    
    func tappedBackButton() {
        
        chatInputAccessoryViwe.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func tappedSendButton(text: String) {
        
        guard let name = user?.username else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard let categoDocId = category?.categoryId else { return  }
        guard let messageDcId = message?.messageId else { return }
        
        chatInputAccessoryViwe.removetext()
        
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "dolisttitle": text,
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).collection("category").document(categoDocId).collection("messages").document(messageDcId).collection("doList").document().setData(docData) { (err) in
            if let err = err {
                print("メッセージの保存に失敗しました")
                return
            }
            print("メッセージの保存に成功しました")
        }
    }
}

class MenuListController: UITableViewController {
    
    var dolistviewController: DoListViewController?
    var items = ["Logout", "Category", "Task", "Detail", "Setting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tableView.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = items[indexPath.row]
        cell.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
        cell.categoryLabel.tintColor = UIColor.red
        
        if indexPath.row == 3 {
            
            cell.categoryLabel.textColor = .white
            print(indexPath)
            print("white")
        } else {
        
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print(items[indexPath.row])
        
        if (items[indexPath.row] == "Logout") {
            //            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                signUpViewController.modalPresentationStyle = .fullScreen
                self.present(signUpViewController, animated: true, completion: nil)
            } catch {
                print("ログアウトに失敗しました")
            }
        }
        
        if (items[indexPath.row] == "Task") {
            print("実行")
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        
        if (items[indexPath.row] == "Category") {
            print("実行")
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        
        
        
    }
}

//@IBAction func tappedLogout(_ sender: Any) {
//    do {
//        try Auth.auth().signOut()
//        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//        signUpViewController.modalPresentationStyle = .fullScreen
//        self.present(signUpViewController, animated: true, completion: nil)
//    } catch {
//        print("ログアウトに失敗しました")
//    }
//}

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
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        let storyboard = UIStoryboard.init(name: "DoList", bundle: nil)
//        let dolistViewController = storyboard.instantiateViewController(withIdentifier: "DoListViewController") as! DoListViewController
//        //        chatRoomViewController.user = user
//        dolistViewController.message = messages[indexPath.row]
//
//        dolistViewController.modalPresentationStyle = .fullScreen
//        self.present(dolistViewController, animated: true, completion: nil)
