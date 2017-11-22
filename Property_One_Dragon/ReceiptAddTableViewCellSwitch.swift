//
//  ReceiptAddTableViewCellSwitch.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/14/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class ReceiptAddTableViewCellSwitch: UITableViewCell {

    @IBOutlet weak var switchTextLabel: UILabel!
    var switchValue: Bool?
    
  
    @IBAction func switchChanged(_ sender: UISwitch) {
        if (sender.isOn == true) {
            switchValue = true
        } else {
            switchValue = false
        }
    }
}
