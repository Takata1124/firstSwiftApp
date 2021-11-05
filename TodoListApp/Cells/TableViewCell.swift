//
//  TableViewCell.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit
import Nuke

class TableViewCell: UITableViewCell {
    
    var message: Message? {
        
        didSet {
            
            if let message = message {
                cellText.text = message.message
                dateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
                
            }
        }
    }
    
    var chatroom: ChatRoom? {
        
        didSet {
            if let chatroom = chatroom {
                cellText.text = chatroom.partnerUser?.username
                
                guard let url = URL(string: chatroom.partnerUser?.profileImageUrl ?? "") else { return }
                Nuke.loadImage(with: url, into: IconImage)
                
                dateLabel.text = dateFormatterForDateLabel(date: chatroom.createdAt.dateValue())
            }
//            cellText.text = chatroom
        }
    }
    
    var dolist: DoList? {
        
        didSet {
            
            if let dolist = dolist {
                cellText.text = dolist.dolisttitle
                dateLabel.text = dateFormatterForDateLabel(date: dolist.createdAt.dateValue())
                
                let checkClick = dolist.click
                
                if checkClick == true {
                
//                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    print("check")
//                    viewcell.accessoryType = .none
                } else {
                    
//                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    print("circle")
//                    viewcell.accessoryType = .checkmark
                }
            }
        }
    }
    
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var cellText: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
//    @IBOutlet weak var viewview: UIView!
    
    var checked: Bool?
    
//    private var checked = false

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
//        checkButton.backgroundColor = .black
//        checkButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        cellText.isEditable = false
        cellText.isSelectable = false
        cellText.backgroundColor = .clear
        
//        checkButton.layer.cornerRadius = 22
//        checkButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        backgroundColor = .clear
        
//        checked = false
    }

//    @objc func tappedButton() {
//
//        print("tapbutton")
//
//        if checkClick == false {
//
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
//    @objc private func didTapButton(){
//
//        switch checked {
//        case false:
//            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
//            checked = true
//            print("true")
//        case true:
//            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
//            checked = false
//            print("false")
//
//        case .none:
//            print("nothing")
//        case .some(_):
//            print("nothing")
//        }
//    }
}
