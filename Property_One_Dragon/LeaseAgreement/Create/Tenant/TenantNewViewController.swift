//
//  TenantNewViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit

class TenantNewViewController: UIViewController {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var firstNameInputField: UITextField!
    
    @IBOutlet weak var lastNameInputField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    weak var leaseAgreementAddViewController : LeaseAgreementAddViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTenant(_ sender: Any) {
        let lastName = self.lastNameInputField.text
        let firstName = self.firstNameInputField.text
        let phoneNumber = self.phoneNumberTextField.text
        
        let tenant = LeaseAgreementTenant(firstName: firstName!, lastName: lastName!)
        if(phoneNumber != nil){
            tenant.phoneNumber = phoneNumber
        }
        //print(tenant.getFullName())
        leaseAgreementAddViewController?.leaseAgreement?.tenants?.append(tenant)
        //print(leaseAgreementAddViewController?.leaseAgreement?.tenants![0].getFullName())
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
