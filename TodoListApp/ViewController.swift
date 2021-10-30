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
    
    Firestore.firestore().collection("category").addDocument(data: docData) { (err) in
        if let err = err {
            print("カテゴリーの保存に失敗しました(\(err)")
            return
        }
        
        print("カテゴリーの保存が成功しました")
//        self.dismiss(animated: true, completion: nil)
    }
}

class ViewController: UIViewController, UITextFieldDelegate,  UINavigationBarDelegate {

//    var firstArray : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]

    var searchkey : String?
    var selectkey : String?
    var delete_button: Bool = false
    var data_bool: Bool = true
    var delete_count: Int = 0
    var dataList: [String] = []
    
//    let userDefaults = UserDefaults.standard
//    var testText: String = "default"

//    var saveArray: Array! = [NSData]()
    
//    @IBOutlet weak var selectPicker: UIPickerView!
    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var delete_b: UIButton!
    @IBOutlet weak var categoryTable: UITableView!
    
    var category: Category?
    private var categories = [Category]()
    
    private var categoryListener: ListenerRegistration?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpViews()
//        fetchCategoryInfoFromFirestore()
        fetchCategory()

    }
    
    private func setUpViews() {
        
//        selectPicker.layer.cornerRadius = 50
//        selectPicker.delegate = self
//        selectPicker.dataSource = self
        
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        
        navbar_t.items![0].title = "Category"
        
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar_t.isTranslucent = true
        navbar_t.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        viewdidloadNext()
//    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

    }
    
    func fetchCategoryInfoFromFirestore() {
        
        Firestore.firestore().collection("category").getDocuments { (snapshots, err) in
            if let err = err {
                print("カテゴリー情報の取得に失敗しました\(err)")
                return
            }
            
            //            print(snapshots)
            print("カテゴリー情報の取得に成功しました")
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let catego = Category.init(dic: dic)
                //                user.uid = snapshot.documentID
                
                //                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                //                //loginUserでなければ
                //                if uid == snapshot.documentID {
                //                    return
                //                }
                
                self.categories.append(catego)
                self.categoryTable.reloadData()
            })
        }
    }
    
    func fetchCategory() {
        
//        guard let categoryDocId = category?.categoryId else { return }
        
        
        Firestore.firestore().collection("category").addSnapshotListener { (snapshots, err) in
            
            if let err = err {
                print("メッセージの取得に失敗しました")
                return
            }
            
            snapshots?.documentChanges.forEach({ (documentChange) in
                switch documentChange.type {
                case .added:
                    let dic = documentChange.document.data()
                    let catego = Category(dic: dic)
                    self.categories.append(catego)
                    self.categoryTable.reloadData()
                    
                    print(self.categories)
                    
                case .modified:
                    print("nothing")
                case .removed:
                    print("nothing")
                }
            })
        }
    }
    
    func viewdidloadNext() {
        
        performSegue(withIdentifier: "goNext", sender: nil)
    }
    
    @IBAction func deleteButtonfunc(_ sender: Any) {
        
        if delete_count == 0 {
            
            delete_button = true
            delete_b.backgroundColor = UIColor(red:0.96, green:0.55, blue:0.15, alpha:1.0)
            delete_count = 1
        }
        else {
            
            delete_button = false
            delete_b.backgroundColor = UIColor.clear
            delete_count = 0
        }
    }

    @IBAction func settingfunc(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "categoryを追加", message: "追加するcategory名を入力してください", preferredStyle: .alert)

        alertController.addTextField { textField in
            let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            textField.addConstraint(heightConstraint)
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                if textField.text == "" {
                    return
                }
                
                guard let text = textField.text else { return }
                
                addCategory(text: text)
                
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
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.font = UIFont.systemFont(ofSize: 16)
        cell.category = categories[indexPath.row]
        return cell
    }
}

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if (segue.identifier == "goNext") {
//            let taskVC = segue.destination as! TaskViewController
//            taskVC.textVC = select_1
//        }
//    }

//    func readData() -> String {
//
//        let str: String = userDefaults.object(forKey: "DataStore") as! String
//        return str
//    }
//
//    func saveData(str: String?) {
//
//        userDefaults.set(str, forKey: "DataStore")
//    }
//
//    func arraySave(str: String?){
//
//        guard let unstr = str else {return}
//        print(unstr)
//        firstArray = userDefaults.array(forKey: "FirstArray") as! [String]
//        firstArray.append(unstr)
//        userDefaults.set(firstArray, forKey: "FirstArray")
//
//
//    }

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()
//
//        testText = textField.text!
//
//        arraySave(str: testText)
//        textField.text = ""
//
//        return true
//    }
    
//// UIPickerViewの列の数
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    // UIPickerViewの行数、リストの数
//    func pickerView(_ pickerView: UIPickerView,
//                    numberOfRowsInComponent component: Int) -> Int {
//
//        return dataList.count
//    }
//
//    // UIPickerViewの最初の表示d
//    func pickerView(_ pickerView: UIPickerView,
//                    titleForRow row: Int,
//                    forComponent component: Int) -> String? {
//
//        return dataList[row]
//    }
//
////    var select_0: String?
//    var select_1: String?
//
//    // UIPickerViewのRowが選択された時の挙動
//    func pickerView(_ pickerView: UIPickerView,
//                    didSelectRow row: Int,
//                    inComponent component: Int) {
//
//
//        if delete_button == false {
//
//            select_1 = dataList[row]
//
//
//            guard let select_11 = select_1 else {return}
//
//            navbar_t.items![0].title = dataList[row]
//            performSegue(withIdentifier: "goNext", sender: nil)
//        }
//
//        if delete_button == true {
//
//            select_1 = dataList[row]
//            test_alert(select_1)
//
//            self.memberVariable = row
//        }
//    }
//
//    var memberVariable: Int = 0
//
//    func test_alert(_ sender: String?) {
//
//        let alert: UIAlertController = UIAlertController(title: select_1, message: "削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
//
//                // ② Actionの設定
//                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
//                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
//                // OKボタン
//            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
//                // ボタンが押された時の処理を書く（クロージャ実装）
//                (action: UIAlertAction!) -> Void in
////                print("OK")
//                print(self.memberVariable)
//                print(self.dataList[self.memberVariable])
////                self.dataList = self.userDefaults.array(forKey: "FirstArray") as! [String]
//
//                self.dataList.remove(at: self.memberVariable)
////                self.dataList = self.userDefaults.array(forKey: "FirstArray") as! [String]
//                self.selectPicker.reloadAllComponents()
////                self.selectPicker.delegate = self
////                self.selectPicker.dataSource = self
//                print(self.dataList)
//                self.userDefaults.set(self.dataList, forKey: "FirstArray")
//
//            })
//            // キャンセルボタン
//            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
//                // ボタンが押された時の処理を書く（クロージャ実装）
//                (action: UIAlertAction!) -> Void in
////                print("Cancel")
//            })
//
//            // ③ UIAlertControllerにActionを追加
//            alert.addAction(cancelAction)
//            alert.addAction(defaultAction)
//
//            // ④ Alertを表示
//            present(alert, animated: true, completion: nil)
//    }

