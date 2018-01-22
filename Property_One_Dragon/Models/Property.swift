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
    var dbReference: DatabaseReference?
    private(set) var uid: String?
    
    private(set) var id: String?
    private(set) var totalExpense: Double?
    private(set) var totalIncome: Double?
    private(set) var profitMargin: Double?
    private(set) var totalExpenseStr: String?
    private(set) var totalIncomeStr: String?
    private(set) var profitMarginStr: String?
    
    
    
 
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
            self.profitMargin = 0
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
            let totalExpense = snapshotValue!["totalExpense"] as? Double
            self.setTotalExpense(amount: totalExpense!)
            let totalIncome = snapshotValue!["totalIncome"] as? Double
            self.setTotalIncome(amount: totalIncome!)
            self.getProfitMargin()
            //self.totalIncome = snapshotValue!["totalIncome"] as? Double
            //self.profitMargin = self.totalIncome! - self.totalExpense!
        } catch {
            return nil
        }
        
    }
    
    func setPaymentTextLabel(paymentType: String) -> String {
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
    
    func getPaymentTextLabel(paymentType: String) -> String {
        var amountStr: String?
        amountStr = ""
        if (paymentType == "Income") {
            //snapValue!["label"] as? String ?? ""
            amountStr = self.totalIncomeStr ?? "$0.00"
        } else if (paymentType == "Expense"){
            amountStr = self.totalExpenseStr ?? "$0.00"
        } else if (paymentType == "ProfitLoss"){
            amountStr = self.profitMarginStr ?? "$0.00"
        }
        
        return amountStr!
    }
        
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
            tableCellData(label: "Income", value: self.totalIncomeStr, cellType: "CellWithButton"),
            tableCellData(label: "Expense", value: self.totalExpenseStr, cellType: "CellWithButton"),
            tableCellData(label: "Lease Agreements", value: "0", cellType: "CellWithButton")
        ]                
        return data
    }
        
    func getProfitMargin() {
        //var result: Double?
        self.profitMargin = self.totalIncome! - self.totalExpense!
        self.profitMarginStr = self.setPaymentTextLabel(paymentType: "ProfitLoss")
        //return result!
    }
    
    func toAnyObject() -> Any {
        // TO-DO: we should remove total income and expense
        return [
            "address": self.address!,
            "addedByUser": self.uid!,
            "totalIncome": self.totalIncome!,
            "totalExpense": self.totalExpense!
        ]
    }
    
    func setTotalExpense(amount: Double){
        self.totalExpense = amount
        self.totalExpenseStr = self.setPaymentTextLabel(paymentType: "Expense")
        
    }
    
    func setTotalIncome(amount: Double){
        self.totalIncome = amount
        self.totalIncomeStr = self.setPaymentTextLabel(paymentType: "Income")
    }
    
}
