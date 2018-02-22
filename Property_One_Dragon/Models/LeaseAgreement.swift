//
//  LeaseAgreement.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

// TODO: add validation
// 1. owner
// 2 . tenant
// 3 . form fillup
import Foundation
import Firebase

class LeaseAgreement {
    var dbReference: DatabaseReference?
    var ref: DatabaseReference?
    //private(set) var uid: String?
    private(set) var propertyKey: String?
    
    var detail: LeaseAgreementDetails?
    var tenants: [LeaseAgreementTenant]?
    
    // Utility
    var payElectricity: Bool?
    var water: Bool?
    var internet: Bool?
    var trash: Bool?
    var gas: Bool?
    var leadPaintDisclosure: Bool?
    var epaPamphletDisclosure: Bool?
    
    init?( propertyKey: String, detail: LeaseAgreementDetails){
        self.propertyKey = propertyKey;
        self.detail = detail
    }
    
    init?( propertyKey: String){
        self.propertyKey = propertyKey;
        self.detail = LeaseAgreementDetails()
        self.tenants = []
    }
    
    func toAnyObject() -> Any {
        var result = [String: Any]()
        result["propertyKey"] = self.propertyKey
        if((self.detail?.startDate) != nil){
            result["startDate"] = self.detail?.startDate!.timeIntervalSince1970
        }
        if((self.detail?.startDate) != nil){
            result["rentAmount"] = self.detail?.rentAmount
        }
        return result;
    }

}
