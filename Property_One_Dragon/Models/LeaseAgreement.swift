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
    //private(set) var tenantsDatasnapshot: DataSnapshot?
    
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
    
    init?(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
        if((snapshotValue) != nil){
            self.ref = snapshot.ref
            self.propertyKey = snapshotValue!["propertyKey"] as? String
            // lease agreement detail
            self.detail = LeaseAgreementDetails()
            if((snapshotValue!["rentAmount"]) != nil) {
                self.detail?.rentAmount = snapshotValue!["rentAmount"] as? Double
            }
            if((snapshotValue!["starDate"]) != nil) {
                self.detail?.startDate = firebaseDateToNSDate(firebase_date: snapshotValue!["starDate"] as! TimeInterval)
            }
            // tenants
            self.tenants = []
            if(snapshotValue!["tenants"] != nil){
                
                if let tenant_snapshots = snapshotValue!["tenants"]?.children.allObjects as? [DataSnapshot]{
                    for t_sp in tenant_snapshots {
                        let tenant = LeaseAgreementTenant(snapshot: t_sp)
                        self.tenants?.append(tenant!)
                    }
                }
                
            }
        }
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
    
    func firebaseDateToNSDate(firebase_date: TimeInterval) -> Date {
        return (NSDate(timeIntervalSince1970: firebase_date ) as Date?)!
    }
    
    
//    func tenantsToAny() -> Any {
//        
//    }

}
