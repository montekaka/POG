//
//  PropertyAddViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/26/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class PropertyAddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addressField : UITextField!
    
    @IBOutlet weak var mortgagaPayment: UITextField!
    
    @IBOutlet weak var rentalIncome: UITextField!
    
    var property : Property?
    
    @IBAction func addButtonPressed(sender : UIButton) {
        // NSLog("Button pressed")
        
        if property == nil {
            if let p = Property(address: addressField.text!){
                property = p
                //property?.setMortgagePayment(mortgagePayment: Double(mortgagaPayment.text!)!)

                do {
                    try property!.setMortgagePayment(mortgagePaymentText: (mortgagaPayment.text)!)
                    try property!.setRentalIncome(rentalIncomeText: (rentalIncome.text)!)
                } catch let error as PropertyValidationError {
                    var errorMsg = ""
                    switch(error) {
                    case .InvalidRentalIncome:
                        errorMsg = "Invalid Rental Income"
                    case .InvalidMortgagePayment:
                        errorMsg = "Invalid Mortgage Payment"
                    default:
                        errorMsg = "Invalid"
                    }
                    let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } catch {}                
                
                let appDelegrate = UIApplication.shared.delegate as! AppDelegate
                appDelegrate.propertiesArray.append(property!)
                
                
            } else {
                
                let alert = UIAlertController(title: "Error", message: "Error creating property", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
                
                //self.presentedViewController(alert, animated: true, completion: nil)
                 self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
        // edit
        do {
            try property!.setAddress(address: addressField.text!)
        } catch let error as PropertyValidationError {
            var errorMsg = ""
            switch(error) {
                case .InvalidAddress:
                    errorMsg = "Invalid address"
                default:
                    errorMsg = "Invalid"
            }
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch {
        }
//        if let p = Property(address: addressField.text!) {
//            print("Created a property: \(p.address ?? "gg")")
//        } else {
//            print("Error creating property")
//        }
        
        self.navigationController?.popViewController(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        if let property = property {
            addressField.text = property.address
            mortgagaPayment.text = "$\(property.mortgagePayment ?? 0)"
            rentalIncome.text = "$\(property.rentalIncome ?? 0)"
        }
                
    }
    
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
