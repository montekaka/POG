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
            //print(ref)
            self.propertyKey = snapshotValue!["propertyKey"] as? String
            // lease agreement detail
            self.detail = LeaseAgreementDetails()
            if((snapshotValue!["rentAmount"]) != nil) {
                self.detail?.rentAmount = snapshotValue!["rentAmount"] as? Double
            }
            if((snapshotValue!["startDate"]) != nil) {
                self.detail?.startDate = firebaseDateToNSDate(firebase_date: snapshotValue!["startDate"] as! TimeInterval)
            }
//            // tenants
//            if((snapshotValue!["tenants"]) != nil) {
//
//                let queryTenants = snapshot.ref.child("tenants")
//                print("Yeah....")
//                queryTenants.observe(.value, with: { spTenants in
//                        var newItems: [LeaseAgreementTenant] = []
//                        if let tenantsSp = spTenants.children.allObjects as? [DataSnapshot] {
//                            print(tenantsSp)
//                            for tenantSp in tenantsSp {
//                                let t = LeaseAgreementTenant(snapshot: tenantSp)
//                                newItems.append(t!)
//                            }
//                            self.tenants = newItems
//                        }
//
//                    }
//                )
//            }
        }
    }
    
    func toAnyObject() -> Any {
        var result = [String: Any]()
        result["propertyKey"] = self.propertyKey
        if((self.detail?.startDate) != nil){
            result["startDate"] = self.NSDateToFirebaseDate(input_date: (self.detail?.startDate)!)
        }
        if((self.detail?.startDate) != nil){
            result["rentAmount"] = self.detail?.rentAmount
        }
        return result;
    }
    
    func firebaseDateToNSDate(firebase_date: TimeInterval) -> Date {
        return (NSDate(timeIntervalSince1970: firebase_date ) as Date?)!
    }
    
    func NSDateToFirebaseDate(input_date: Date) -> TimeInterval{
        return input_date.timeIntervalSince1970
    }

    
    func getFormattedString(valueType:String) -> String{
        var result: String = ""
        // date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // currency formatter
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        if (valueType == "startDate") {
            result = dateFormatter.string(from: (self.detail?.startDate)!)
        }
        if (valueType == "endDate") {
            result = dateFormatter.string(from: (self.detail?.endDate)!)
        }
        if (valueType == "rentAmount") {
            result = currencyFormatter.string(from: (self.detail?.rentAmount)! as NSNumber)!
        }
        if (valueType == "tenantsCount") {
            result = String(describing: self.tenants?.count)
        }
        
        return result
    }
    
//    func tenantsToAny() -> Any {
//        
//    }

}
