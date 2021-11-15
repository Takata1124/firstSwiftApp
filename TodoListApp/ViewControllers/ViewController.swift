//
//  ViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/16.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FSCalendar

class ViewController: UIViewController, UITextFieldDelegate,  UINavigationBarDelegate, FSCalendarDelegate, FSCalendarDataSource {

//    var firstArray : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]

    var searchkey : String?
    var selectkey : String?
    var delete_button: Bool = false
    var data_bool: Bool = true
    var delete_count: Int = 0
    var dataList: [String] = []
    
    @IBOutlet weak var calender: FSCalendar!
    
//    let userDefaults = UserDefaults.standard
//    var testText: String = "default"

//    var saveArray: Array! = [NSData]()
    
//    @IBOutlet weak var selectPicker: UIPickerView!
    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var delete_b: UIButton!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var changebutton: UIButton!
    @IBOutlet weak var calenderButton: UIButton!
    
    var user: User?
    var category: Category?
    
    var categories = [Category]()
    
    var chatVC: ChatRoomStoryViewController?
    var again: Bool?
    var index: Int?
    
    var calender_bool: Bool?
    
    private var categoryListener: ListenerRegistration?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpViews()
        
        firebaseEventCount()
       
//        fetchCategoryInfoFromFirestore()
        fetchUserCategory()
        fetchUserInfoFromFirestore()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
//        ScrollFirst()
    }
    
//    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    
    private func setUpViews() {
        
//        selectPicker.layer.cornerRadius = 50
        
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        categoryTable.separatorColor = .black
        
        navbar_t.items![0].title = ""
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
//        navbar_t.isTranslucent = true
//        navbar_t.titleTextAttributes = [
//            // 文字の色
//                .foregroundColor: UIColor.black
//            ]
        
//        calender.backgroundColor = .clear
        calender.appearance.headerTitleColor = .blue
        calender.appearance.weekdayTextColor = .blue
        calender.appearance.borderRadius = 0
//        calender.appearance.todayColor = .white
        calender.appearance.titleWeekendColor = .red
        calender.appearance.selectionColor = .clear
        calender.appearance.borderSelectionColor = .blue
        
        calender.scope = .month
        calender_bool = false
        
        calender.delegate = self
        calender.dataSource = self
        
//        tableviewHeight.constant = 100
        
//        let storyboard = UIStoryboard.init(name: "chatRoomStory", bundle: nil)
//        chatVC = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as! ChatRoomStoryViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

//        viewdidloadNext()
        
        ConfirmUserSign()

    }
    
//    func ScrollFirst() {
//        
//        categoryTable.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: true)
//        print("scroll")
//    }
    
    @IBAction func SelsectCalender(_ sender: Any) {
        
        if calender_bool == false {
            
            calender.scope = .week
            calender_bool = true
        } else {
            
            calender.scope = .month
            calender_bool = false
        }
    }
    
    @IBAction func newTextAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "NewText", bundle: nil)
        let newTextViewController = storyboard.instantiateViewController(withIdentifier: "NewTextViewController") as! NewTextViewController
        newTextViewController.modalPresentationStyle = .fullScreen
        self.present(newTextViewController, animated: true, completion: nil)
    }

    private func addCategory(text: String) {
    //    print("tapbutton")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
    //    guard let partnerUid = self.selectedUser?.uid else { return }
    //    let members = [uid, partnerUid]
        
        let docData = [
            "uid": uid,
            "categorytitle": text,
            "createdAt": Timestamp()
        ] as [String: Any]
        
        Firestore.firestore().collection("users").document(uid).collection("category").addDocument(data: docData) { (err) in
            if let err = err {
                print("カテゴリーの保存に失敗しました(\(err)")
                return
            }
            
            print("カテゴリーの保存が成功しました")
    //        self.dismiss(animated: true, completion: nil)
        }
    }
    
    var newTexts = [NewText]()
    var dates = [String]()
    
    func firebaseEventCount() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        Firestore.firestore().collection("users").document(uid).collection("newMessage").order(by: "DateAt", descending: true).getDocuments { [self] (documents, err) in
            if let err = err {
                print("err")
            }
            
            documents?.documents.forEach({ (document) in
                
                let dic = document.data()
                let newtext = NewText(dic: dic)
                newtext.NewtextId = document.documentID
                
                self.newTexts.append(newtext)
                self.dates.append(newtext.DateAt)
                
                print(self.dates)
                
            })
        }
    }
    
    private func fetchUserCategory() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        Firestore.firestore().collection("users").document(uid).collection("category").addSnapshotListener { (snapshots, err) in
            if let err = err {
                print("メッセージの取得に失敗しました")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let catego = Category(dic: dic)
                    catego.categoryId = documentChange.document.documentID
//                    self.category?.categoryId = documentChange.document.documentID
                    
                    self.categories.append(catego)
                    self.categoryTable.reloadData()
                    
                case .modified:
                    print("nothing")
                case .removed:
                    print("nothing")
                }
            })
        }
    }
    
    private func fetchUserInfoFromFirestore() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("user情報の取得に失敗しました")
                return
            }
            
            guard let snapshot = snapshot else { return }
            guard let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
//            print(user.username)
//            print(type(of: user.username))
            self.navbar_t.items![0].title = user.username
        }
    }
    
    func ConfirmUserSign() {
        
        if Auth.auth().currentUser?.uid == nil {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func changemode(_ sender: Any) {
        
        if (categoryTable.isEditing == true) {
            categoryTable.isEditing = false
            //            chatRoomTable.allowsSelectionDuringEditing = false
//            addButton.isEnabled = true
//            returnButton.isEnabled = true
            changebutton.setTitle("Edit", for: .normal)
            
        } else {
            categoryTable.isEditing = true
            //            chatRoomTable.allowsSelectionDuringEditing = true
//            addButton.isEnabled = false
//            returnButton.isEnabled = false
            changebutton.setTitle("Editing", for: .normal)
        }
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
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

    @IBAction func settingfunc(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let settingViewController = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        self.present(settingViewController, animated: true, completion: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "categoryを追加", message: "追加するcategory名を入力してください", preferredStyle: .alert)

        alertController.addTextField { textField in
            
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
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
                
                self.addCategory(text: text)
                
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
    
    func printing() {
        print("ppp")
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("select")
        
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        
        let totalDate: String = "\(year)/\(month)/\(day)"
        
        print(totalDate)
        
        let storyboard = UIStoryboard(name: "Today", bundle: nil)
        let todayViewController = storyboard.instantiateViewController(withIdentifier: "TodayViewController") as! TodayViewController
        todayViewController.dateTitle = totalDate
        todayViewController.modalPresentationStyle = .fullScreen
        self.present(todayViewController, animated: true, completion: nil)
    }
    
    let dateFormatter = DateFormatter()
    
    func dateChange(text: String) -> String {
        
        let str:String = text
        let arr:[String] = str.components(separatedBy: "/")

        let year = arr[0]
        let month = arr[1]
        let date = arr[2]

        let changedDate = "\(date)-\(month)-\(year)"
        return changedDate
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var intint: Int = 0
        
        if dates.count > 1 {
            
            let minusDatesCount: Int = dates.count - 1
            
            for i in 0...minusDatesCount {
                
                let trydate = dates[i]
                
                let dated = dateChange(text: trydate)
                print("dated",dated)
                
                dateFormatter.dateFormat = "dd-MM-yyyy"
                guard let eventDate = dateFormatter.date(from: dated) else { return 0}
                
                if date.compare(eventDate) == .orderedSame {
                    intint = 1
                }
            }
             
        } else { intint = 0}
        
        return intint
    }
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        categoryTable.estimatedRowHeight = 20
        return UITableView.automaticDimension
//        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.font = UIFont.systemFont(ofSize: 15)
        cell.category = categories[indexPath.row]
        cell.separatorInset = .zero
        cell.categoLabel.isHidden = true
        cell.timeLabel.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("indexpppath", indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard.init(name: "chatRoomStory", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as! ChatRoomStoryViewController
        chatRoomViewController.user = user
        chatRoomViewController.category = categories[indexPath.row]
        chatRoomViewController.indexpath = indexPath
        chatRoomViewController.modalPresentationStyle = .fullScreen
        self.present(chatRoomViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //
            guard let cateID = categories[indexPath.row].categoryId else { return }
            //            print(messId)
            
//            guard let categoDocId = category?.categoryId else { return  }
            guard let uid = Auth.auth().currentUser?.uid else  { return }
            
            Firestore.firestore().collection("users").document(uid).collection("category").document(cateID).delete()
            
            categories.remove(at: indexPath.row)
            categoryTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
        
        let list = categories[fromIndexPath.row]
        categories.remove(at: fromIndexPath.row)
        categories.insert(list, at: to.row)
        
        print("編集")
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if categoryTable.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

