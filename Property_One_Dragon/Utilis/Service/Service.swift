//
//  Service.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/11/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseService {
    
    static let sharedInstance = FirebaseService()
    let dbReference = Database.database().reference()
    
    func getTotalPayment(property_id: String, paymentType: String, completion: @escaping (Double) -> ()) {
        var totalAmount: Double
        //let dbReference = Database.database().reference()
        totalAmount = 0
        let query = dbReference.child(paymentType).queryOrdered(byChild: "propertyId").queryEqual(toValue: property_id)
        let _ = query.observe(.value, with: {snapshot in
            //print(snapshot)
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for sp in snapshots {
                    let snapshotValue = sp.value as? Dictionary<String, AnyObject>
                    totalAmount = totalAmount + (snapshotValue!["paidAmount"] as! Double)
                }
            }
            completion(totalAmount)
        })
    }
}
