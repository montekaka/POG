//
//  Receipt.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation
import Firebase

class Payment {
    // must fill
    var date: Date?
    var amount: Double?
    var property_id: Int?
    var uid: String?
    
    // optional
    var frequency: frequencyData?
    
    var isAnnualized: Bool?
    var category: categoryData?
    var endDate: Date?
    var ref: DatabaseReference?
    
    // list of avaiable values
    //private var data = [Receiptdata]()
    
    init?( amount: Double){
        // self.date = date
        self.amount = amount
    }
    
    func toAnyObject() -> Any {
        return [
            "paidAmount": self.amount!,
            "paidDate": self.date!.timeIntervalSince1970, // get date = NSDate(timeIntervalSince1970: paidDate)
            "paymentFrequencyCode": self.frequency!.code!
        ]
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
