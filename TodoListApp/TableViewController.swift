//
//  TableViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/24.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var todoList = [TodoData]()
    
    @IBOutlet weak var tabletable: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        let alertController = UIAlertController(title: "todoを追加", message: "todoを入力してください", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                let todoData = TodoData()
                todoData.todoTitle = textField.text!
                self.todoList.insert(todoData, at: 0)

//                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)

                let userDefaults = UserDefaults.standard
                do {
                    let archivedData: Data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: false)
                    userDefaults.set(archivedData, forKey: "todoList")
                    print("完了")
                    print(self.todoList)
                    self.tabletable?.reloadData()
//                    userDefaults.synchronize()
                } catch {
//                    print(error)
                    print("era-")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabletable.delegate = self
        tabletable.dataSource = self
        tabletable.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "todoCell")

        if let storedData = UserDefaults().data(forKey: "todoList") {
             do {
                 let unarchivedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData)
                 todoList.append(contentsOf: unarchivedData as! [TodoData])
             } catch {
                 print(error)
             }
         }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        let todoData = todoList[indexPath.row]

        cell.todocellText.text = todoData.todoTitle
        
        if todoData.todoDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            let userDefalults = UserDefaults.standard
            do {
                let data: Data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: false)
                userDefalults.set(data, forKey: "todoList")
//                userDefalults.synchronize()
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoData = todoList[indexPath.row]
        if todoData.todoDone {
            todoData.todoDone = false
        } else {
            todoData.todoDone = true
        }
        tableView.reloadRows(at: [indexPath], with: .fade)

        let userDefaults = UserDefaults.standard
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: false)
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        } catch {
            print(error)
        }
    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
//        cell.cellText.text = TODO[indexPath.row]
//        return cell
//    }
}

//extension TableViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return TODO.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
//        cell.cellText.text = TODO[indexPath.row]
//        return cell
//    }
//}


    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
