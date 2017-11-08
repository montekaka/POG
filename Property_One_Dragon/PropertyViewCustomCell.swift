//
//  PropertyViewCustomCell.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/7/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import MapKit

class PropertyViewCustomCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var propertyMapView: MKMapView?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
