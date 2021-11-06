//
//  CalenderViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/06.
//

import UIKit
import FSCalendar



class CalenderViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var selectPicker: UIPickerView!
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //    var dataList : [String] = ["apple", "banana","chocolate","chocolate","chocolate"]
    let dataList = [["00","01","02","03"],
                    ["00","05","10","15",]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calender.delegate = self
        calender.dataSource = self
        
        selectPicker.delegate = self
        selectPicker.dataSource = self
        selectPicker.isHidden = true
        
        saveButton.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    var year: Int?
    var month: Int?
    var day: Int?
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let tmpDate = Calendar(identifier: .gregorian)
        year = tmpDate.component(.year, from: date)
        month = tmpDate.component(.month, from: date)
        day = tmpDate.component(.day, from: date)
//        labelDate.text = "\(year)/\(month)/\(day)"
//        print(labelDate.text)
        
        selectPicker.isHidden = false
        
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

        pickerLabel.text = "\(year)/\(month)/\(day)  \(data1!):\(data2!)"
        saveButton.isEnabled = true
    }
}



