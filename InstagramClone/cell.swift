//
//  cell.swift
//  InstagramClone
//
//  Created by Maria on 6/16/17.
//  Copyright © 2017 Maria Notohusodo. All rights reserved.
//

import UIKit

class cell: UITableViewCell {
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var username: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
