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
    @IBOutlet weak var checkButton: UIButton!
    
    private var checked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        checkButton.backgroundColor = .black
        checkButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
