//
//  Receipt.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation
import Firebase

enum PaymentValidationError : Error {
    case InvalidPayAmount
    case InvalidPaidDate
    case InvalidPaymentCategory
    case InvalidPaymentFrequence
}

// TODO
// 1. Make sure pay date is less than end date
class Payment {
    // must fill
    private var date: Date?
    private var amount: Double?
    var property_id: Int?
    var uid: String?
    
    // optional
    private var frequency: frequencyData?
    private var category: categoryData?
    var categoryCode: String?
    
    var isAnnualized: Bool?
    var endDate: Date?
    var ref: DatabaseReference?
    
    // list of avaiable values
    //private var data = [Receiptdata]()
    
    init?( amount: Double){
        // self.date = date
        //self.amount = amount
        do {
            try setPaidAmount(amount: amount)
        } catch {
            return nil
        }
    }
    
    // list of set methods
    func setPaidAmount(amount: Double) throws {
        if(amount <= 0){
            throw PaymentValidationError.InvalidPayAmount
        }
        self.amount = Double(amount)
    }
    
    func setPaidDate(paid_date: Date) throws {
        let date_diff = self.dateDiff(date_x: paid_date, date_y: self.endDate!)
        if(date_diff > 0) {
            throw PaymentValidationError.InvalidPaidDate
        }
        self.date = paid_date
    }

    func setPaymentCategory(category_item: categoryData?) throws {

        if(category_item == nil){
            throw PaymentValidationError.InvalidPaymentCategory
        }
        self.category = category_item
    }
    
    func setPaymentFrequency(freq: frequencyData?) throws {
        if(freq == nil){
            throw PaymentValidationError.InvalidPaymentFrequence
        }
        self.frequency = freq
    }
    
    // end list of set methods
    
    // list of get methods
    func getPaidAmountText() -> String{
        return String(format:"%.2f", (self.amount ?? 0))
    }
    
    func getPaidDate() -> Date {
        return self.date!
    }
    
    func getPaymentFrquence() -> frequencyData? {
        return self.frequency
    }
    func getPaymentCategory() -> categoryData? {
        return self.category
    }
    
    // end
    
    
    init?(snapshot: DataSnapshot, paymentType: String) {
        let dbReference = Database.database().reference()
        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
        // set values
        
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
    
        self.amount = snapshotValue!["paidAmount"] as? Double
        self.date = NSDate(timeIntervalSince1970: snapshotValue!["paidDate"] as! TimeInterval) as Date
        self.categoryCode = snapshotValue!["paymentCategoryCode"] as? String
        
        if((snapshotValue!["paymentEndDate"]) != nil) {
            self.endDate = NSDate(timeIntervalSince1970: snapshotValue!["paymentEndDate"] as! TimeInterval) as Date?
        }
        
        if((snapshotValue!["annualizedPayment"]) != nil) {
            self.isAnnualized = snapshotValue!["annualizedPayment"] as? Bool
        }
        
        self.ref = snapshot.ref
        
        dbReference.removeAllObservers()
    }
    

    func toAnyObject() -> Any {
        //var annualizedPayment = false

//        if(self.isAnnualized == true){
//            annualizedPayment = true
//        }
        
        return [
            "paidAmount": self.amount!,
            "paidDate": self.date!.timeIntervalSince1970, // get date = NSDate(timeIntervalSince1970: paidDate)
            "paymentFrequencyCode": self.frequency!.code!,
            "paymentCategoryCode": self.category!.code!,
            //"annualizedPayment": annualizedPayment,
            "paymentEndDate": self.endDate!.timeIntervalSince1970
        ]
    }
    
    func getFormattedString(valueType:String) -> String{
        var result: String = ""
        // date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // currency formatter
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        if (valueType == "paidDate") {
            result = dateFormatter.string(from: self.date!)
        }
        if (valueType == "paidEndDate") {
            result = dateFormatter.string(from: self.endDate!)
        }
        if (valueType == "paidAmount") {
            result = currencyFormatter.string(from: self.amount! as NSNumber)!
        }
        
        return result
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
        
        
        let amountStr = currencyFormatter.string(from: self.amount! as NSNumber)
            data.append(paymentData(label: "Amount", value: self.amount, format: amountStr))
        
        
        let paidDateString = dateFormatter.string(from: self.date!)
            data.append(paymentData(label: "Paid on", value: self.date, format: paidDateString))
        

        if ((self.category) != nil ) {
            data.append(paymentData(label: "Category", value: self.category, format: self.category?.label))
        }
        return data
    }
    
    func dateDiff(date_x: Date, date_y:Date) -> Int{
        let calendar = Calendar.current
        let year_x = calendar.component(.year, from: date_x)
        let month_x = calendar.component(.month, from: date_x)
        let day_x = calendar.component(.day, from: date_x)
        
        let year_y = calendar.component(.year, from: date_y)
        let month_y = calendar.component(.month, from: date_y)
        let day_y = calendar.component(.day, from: date_y)
        
        return (year_x - year_y) * 100 + (month_x - month_y) * 10 + (day_x - day_y)
    }
}
