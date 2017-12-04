//
//  PropertyViewTableViewCell.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import MapKit

class PropertyViewTableViewCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var profitLoss: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var revenueLabel: UILabel!
    
    @IBOutlet weak var expenseLabel: UILabel!
}
