//
//  CustomMessageCell.swift
//  Prototipo
//
//  Created by André Vicente Pessanha on 02/03/2018.
//  Copyright © 2018 André Vicente Pessanha. All rights reserved.
//

import UIKit

class CustomMessageCell : UITableViewCell {
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var senderName: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
