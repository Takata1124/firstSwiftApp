//
//  CategoryTableViewCell.swift
//  TodoListApp
//
//  Created by t032fj on 2021/10/30.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var category: Category? {
        didSet {
            
            if let category = category {
                categoryLabel.text = category.categorytitle
//                dateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        autoresizingMask = .flexibleWidth
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
