//
//  ViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/16.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationBarDelegate {
    
//    var dataList : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]
    var firstArray : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]
//    var categoryList : [String] = ["apple", "banana","chocolate"]
    var searchkey : String?
    var selectkey : String?
    var delete_button: Bool = false
    var data_bool: Bool = true
    var delete_count: Int = 0
    var dataList: [String] = []
    
    let userDefaults = UserDefaults.standard
    var testText: String = "default"
    
    var saveArray: Array! = [NSData]()
    

//    @IBOutlet weak var selectButton: UIButton!
//    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var selectPicker: UIPickerView!
//    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var delete_b: UIButton!
//    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        selectButton.layer.cornerRadius = 100
//        selectButton.layer.borderColor = UIColor.black.cgColor
//        selectButton.layer.borderWidth = 1.0
//        selectButton.isEnabled = false
//        selectButton.isHidden = true
        
//        newText.layer.borderColor = UIColor.lightGray.cgColor
//        newText.layer.borderWidth = 1.0
//        newText.delegate = self
//        newText.isUserInteractionEnabled = false
//        newText.isHidden = true
//        newText.layer.cornerRadius = 20
        
//        selectPicker.layer.borderColor = UIColor.black.cgColor
//        selectPicker.layer.borderWidth = 1.0
        selectPicker.layer.cornerRadius = 50
        selectPicker.delegate = self
        selectPicker.dataSource = self
//        selectPicker.center = self.view.center
        
//        selectPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
//        selectPicker.selectRow(0, inComponent: 0, animated: false)
//        selectPicker.selectRow(1, inComponent: 1, animated: false)
        
//        selectLabel.text = "カテゴリー"
//        selectLabel.layer.borderColor = UIColor.lightGray.cgColor
//        selectLabel.layer.borderWidth = 1.0
        
        navbar_t.items![0].title = "Category"
        
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar_t.isTranslucent = true
        navbar_t.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
        
//        userDefaults.register(defaults: ["DataStore": "default"])
//        label.text = readData()
        
        userDefaults.register(defaults: ["FirstArray": firstArray])
        dataList = userDefaults.array(forKey: "FirstArray") as! [String]
        print(dataList)
//        label.text = getfirstArray[0]
        
//        self.navigationItem.title = "Todo"
//        self.navigationController?.navigationBar.backgroundColor = UIColor.purple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        userDefaults.register(defaults: ["DataStore": "default"])
//        label.text = readData()
        
//        userDefaults.set(self.secondArray, forKey: "FirstArray")
        selectPicker.delegate = self
        selectPicker.dataSource = self
        
        dataList = userDefaults.array(forKey: "FirstArray") as! [String]
//        print(dataList)
//        print(firstArray)
//        label.text = getfirstArray[0]
    }
    
    func readData() -> String {
        
        let str: String = userDefaults.object(forKey: "DataStore") as! String
//        print(str)
        return str
    }
    
    func saveData(str: String?) {
        
        userDefaults.set(str, forKey: "DataStore")
    }
    
    func arraySave(str: String?){
        
        guard let unstr = str else {return}
        print(unstr)
        firstArray = userDefaults.array(forKey: "FirstArray") as! [String]
        firstArray.append(unstr)
        userDefaults.set(firstArray, forKey: "FirstArray")
       
//        userDefaults.set(firstArray, forKey: "FirstArray")
//        print(firstArray)
//        print(dataList)
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
    
    @IBAction func selectfunc(_ sender: Any) {
        
        performSegue(withIdentifier: "goNext", sender: nil)
    }
    
    @IBAction func settingfunc(_ sender: Any) {
        
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goNext") {
            let taskVC = segue.destination as! TaskViewController
            taskVC.textVC = select_1
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        testText = textField.text!
//        print(testText)
//        print(type(of: testText))
//        saveData(str: testText)
        arraySave(str: testText)
        
//        label.text = readData()
        
//        if var searchkey = textField.text {
//            dataList.append(searchkey)
//        }
//        print(dataList)
//
//        selectPicker.reloadAllComponents()
        textField.text = ""
        
        return true
    }
    
// UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
//        switch component {
//        case 0:
//            return categoryList.count
//        case 1:
//            return dataList.count
//        default:
//            return 0
//        }
        
//        dataList = userDefaults.array(forKey: "FirstArray") as! [String]
        return dataList.count
    }
    
    // UIPickerViewの最初の表示d
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return categoryList[row]
//        case 1:
//            return dataList[row]
//        default:
//            return "error"
//        }
        
//        dataList = userDefaults.array(forKey: "FirstArray") as! [String]
        return dataList[row]
    }
    
//    var select_0: String?
    var select_1: String?
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
//        switch component {
//        case 0:
//            selectkey = categoryList[row]
//            select_0 = categoryList[row]
//            selectButton.isEnabled = true
//        case 1:
//            selectkey = dataList[row]
//            select_1 = dataList[row]
//            selectButton.isEnabled = true
//        default:
//            break
//        }
//
//        guard let select_00 = select_0 else {return}
//        guard let select_11 = select_1 else {return}
//        selectLabel.text = /*"カテゴリー/タスク： \n*/"\(select_00)/\(select_11)"
        
        if delete_button == false {
            
//            selectkey = dataList[row]
//            dataList = userDefaults.array(forKey: "FirstArray") as! [String]
            select_1 = dataList[row]
//           print(select_1)
//           selectButton.isEnabled = true
           
            guard let select_11 = select_1 else {return}
//            selectLabel.text = select_11 /*"カテゴリー/タスク： \n"\(select_1)"*/
            navbar_t.items![0].title = dataList[row]
            performSegue(withIdentifier: "goNext", sender: nil)
        }
        
        if delete_button == true {
            
            select_1 = dataList[row]
            test_alert(select_1)
            
            self.memberVariable = row
        }
    }
    
    var memberVariable: Int = 0
    
    func test_alert(_ sender: String?) {
        
//        print(select_1)
        
        let alert: UIAlertController = UIAlertController(title: select_1, message: "削除してもいいですか？", preferredStyle:  UIAlertController.Style.alert)

                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
//                print("OK")
                print(self.memberVariable)
                print(self.dataList[self.memberVariable])
//                self.dataList = self.userDefaults.array(forKey: "FirstArray") as! [String]
                
                self.dataList.remove(at: self.memberVariable)
//                self.dataList = self.userDefaults.array(forKey: "FirstArray") as! [String]
                self.selectPicker.reloadAllComponents()
//                self.selectPicker.delegate = self
//                self.selectPicker.dataSource = self
                print(self.dataList)
                self.userDefaults.set(self.dataList, forKey: "FirstArray")
                
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
//                print("Cancel")
            })

            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)

            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
    }
    
//    func Printfunc() {
//        print("Hello")
//    }
}

