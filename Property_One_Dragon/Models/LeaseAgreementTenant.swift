//
//  LeaseAgreementTenant.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/20/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import Foundation
import Firebase

class LeaseAgreementTenant {
    
    var ref: DatabaseReference?
    
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init?(snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as? Dictionary<String, AnyObject>
        if((snapshotValue) != nil){
            self.ref = snapshot.ref
            if((snapshotValue!["firstName"]) != nil) {
                self.firstName = snapshotValue!["firstName"] as? String
            }
            if((snapshotValue!["lastName"]) != nil) {
                self.lastName = snapshotValue!["lastName"] as? String
            }
            if((snapshotValue!["phoneNumber"]) != nil) {
                self.phoneNumber = snapshotValue!["phoneNumber"] as? String
            }
        }
    }
            
    func getFullName() -> String{
        return (self.firstName! + " " + self.lastName!)
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber!
    }
    
    func toAnyObject() -> Any {
        var result = [String: Any]()
        result["firstName"] = self.firstName
        result["lastName"] = self.lastName
        if((self.phoneNumber) != nil){
            result["phoneNumber"] = self.phoneNumber
        }
        return result;
    }
}
