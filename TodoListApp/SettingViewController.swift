//
//  SettingViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newText: UITextField!
    
    let viewclass = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newText.delegate = viewclass
        viewclass.Printfunc()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbutton(_ sender: Any) {

        navigationController?.popViewController(animated: true)

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
