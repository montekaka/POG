//
//  Config.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/4/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import Foundation

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
