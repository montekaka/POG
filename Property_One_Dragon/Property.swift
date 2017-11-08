//
//  Property.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/25/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import Foundation

enum PropertyValidationError : Error {
    case InvalidAddress
    case InvalidMortgagePayment
    case InvalidRentalIncome
}

class Property {
    private(set) var address: String?
    private(set) var mortgagePayment: Double?
    private(set) var rentalIncome: Double?
    private(set) var id: Int?
    
    init?(address: String){
        do {
            try setAddress(address: address)
            let randomNum:UInt32 = arc4random_uniform(100)
            let someInt:Int = Int(randomNum)
            self.id = someInt
        } catch {
            return nil
        }
    }
    
    func setAddress(address: String) throws {
        if (address.characters.count < 1 ){
            throw PropertyValidationError.InvalidAddress
        }
        self.address = address
    }
    
    func setMortgagePayment(mortgagePayment: Double) throws {
        if (mortgagePayment < 0 ){
            throw PropertyValidationError.InvalidMortgagePayment
        }
        self.mortgagePayment = mortgagePayment
    }

    func setRentalIncome(rentalIncome: Double) throws {
        if (rentalIncome < 0 ){
            throw PropertyValidationError.InvalidRentalIncome
        }
        self.rentalIncome = rentalIncome
    }
    
    
}
