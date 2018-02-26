//
//  LeaseAgreementTableViewCell.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/25/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit

class LeaseAgreementTableViewCell: UITableViewCell {

    @IBOutlet weak var fromDateLabel: UILabel!
    @IBOutlet weak var rentAmountLabel: UILabel!
        
    @IBOutlet weak var tenantsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
