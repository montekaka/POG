//
//  LeaseAgreementDetails.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import Foundation


class LeaseAgreementDetails {
    // Lease detail
    var startDate: Date?
    var endDate: Date?
    var rentAmount: Double?
    var dayToPayRent: Int?
    var securityDepositAmount: Double?
    var paymentType: String?
    var lateFeeAmount: Double?
    var lateFeePercentage: Double?
    var lateFeeDays: Int?
    var petSecurityDepositAmount: Double?
    var petAdditionalFee: Double?
    var numberOfParking: Int?
    var parkingFee: Double?
    
    init?(
        startDate: Date
        , endDate: Date
        , rentAmount: Double
        , dayToPayRent: Int
        , securityDepositAmount: Double
        , paymentType: String
        , lateFeeAmount: Double
        , lateFeePercentage: Double
        , lateFeeDays: Int
        , petSecurityDepositAmount: Double
        , petAdditionalFee: Double
        , numberOfParking: Int
        , parkingFee: Double
        )
    {
        self.startDate         = startDate
        self.endDate           = endDate
        self.rentAmount = rentAmount
        self.dayToPayRent       = dayToPayRent
        self.securityDepositAmount      = securityDepositAmount
        self.paymentType        = paymentType
        self.lateFeeAmount      = lateFeeAmount
        self.lateFeePercentage  = lateFeePercentage
        self.lateFeeDays        = lateFeeDays
        self.petSecurityDepositAmount   = petSecurityDepositAmount
        self.petAdditionalFee   = petAdditionalFee
        self.numberOfParking    = numberOfParking
        self.parkingFee = parkingFee
    }
    
    
    func getPaymentAmountText(inputCode: String) -> String{
        var result = "xxx"
        switch inputCode {
        case "rentAmount":
            result = String(format:"%.2f", (self.rentAmount ?? 0))
        case "securityDepositAmount":
            result = String(format:"%.2f", (self.securityDepositAmount ?? 0))
        case "lateFeeAmount":
            result = String(format:"%.2f", (self.lateFeeAmount ?? 0))
        case "petSecurityDepositAmount":
            result = String(format:"%.2f", (self.petSecurityDepositAmount ?? 0))
        case "petAdditionalFee":
            result = String(format:"%.2f", (self.petAdditionalFee ?? 0))
        case "parkingFee":
            result = String(format:"%.2f", (self.parkingFee ?? 0))
        default:
            result = "xxx"
        }
        return result
    }
    
}
