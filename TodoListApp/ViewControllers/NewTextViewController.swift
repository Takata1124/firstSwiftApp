//
//  NewTextViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/13.
//

import UIKit

import Firebase
import FirebaseAuth

class NewTextViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var changeButton: UIButton!
    
    @IBOutlet weak var newTextTable: UITableView!
    @IBOutlet weak var navbar_t: UINavigationBar!
    
    private var newTexts = [NewText]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        getFirebaseDoc()
    }
    
    private func setUpViews() {
        
        returnButton.layer.cornerRadius = 25
        
        newTextTable.delegate = self
        newTextTable.dataSource = self
        newTextTable.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        newTextTable.separatorColor = .black
        
        plusButton.isHidden = true
        
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar_t.items![0].title = "New"
        
        changeButton.setTitle("Edit", for: .normal)
        newTextTable.isEditing = false
        
        
    }
    
    private func getFirebaseDoc() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        Firestore.firestore().collection("users").document(uid).collection("newMessage").order(by: "DateAt", descending: true).getDocuments { (documents, err) in
            if let err = err {
                print("err")
            }
            
            documents?.documents.forEach({ (document) in
                
                let dic = document.data()
                let newtext = NewText(dic: dic)
                newtext.NewtextId = document.documentID
                
                self.newTexts.append(newtext)
                self.newTextTable.reloadData()
                
            })
        }
    }
    
    @IBAction func changemode(_ sender: Any) {
        
        if (newTextTable.isEditing == true) {
            newTextTable.isEditing = false
            //            chatRoomTable.allowsSelectionDuringEditing = false
//            addButton.isEnabled = true
            returnButton.isEnabled = true
            changeButton.setTitle("Edit", for: .normal)
            
        } else {
            newTextTable.isEditing = true
            //            chatRoomTable.allowsSelectionDuringEditing = true
//            addButton.isEnabled = false
            returnButton.isEnabled = false
            changeButton.setTitle("Editing", for: .normal)
        }
    }
    
    @IBAction func returnAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        newTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        cell.categoLabel.text = "<\(newTexts[indexPath.row].categorytitle)>"
        
        let date = newTexts[indexPath.row].DateAt
        let time = newTexts[indexPath.row].TimeAt
        
        cell.timeLabel.text = "\(date) \(time)"
        cell.categoryLabel.text = newTexts[indexPath.row].newText
        
        cell.separatorInset = .zero

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //
            guard let newId = newTexts[indexPath.row].NewtextId else { return }
            
//            guard let categoDocId = category?.categoryId else { return  }
            guard let uid = Auth.auth().currentUser?.uid else  { return }
            
            Firestore.firestore().collection("users").document(uid).collection("newMessage").document(newId).delete()
            
            newTexts.remove(at: indexPath.row)
            newTextTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if newTextTable.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
