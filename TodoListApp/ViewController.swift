//
//  ViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/16.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataList : [String] = ["apple", "banana","chocolate"]
    var categoryList : [String] = ["apple", "banana","chocolate"]
    var searchkey : String?
    var selectkey : String?

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var navibar: UINavigationItem!
    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var selectPicker: UIPickerView!
    @IBOutlet weak var selectLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        selectButton.layer.cornerRadius = 100
        selectButton.layer.borderColor = UIColor.lightGray.cgColor
        selectButton.layer.borderWidth = 1.0
        selectButton.isEnabled = false
        
        newText.layer.borderColor = UIColor.lightGray.cgColor
        newText.layer.borderWidth = 1.0
        newText.delegate = self
//        newText.layer.cornerRadius = 20
        
//        selectPicker.layer.borderColor = UIColor.black.cgColor
//        selectPicker.layer.borderWidth = 1.0
        selectPicker.delegate = self
        selectPicker.dataSource = self
        
//        selectPicker.selectRow(<#T##row: Int##Int#>, inComponent: <#T##Int#>, animated: <#T##Bool#>)
        selectPicker.selectRow(0, inComponent: 0, animated: false)
        selectPicker.selectRow(1, inComponent: 1, animated: false)
        
        selectLabel.text = "カテゴリー/タスク： "
        selectLabel.layer.borderColor = UIColor.lightGray.cgColor
        selectLabel.layer.borderWidth = 1.0
        
        title = "ToDoList"
    }
    
    @IBAction func deleteButtonfunc(_ sender: Any) {
    }
    
    @IBAction func selectfunc(_ sender: Any) {
        
        performSegue(withIdentifier: "goNext", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goNext") {
            let taskVC = segue.destination as! TaskViewController
            taskVC.textVC = selectkey
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if var searchkey = textField.text {
            
            dataList.append(searchkey)
        }
        selectPicker.reloadAllComponents()
        textField.text = ""
        return true
    }
    
// UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return categoryList.count
        case 1:
            return dataList.count
        default:
            return 0
        }
    }
    
    // UIPickerViewの最初の表示d
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch component {
        case 0:
            return categoryList[row]
        case 1:
            return dataList[row]
        default:
            return "error"
        }
    }
    
    var select_0: String?
    var select_1: String?
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch component {
        case 0:
            selectkey = categoryList[row]
            select_0 = categoryList[row]
            selectButton.isEnabled = true
        case 1:
            selectkey = dataList[row]
            select_1 = dataList[row]
            selectButton.isEnabled = true
        default:
            break
        }
        
        guard let select_00 = select_0 else {return}
        guard let select_11 = select_1 else {return}
        selectLabel.text = "カテゴリー/タスク： \n\(select_00)/\(select_11)"
    }
}

