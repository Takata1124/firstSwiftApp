//
//  TableViewCell.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/18.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var cellText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
