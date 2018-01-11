//
//  Property.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/25/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation
import Firebase

enum PropertyValidationError : Error {
    case InvalidAddress
    case InvalidMortgagePayment
    case InvalidRentalIncome
}

class Property {
    private(set) var address: String?
    var ref: DatabaseReference?
    private(set) var uid: String?
    
    private(set) var id: String?
    private(set) var totalExpense: Double?
    private(set) var totalIncome: Double?
    private(set) var profitMargin: Double?
 
    init?(address: String, uid: String){
        do {
            try setAddress(address: address)
            self.setUID(uid: uid)
            //let randomNum:UInt32 = arc4random_uniform(100)
            //let someInt:Int = Int(randomNum)
            //self.id = someInt
            self.ref = nil
            self.totalExpense = 0
            self.totalIncome = 0
            self.profitMargin = self.getProfitMargin()
        } catch {
            return nil
        }
    }
    
    init?(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
        do {
            try setAddress(address: snapshotValue!["address"] as! String)
            self.setUID(uid: snapshotValue!["addedByUser"] as! String)
            self.ref = snapshot.ref
            self.totalExpense = self.setTotalPayment(snapshotValue: snapshotValue!, paymentType: "Expenses")
            self.totalIncome = self.setTotalPayment(snapshotValue: snapshotValue!, paymentType: "Incomes")
            self.profitMargin = self.getProfitMargin()
            
        } catch {
            return nil
        }
        
    }
    
    func getPaymentTextLabel(paymentType: String) -> String {
        var amountStr: String?
        amountStr = ""
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        if (paymentType == "Income") {
            amountStr = currencyFormatter.string(from: self.totalIncome! as NSNumber)
        } else if (paymentType == "Expense"){
            amountStr = currencyFormatter.string(from: self.totalExpense! as NSNumber)
        } else if (paymentType == "ProfitLoss"){
            amountStr = currencyFormatter.string(from: self.profitMargin! as NSNumber)
        }
        
        return amountStr!
    }
    
//    func getIncomeText() -> String {
//        return self.getPaymentTextLabel(paymentType: "Income")
//    }
//
//    func getExpenseText() -> String {
//        return self.getPaymentTextLabel(paymentType: "Expense")
//    }
    
    func setAddress(address: String) throws {
        if (address.count < 1 ){
            throw PropertyValidationError.InvalidAddress
        }
        self.address = address
    }
    
    func setUID(uid: String) {
        self.uid = uid;
    }
    
    func setPropertyID(id: String){
        self.id = id
    }
    
    func get() -> [tableCellData] {
        var data = [tableCellData]()
        
        data = [
            tableCellData(label: "Address", value: self.address, cellType: "Text"),
            tableCellData(label: "Income", value: self.getPaymentTextLabel(paymentType: "Income"), cellType: "CellWithButton"),
            tableCellData(label: "Expense", value: self.getPaymentTextLabel(paymentType: "Expense"), cellType: "CellWithButton")
        ]                
        return data
    }
    
    func setTotalPayment(snapshotValue: Dictionary<String, AnyObject>, paymentType: String) -> Double {
        var totalAmount: Double?
        totalAmount = 0
        let sp = snapshotValue[paymentType]
        let payments = sp as? Dictionary<String, AnyObject>
        if(payments != nil){
            for payment in payments! {
                totalAmount = totalAmount! + (payment.value["paidAmount"] as! Double)
            }
        }
        return totalAmount!
    }
    
    func getProfitMargin() -> Double {
        var result: Double?
        result = self.totalIncome! - self.totalExpense!
        return result!
    }
    
    func toAnyObject() -> Any {
        // TO-DO: we should remove total income and expense
        return [
            "address": self.address!,
            "addedByUser": self.uid!
        ]
    }
    
    
}
