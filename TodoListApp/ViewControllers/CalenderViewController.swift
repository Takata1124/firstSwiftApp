//
//  CalenderViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/06.
//

import UIKit
import FSCalendar
import Firebase
import FirebaseAuth


class CalenderViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var selectPicker: UIPickerView!
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //    var dataList : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]
    let dataList = [["00","01","02","03","04","05","06","07","08","09",
                     "10","11","12","13","14","15","16","17","18","19",
                     "20","21","22","23"],
                    ["00","05","10","15","20","25","30","35","40","45","50","55"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calender.delegate = self
        calender.dataSource = self
        
        selectPicker.delegate = self
        selectPicker.dataSource = self
        selectPicker.isHidden = true
        
        saveButton.isEnabled = false
        
        guard let task = task else { return }
        guard let catego = catego else { return }
        
        titleLabel.text = "\(catego) : \(task)"
        
        // Do any additional setup after loading the view.
    }
    
    var taskTitle: String? {
        
        didSet {
//            print("didSet")
//
            if let taskTitle = taskTitle {
                
                print("task",taskTitle)
                print(type(of: taskTitle))
                task = taskTitle
            }
            
        }
    }
    
    var categoTitle: String? {
        
        didSet {
//            print("didSet")
//
                if let categoTitle = categoTitle {
//                    print("task",taskTitle)
//                    print(type(of: taskTitle))
                    catego = categoTitle
                }
                
        }
    }
    
    
    var year: Int?
    var month: Int?
    var day: Int?
    
    var task: String?
    var catego: String?
    
//    var taskTitile: String?
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let tmpDate = Calendar(identifier: .gregorian)
        year = tmpDate.component(.year, from: date)
        month = tmpDate.component(.month, from: date)
        day = tmpDate.component(.day, from: date)
//        labelDate.text = "\(year)/\(month)/\(day)"
//        print(labelDate.text)
        
        selectPicker.isHidden = false
        
//        print("task",taskTitile ?? "")
        
        
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        return dataList[component].count
    }
    
    // UIPickerViewの最初の表示d
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let data1 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
        let data2 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)
//        let data3 = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)
        
        guard let year = year else {
            return
        }
        
        guard let month = month else {
            return
        }
        
        guard let day = day else {
            return
        }
        
        date_Label = "\(year)/\(month)/\(day)/\(data1!):\(data2!)"

        pickerLabel.text = date_Label
        saveButton.isEnabled = true
    }
    
    var date_Label: String?
    
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
//        self.dismiss(animated: true, completion: nil)
//        print("tappeded")
        
//        let storyboard = UIStoryboard.init(name: "chatRoomStory", bundle: nil)
//        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as! ChatRoomStoryViewController
////        chatRoomViewController.user = user
////        chatRoomViewController.category = categories[indexPath.row]
////        chatRoomViewController.indexpath = indexPath
//        chatRoomViewController.modalPresentationStyle = .fullScreen
//        self.present(chatRoomViewController, animated: true, completion: nil)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
    //    guard let partnerUid = self.selectedUser?.uid else { return }
    //    let members = [uid, partnerUid]
        
        let docData = [
            "uid": uid,
            "categorytitle": catego ?? "",
            "newText": task ?? "",
            "createdAt": date_Label ?? ""
        ] as [String: Any]
        
        Firestore.firestore().collection("users").document(uid).collection("newMessage").addDocument(data: docData) { (err) in
            if let err = err {
                print("カテゴリーの保存に失敗しました(\(err)")
                return
            }
            
            print("カテゴリーの保存が成功しました")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
