//
//  OutcomingTableViewCell.swift
//  TestChat
//
//  Created by Valeria Muldt on 14.07.2020.
//  Copyright © 2020 Valeria Muldt. All rights reserved.
//

import UIKit

class OutcomingTableViewCell: UITableViewCell {
    @IBOutlet weak var bubbleView: UIView! {
        didSet {
            bubbleView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
