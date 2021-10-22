//
//  SettingViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {

    @IBOutlet weak var newText: UITextField!
//    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var navbar: UINavigationBar!
    
    let viewclass = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbar?.delegate = self
        newText.delegate = viewclass            
//        viewclass.Printfunc()
        // Do any additional setup after loading the view.
        
        navbar.items![0].title = "Setting"
        navbar.barTintColor = .rgb(red: 200, green: 200, blue: 200)
        navbar.isTranslucent = true
        navbar.titleTextAttributes = [
            // 文字の色
                .foregroundColor: UIColor.black
            ]
    }
    
    @IBAction func backbutton(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
