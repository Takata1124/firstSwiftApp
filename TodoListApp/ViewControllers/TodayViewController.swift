//
//  TodayViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseAuth

class TodayViewController: UIViewController {
    
    @IBOutlet weak var navbar_t: UINavigationBar!
    @IBOutlet weak var todayTable: UITableView!
    
    @IBOutlet weak var returnButton: UIButton!
    
    
    var dateTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUpView()
        FirebaseSelection()

        // Do any additional setup after loading the view.
    }
    
    private func SetUpView() {
        
        navbar_t.items![0].title = dateTitle
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        
        todayTable.delegate = self
        todayTable.dataSource = self
        todayTable.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        todayTable.separatorColor = .black
        
        returnButton.layer.cornerRadius = 25
    }
    
    @IBAction func returnButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var newTexts = [NewText]()
    
    func FirebaseSelection() {
        
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        
        guard let dateTitle = dateTitle else {
            return
        }
        
        Firestore.firestore().collection("users").document(uid).collection("newMessage").whereField("DateAt", isEqualTo: dateTitle).getDocuments { (documents, err) in
            if let err = err {
                print("err")
            }
            
            documents?.documents.forEach({ (document) in
                
                let dic = document.data()
                let newtext = NewText(dic: dic)
                newtext.NewtextId = document.documentID
                
                self.newTexts.append(newtext)
                print(self.newTexts[0].newText)
                
                self.todayTable.reloadData()
            })
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
}
