//
//  TenantsTableViewCell.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit

class TenantsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
