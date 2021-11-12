//
//  TableViewCell.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit
import Nuke

//var Btext: String?

protocol TableViewCellDelegate: class {
    
//    func tappedSendButton(text: String)
    func tappedButton(text: Any)
}

class TableViewCell: UITableViewCell {
    
    var message: Message? {
        
        didSet {
            
            if let message = message {
                
                cellText.text = message.message
                dateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
                
                let checkClick = message.click
                
                if checkClick == true {
                
    //                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    print("check")
                    
                    backgroundColor = .lightGray
                    
    //                    let atr =  NSMutableAttributedString(string: cellText.text!)
    //                    atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atr.length))
    //                    self.cellText.attributedText = atr
                    
    //                    viewcell.accessoryType = .none
                } else {
                    
    //                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    print("circle")
    //                    cellText.text = dolist.dolisttitle
                    
                    backgroundColor = .clear
                    
    //                    viewcell.accessoryType = .checkmark
                }
       
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
                    
                    backgroundColor = .lightGray
                    
//                    let atr =  NSMutableAttributedString(string: cellText.text!)
//                    atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atr.length))
//                    self.cellText.attributedText = atr
                    
//                    viewcell.accessoryType = .none
                } else {
                    
//                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    print("circle")
//                    cellText.text = dolist.dolisttitle
                    
                    backgroundColor = .clear
                    
//                    viewcell.accessoryType = .checkmark
                }
            }
        }
    }
    
    var click: Bool? {
        
        didSet {
            print("didSet")
            
            if let click = click {
                
//                cellText.text = dolist.dolisttitle
//                dateLabel.text = dateFormatterForDateLabel(date: dolist.createdAt.dateValue())
                
                let checkClick = click
                
                if checkClick == true {
                
//                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    print("check")
                    
                    backgroundColor = .lightGray
                    
//                    let atr =  NSMutableAttributedString(string: cellText.text!)
//                    atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atr.length))
//                    self.cellText.attributedText = atr
                    
//                    viewcell.accessoryType = .none
                } else {
                    
//                    let viewcell = TableViewCell()
                    checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                    print("circle")
//                    cellText.text = dolist.dolisttitle
                    
                    backgroundColor = .clear
                    
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
    @IBOutlet weak var alertButton: UIButton!
    
//    var click: Bool = false
    
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
        
        dateLabel.isHidden = true
//
//        Btext = cellText.text
        
//        if click == true {
//        
////                    let viewcell = TableViewCell()
//            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
//            print("check")
//            
//            backgroundColor = .lightGray
//            
////                    let atr =  NSMutableAttributedString(string: cellText.text!)
////                    atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atr.length))
////                    self.cellText.attributedText = atr
//            
////                    viewcell.accessoryType = .none
//        } else {
//            
////                    let viewcell = TableViewCell()
//            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
//            print("circle")
////                    cellText.text = dolist.dolisttitle
//            
//            backgroundColor = .clear
//            
////                    viewcell.accessoryType = .checkmark
//        }
        
        
        
//        checkButton.layer.cornerRadius = 22
//        alertButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
        backgroundColor = .clear
        
//        checked = false
    }
    
    weak var delegate: TableViewCellDelegate?
    
    @IBAction func tappedButton(_ sender: Any) {
        
        
        print((sender as AnyObject).tag as Any)
        
        let tag = (sender as AnyObject).tag as Any
//        guard tag != nil else { return }
        
        delegate?.tappedButton(text: tag)
//        let storyboard = UIStoryboard(name: "chatRoomStory", bundle: nil)
//        let chatroomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomStoryViewController") as!ChatRoomStoryViewController
//        chatroomViewController.buttonTag = tag as! Int
//        print("tapped")
    }
    
    

//    @objc func tappedButton() {
//
//        print("tapbutton")
//
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
