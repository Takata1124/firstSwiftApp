//
//  UserListViewController.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Nuke

class UserListViewController: UIViewController {
    
    private let cellid = "cellid"
    private var users = [User]()
    private var selectedUser: User?

    @IBOutlet weak var userListTable: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userListTable.delegate = self
        userListTable.dataSource = self
        
        startButton.isEnabled = false
        startButton.addTarget(self, action: #selector(tappedstartButton), for: .touchUpInside)
        
        fetchUserInfoFromFirestore()
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
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

    @IBAction func tappedCloseButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedstartButton() {
        print("tapbutton")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let partnerUid = self.selectedUser?.uid else { return }
        let members = [uid, partnerUid]
        
        let docData = [
            "members": members,
            "latestMessageId": "",
            "createdAt": Timestamp()
        ] as [String: Any]
        
        Firestore.firestore().collection("chatRooms").addDocument(data: docData) { (err) in
            if let err = err {
                print("データベースへの保存に失敗しました(\(err)")
                return
            }
            
            print("FireStoreへの情報の保存が成功しました")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func fetchUserInfoFromFirestore() {
        
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("user情報の取得に失敗しました\(err)")
                return
            }
            
//            print(snapshots)
            print("user情報の取得に成功しました")
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                user.uid = snapshot.documentID
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                //loginUserでなければ
                if uid == snapshot.documentID {
                    return
                }
                
                self.users.append(user)
                self.userListTable.reloadData()
            })
        }
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userListTable.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! UserListTableCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startButton.isEnabled = true
        let user = users[indexPath.row]
        self.selectedUser = user
        
        guard let selectusername = selectedUser?.username else { return }
        
        print(selectusername)
        
    }
}

class UserListTableCell: UITableViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            if let url = URL(string: user?.profileImageUrl ?? "") {
                Nuke.loadImage(with: url, into: userImageView)
            }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
