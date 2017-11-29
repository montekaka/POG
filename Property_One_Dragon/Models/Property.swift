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
    
    private(set) var mortgagePayment: Double?
    private(set) var rentalIncome: Double?
    
    
    //private(set) var totalIncome: Double?
    // private(set) var totalExpense: Double?
    var totalExpense: Double?
    var totalIncome: Double?
    var ref: DatabaseReference?
    private(set) var uid: String?
    
    private(set) var id: Int?
    
    init?(address: String, uid: String){
        do {
            try setAddress(address: address)
            self.setUID(uid: uid)
            self.mortgagePayment = 0
            self.rentalIncome = 0
            self.totalIncome = 0
            self.totalExpense = 0
            let randomNum:UInt32 = arc4random_uniform(100)
            let someInt:Int = Int(randomNum)
            self.id = someInt
            self.ref = nil
        } catch {
            return nil
        }
    }
    
    init?(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
        do {
            try setAddress(address: snapshotValue!["address"] as! String)
            self.setUID(uid: snapshotValue!["addedByUser"] as! String)
            self.mortgagePayment = 0
            self.rentalIncome = 0
            self.totalIncome = snapshotValue!["income"] as? Double
            self.totalExpense = snapshotValue!["expense"] as? Double
            self.ref = snapshot.ref
        } catch{
            return nil
        }
        
    }
    
    func getIncomeText() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        let amountStr = currencyFormatter.string(from: self.totalIncome! as NSNumber)
        return amountStr!
    }
    
    func getExpenseText() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        let amountStr = currencyFormatter.string(from: self.totalExpense! as NSNumber)
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
    
    func setMortgagePayment(mortgagePaymentText: String) throws {
        let mortgagePayment: Double
        if let _ = Double(mortgagePaymentText) {
            mortgagePayment = Double(mortgagePaymentText)!
            if (mortgagePayment < 0 ){
                throw PropertyValidationError.InvalidMortgagePayment
            } else {
                
            }
        } else {
            throw PropertyValidationError.InvalidMortgagePayment
        }
        self.totalExpense = self.totalExpense! - self.mortgagePayment!
        self.mortgagePayment = mortgagePayment
        self.totalExpense = self.totalExpense! + self.mortgagePayment!
        
    }

    func setRentalIncome(rentalIncomeText: String) throws {
        let rentalIncome: Double
        if let _ = Double(rentalIncomeText) {
            rentalIncome = Double(rentalIncomeText)!
            if (rentalIncome < 0 ){
                throw PropertyValidationError.InvalidRentalIncome
            } else {
                
            }
        } else {
            throw PropertyValidationError.InvalidRentalIncome
        }
        
        self.totalIncome = self.totalIncome! - self.rentalIncome!
        self.rentalIncome = rentalIncome
        self.totalIncome = self.totalIncome! + self.rentalIncome!
    }
    
    func get() -> [tableCellData] {
        var data = [tableCellData]()
        data = [
            tableCellData(label: "Address", value: self.address, cellType: "Text"),
            tableCellData(label: "Income", value: self.getIncomeText(), cellType: "CellWithButton"),
            tableCellData(label: "Expense", value: self.getExpenseText(), cellType: "CellWithButton")
        ]                
        return data
    }
    
    func toAnyObject() -> Any {
        return [
            "address": self.address!,
            "addedByUser": self.uid!,
            "income": self.totalIncome!,
            "expense": self.totalExpense!
        ]
    }
    
    
}
