//
//  PropertyAddViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/26/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class PropertyAddViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var addressValue: UITextField!
    
    var property : Property?
    var currentUser: User?
    var dbReference: DatabaseReference?
    
    @IBAction func addButtonPressed(sender : UIButton) {
        //let currentUser = Auth.auth().currentUser
        if property == nil {
            if let p = Property(address: addressValue.text!, uid: (self.currentUser?.uid)!){
                property = p
//                let appDelegrate = UIApplication.shared.delegate as! AppDelegate
//                 appDelegrate.propertiesArray.append(property!)
                
                // save obj to firebase
                dbReference = Database.database().reference()
                let uid = self.currentUser?.uid
                let dp = p.toAnyObject()                
                let propertyRef = self.dbReference?.child("users").child(uid!).child("properties")
                propertyRef?.childByAutoId().setValue(dp)
                
            } else {
                
                let alert = UIAlertController(title: "Error", message: "Error creating property", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
                
                //self.presentedViewController(alert, animated: true, completion: nil)
                 self.present(alert, animated: true, completion: nil)
                return
            }
            //Analytics.logEvent("CreatePropertyButtonClicked", parameters: nil)
        }
        
        // edit
        do {
            try property!.setAddress(address: addressValue.text!)
            property?.ref?.updateChildValues(["address": addressValue.text!])            
        } catch let error as PropertyValidationError {
            var errorMsg = ""
            switch(error) {
                case .InvalidAddress:
                    errorMsg = "Invalid address"
                case .InvalidRentalIncome:
                    errorMsg = "Invalid Rental Income"
                case .InvalidMortgagePayment:
                    errorMsg = "Invalid Mortgage Payment"
            }
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch {
        }
        // going back to the property view
        //self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = Auth.auth().currentUser

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.createInputTextField()
        
        if let property = property {
            addressValue.text = property.address
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func createInputTextField(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // done button for toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        
        addressValue.inputAccessoryView = toolBar
       // cell.TextField.inputAccessoryView = toolbar
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
