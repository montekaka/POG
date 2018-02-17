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
        self.rentAmount        = rentAmount
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
        var result = ""
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        
        switch inputCode {
        case "rentAmount":
            result = currencyFormatter.string(from: self.rentAmount! as NSNumber)!
        case "securityDepositAmount":
            result = currencyFormatter.string(from: self.securityDepositAmount! as NSNumber)!
        case "lateFeeAmount":
            result = currencyFormatter.string(from: self.lateFeeAmount! as NSNumber)!
        case "petSecurityDepositAmount":
            result = currencyFormatter.string(from: self.petSecurityDepositAmount! as NSNumber)!
        case "petAdditionalFee":
            result = currencyFormatter.string(from: self.petAdditionalFee! as NSNumber)!
        case "parkingFee":
            result = currencyFormatter.string(from: self.parkingFee! as NSNumber)!
        default:
            result = ""
        }
        return result
    }
    
    func getDateString(inputCode: String) -> String{
        var result: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        switch inputCode {
            case "startdate":
                result = dateFormatter.string(from: self.startDate!)
            case "enddate":
                result = dateFormatter.string(from: self.endDate!)
            default:
                result = ""
        }
        return result;
    }
    
}
