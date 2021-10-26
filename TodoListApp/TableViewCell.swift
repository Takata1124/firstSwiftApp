//
//  TableViewCell.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var user: User? {
        didSet{
            if let user = user {
                cellText.text = user.username
                dateLabel.text = dateFormatterForDateLabel(date: user.createdAt.dateValue())
                latestLabel.text = user.email
            }
            
        }
    }
    
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var cellText: UITextView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
    
    private var checked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        checkButton.backgroundColor = .black
        checkButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        cellText.isEditable = false
        cellText.isSelectable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
    
    @objc private func didTapButton(){
        switch checked {
        case false:
            checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checked = true
            print("true")
        case true:
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checked = false
            print("false")
        }
    }
    
}
