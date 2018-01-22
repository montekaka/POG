//
//  Config.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/4/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import Foundation

let newLeaseAgreementCellData = [
    cellData(cell: "Text", code: "tenant", label: "Tenant Details")
    ,cellData(cell: "Text", code: "lease_detail", label: "Lease Details")
    ,cellData(cell: "Text", code: "utility", label: "Utility")
]

let leaseDetailCellData = [
    cellData(cell: "Picker", code: "startdate", label: "Start Date")
    ,cellData(cell: "Picker", code: "enddate", label: "End Date")
    ,cellData(cell: "Input", code: "rentAmount", label: "Rent Amount")
    ,cellData(cell: "Input", code: "dayToPayRent", label: "Day oo pay rent")
    ,cellData(cell: "Input", code: "securityDepositAmount", label: "Security Deposit")
    ,cellData(cell: "Input", code: "paymentType", label: "Payment Type")
    ,cellData(cell: "Input", code: "lateFeeAmount", label: "Late Fee Amount")
    ,cellData(cell: "Input", code: "lateFeePercentage", label: "Late Fee Percentage")
    ,cellData(cell: "Input", code: "lateFeeDays", label: "Late Fee Days")
    ,cellData(cell: "Input", code: "petSecurityDepositAmount", label: "Pet Security Deposit")
    ,cellData(cell: "Input", code: "petAdditionalFee", label: "Pet Additional Fee")
    ,cellData(cell: "Input", code: "numberOfParking", label: "Number of parking")
    ,cellData(cell: "Input", code: "parkingFee", label: "Parking Fee")
]

let newPaymentCellData =  [
    cellData(cell: "Input", code: "payment", label: "Amount")
    ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
    //,cellData(cell: "Switch", text: "Annualized")
    ,cellData(cell: "Picker", code: "category", label: "Category")
    ,cellData(cell: "Picker", code: "freqency",  label: "Paid")
    ,cellData(cell: "Picker", code: "enddate", label: "Payment ends")
    ,cellData(cell: "Action", code: "text", label: "Notes")
    ,cellData(cell:"Button", code: "savebutton", label:"Save")
]


let singlePaymentCellData =  [
    cellData(cell: "Input", code: "payment", label: "Amount")
    ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
    //,cellData(cell: "Switch", text: "Annualized")
    ,cellData(cell: "Picker", code: "category", label: "Category")
    ,cellData(cell: "Action", code: "text", label: "Notes")
    ,cellData(cell:"Button", code: "savebutton", label:"Save")
]


let newRevenueCellData = [
    cellData(cell: "Input", code: "payment", label: "Rent Amount")
    ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
    //,cellData(cell: "Switch", text: "Annualized")
    ,cellData(cell: "Picker", code: "category", label: "Category")
    ,cellData(cell: "Picker", code: "freqency",  label: "Rent paid")
    ,cellData(cell: "Picker", code: "enddate", label: "Lease ends")
    ,cellData(cell: "Action", code: "text", label: "Notes")
    ,cellData(cell:"Button", code: "savebutton", label:"Save")
]

let singleRevenueCellData =  [
    cellData(cell: "Input", code: "payment", label: "Amount")
    ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
    //,cellData(cell: "Switch", text: "Annualized")
    ,cellData(cell: "Picker", code: "category", label: "Category")
    ,cellData(cell: "Action", code: "text", label: "Notes")
    ,cellData(cell:"Button", code: "savebutton", label:"Save")
]
