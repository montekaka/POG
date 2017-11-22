//
//  Receipt.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation

struct frequencyData {
    let label: String!
    let value: Float32!
}

class Receipt {
    // must fill
    var date: Date?
    var amount: Double?
    var property_id: Int?
    
    // optional
    var frequency: frequencyData?
    var isAnnualized: Bool?
    var category: String?
    var endDate: Date?
    
    init?( amount: Double){
        // self.date = date
        self.amount = amount
    }
}
