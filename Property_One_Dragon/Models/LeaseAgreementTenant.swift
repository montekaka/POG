//
//  LeaseAgreementTenant.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/20/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import Foundation
class LeaseAgreementTenant {
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func getFullName() -> String{
        return self.firstName! + " " + self.lastName!
    }
}
