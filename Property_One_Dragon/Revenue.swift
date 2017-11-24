//
//  Revenue.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/24/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation

class Revenue {
    // must fill
    var date: Date?
    var amount: Double?
    var property_id: Int?
    // optional
    var frequency: frequencyData?
    var isAnnualized: Bool?
    var category: categoryData? // lease vs airbnb
    var endDate: Date?
    
    init?( amount: Double){
        // self.date = date
        self.amount = amount
    }
    
    func get() -> [paymentData] {
        var data = [paymentData]()
        
        // date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // currency formatter
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        
        if ((self.date) != nil ) {
            let paidDateString = dateFormatter.string(from: self.date!)
            
            data.append(paymentData(label: "Date", value: self.date, format: paidDateString))
        }
        if ((self.amount) != nil ) {
            let amountStr = currencyFormatter.string(from: self.amount! as NSNumber)
            data.append(paymentData(label: "amount", value: self.amount, format: amountStr))
        }
        if ((self.frequency) != nil ) {
            
            data.append(paymentData(label: "Frequency", value: self.frequency, format: self.frequency?.label))
        }
        if ((self.isAnnualized) != nil ) {
            
            var isAnnualizedStr = "No"
            if(self.isAnnualized == true){
                isAnnualizedStr = "Yes"
            }
            
            data.append(paymentData(label: "Annualized the payment", value: self.isAnnualized, format: isAnnualizedStr))
        }
        if ((self.category) != nil ) {
            data.append(paymentData(label: "category", value: self.category, format: self.category?.label))
        }
        return data
    }
}
