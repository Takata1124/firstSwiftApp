//
//  TaskViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/17.
//

import UIKit

class TaskViewController: UIViewController, UITextViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var navbar_task: UINavigationBar!
    
    @IBAction func inputTextButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)

    }
    
    var textVC: String?
    var TODO: [String?] = ["牛乳を買う", "掃除をする", "アプリ開発の勉強をする"]
    let viewclass = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageText.layer.borderColor = UIColor.black.cgColor
        messageText.layer.borderWidth = 1.0
        messageText.layer.cornerRadius = 20
        messageText.delegate = self
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        navbar_task?.delegate = viewclass
        
        navbar_task?.items![0].title = "Plan"
        navbar_task?.barTintColor = .rgb(red: 200, green: 200, blue: 200)
//        navbar_task?.isTranslucent = true
        navbar_task?.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
        
//        guard let untext = textVC else { return }
        
//        title = "\(untext)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    func position(for bar: UIBarPositioning) -> UIBarPosition {
//        return .topAttached
//    }
//
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            TODO.append(textView.text)
            messageTable?.reloadData()
            textView.resignFirstResponder()
            textView.text = ""
            return false
        }
        return true
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = UIScreen.main.bounds.height - keyboardFrame.cgRectValue.minY - 100
        messageText.transform = CGAffineTransform(translationX: 0, y: min(0, -keyboardHeight))
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = UIScreen.main.bounds.height - keyboardFrame.cgRectValue.minY
        messageText.transform = CGAffineTransform(translationX: 0, y: min(0, +keyboardHeight))
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TODO.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        cell.cellText.text = TODO[indexPath.row]
        return cell
    }
}
