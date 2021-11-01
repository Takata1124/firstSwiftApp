//
//  DoListViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/11/01.
//

import UIKit
import SideMenu
import Firebase
import FirebaseAuth

class DoListViewController: UIViewController, UINavigationBarDelegate {


    @IBOutlet weak var navbar_t: UINavigationBar!
    
    var user: User?
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navbar_t.items![0].title = ""
        navbar_t?.delegate = self
        navbar_t.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
//        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        present(menu!, animated: true)
    }
    
}

class MenuListController: UITableViewController {
    
    var items = ["Logout", "Category", "Task", "Do", "Setting"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("tapped")
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
        } else {
            print("ログアウトに失敗しました")
        }
    }
}

//@IBAction func tappedLogout(_ sender: Any) {
//    do {
//        try Auth.auth().signOut()
//        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//        signUpViewController.modalPresentationStyle = .fullScreen
//        self.present(signUpViewController, animated: true, completion: nil)
//    } catch {
//        print("ログアウトに失敗しました")
//    }
//}
