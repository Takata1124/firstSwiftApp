//
//  ViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/16.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationBarDelegate {
    
    var dataList : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]
//    var categoryList : [String] = ["apple", "banana","chocolate"]
    var searchkey : String?
    var selectkey : String?

//    @IBOutlet weak var selectButton: UIButton!
//    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var selectPicker: UIPickerView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var navbar_t: UINavigationBar!
    
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
        selectPicker.delegate = self
        selectPicker.dataSource = self
//        selectPicker.center = self.view.center
        
//        selectPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
//        selectPicker.selectRow(0, inComponent: 0, animated: false)
//        selectPicker.selectRow(1, inComponent: 1, animated: false)
        
        selectLabel.text = "カテゴリー/タスク： "
//        selectLabel.layer.borderColor = UIColor.lightGray.cgColor
//        selectLabel.layer.borderWidth = 1.0
        
        self.title = "ToDoList"
        
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar_t.isTranslucent = true
        navbar_t.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
        
//        self.navigationItem.title = "Todo"
//        self.navigationController?.navigationBar.backgroundColor = UIColor.purple
    }
    
    @IBAction func deleteButtonfunc(_ sender: Any) {
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
            taskVC.textVC = selectkey
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if var searchkey = textField.text {
            dataList.append(searchkey)
        }
//        print(dataList)
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
        
//        selectkey = dataList[row]
        select_1 = dataList[row]
        print(select_1)
//        selectButton.isEnabled = true
        
        guard let select_11 = select_1 else {return}
        selectLabel.text = select_11 /*"カテゴリー/タスク： \n"\(select_1)"*/
        performSegue(withIdentifier: "goNext", sender: nil)
    }
    
//    func Printfunc() {
//        print("Hello")
//    }
}

