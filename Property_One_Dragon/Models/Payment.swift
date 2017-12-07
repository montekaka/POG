//
//  Receipt.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation
import Firebase
// TO-DO
// 1. Make sure pay date is less than end date
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
    
    
    init?(snapshot: DataSnapshot, paymentType: String) {
        let dbReference = Database.database().reference()
        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
        // set values
        
        self.amount = snapshotValue!["paidAmount"] as? Double
        self.date = NSDate(timeIntervalSince1970: snapshotValue!["paidDate"] as! TimeInterval) as Date?
        
        if((snapshotValue!["paymentEndDate"]) != nil) {
            self.endDate = NSDate(timeIntervalSince1970: snapshotValue!["paymentEndDate"] as! TimeInterval) as Date?
        }
        
        if((snapshotValue!["paymentCategoryCode"]) != nil) {
            let paymentCategoryCode = snapshotValue!["paymentCategoryCode"]
            var paymentCategory = "expenseCategory"
            if( paymentType == "Incomes"){
                paymentCategory = "incomeCategory"
            }
             dbReference.child(paymentCategory).child(paymentCategoryCode as! String).observe(.value, with: { (categorySnapshot) in
                let snapValue = categorySnapshot.value as? NSDictionary
                let label = snapValue!["label"] as? String ?? ""
                let code = snapValue!["code"] as? String ?? ""
                let value = snapValue!["value"] as? Float32
                
                self.category = categoryData(label: label, code: code, value: value)
            })
        }
        
        if((snapshotValue!["paymentFrequencyCode"]) != nil) {
            let paymentCategoryCode = snapshotValue!["paymentFrequencyCode"]
            
            dbReference.child("paymentFrequency").child(paymentCategoryCode as! String).observe(.value, with: { (categorySnapshot) in
                let snapValue = categorySnapshot.value as? NSDictionary
                let label = snapValue!["label"] as? String ?? ""
                let code = snapValue!["code"] as? String ?? ""
                let value = snapValue!["value"] as? Float32
                
                self.frequency = frequencyData(label: label, code: code, value: value)
            })
        }
    
        
        if((snapshotValue!["annualizedPayment"]) != nil) {
            self.isAnnualized = snapshotValue!["annualizedPayment"] as? Bool
        }
        
        self.ref = snapshot.ref
        
    }
    
    
    func toAnyObject() -> Any {
        var annualizedPayment = false

        if(self.isAnnualized == true){
            annualizedPayment = true
        }
        print(self.endDate!.timeIntervalSince1970);
        
        return [
            "paidAmount": self.amount!,
            "paidDate": self.date!.timeIntervalSince1970, // get date = NSDate(timeIntervalSince1970: paidDate)
            "paymentFrequencyCode": self.frequency!.code!,
            "paymentCategoryCode": self.category!.code!,
            "paymentEndDate": self.endDate!.timeIntervalSince1970,
            "annualizedPayment": annualizedPayment
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
