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
    
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var cellText: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
    
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
        
        backgroundColor = .clear
    }

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
//        switch checked {
//        case false:
//            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
//            checked = true
//            print("true")
//        case true:
//            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
//            checked = false
//            print("false")
//        }
//    }
}
