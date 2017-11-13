//
//  Receipt.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation

class Receipt {
    // must fill
    var date: Date?
    var amount: Double?
    var property_id: Int?
    
    // optional
    var isRecurrent : boolean_t?
    var frequency: String?
    var isAnnualized: boolean_t?
    var category: String?
    
    init?( amount: Double){
        // self.date = date
        self.amount = amount
    }
}
