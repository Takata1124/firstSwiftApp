//
//  sideMenuViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/11.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SideMenu

class MenuListController: UITableViewController {
    
    var dolistviewController: DoListViewController?
    var items = ["Logout", "", "Category", "Task", "Detail", "Setting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tableView.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryLabel.text = items[indexPath.row]
        cell.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
        cell.categoryLabel.tintColor = UIColor.red
        
//        if indexPath.row == 3 {
//            
//            cell.categoryLabel.textColor = .white
//            print(indexPath)
//            print("white")
////        } else {
////            
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print(items[indexPath.row])
        
        if (items[indexPath.row] == "Logout") {
            //            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
        
        if (items[indexPath.row] == "Task") {
            print("実行")
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        
        if (items[indexPath.row] == "Category") {
            print("実行")
//            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        }
        
    }
}

