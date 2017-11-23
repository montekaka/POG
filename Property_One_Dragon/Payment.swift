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

struct categoryData {
    let label: String!
    let value: Float32!
}

struct paymentData {
    let label: String!
    let value: Any!
}

class Payment {
    // must fill
    var date: Date?
    var amount: Double?
    var property_id: Int?
    
    // optional
    var frequency: frequencyData?
    var isAnnualized: Bool?
    var category: categoryData?
    var endDate: Date?
    
    // list of avaiable values
    //private var data = [Receiptdata]()
    
    init?( amount: Double){
        // self.date = date
        self.amount = amount
    }
    
    func get() -> [paymentData] {
        var data = [paymentData]()
        
        if ((self.date) != nil ) {
            data.append(paymentData(label: "Date", value: self.date))
        }
        if ((self.amount) != nil ) {
            data.append(paymentData(label: "amount", value: self.amount))
        }
        if ((self.frequency) != nil ) {
            data.append(paymentData(label: "Frequency", value: self.frequency))
        }
        if ((self.isAnnualized) != nil ) {
            data.append(paymentData(label: "isAnnualized", value: self.isAnnualized))
        }
        if ((self.category) != nil ) {
            data.append(paymentData(label: "category", value: self.category))
        }
        return data
    }
}
