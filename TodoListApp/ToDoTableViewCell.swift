//
//  ToDoTableViewCell.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/24.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

//    @IBOutlet weak var todocellText: UILabel!
    @IBOutlet weak var todocellText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
