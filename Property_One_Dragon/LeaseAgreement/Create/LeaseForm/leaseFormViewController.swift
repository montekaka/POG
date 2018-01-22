//
//  leaseFormViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit

class leaseFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var leaseAgreement: LeaseAgreement?
    var arrayOfCellData = [cellData]()
    
    // date picker
    private var startDateField: UITextField!
    private var startDate: Date?
    private var startDateCell: PaymentAddTableViewCellTextField?
    private let startDatePicker = UIDatePicker()
    
    private var endDateField: UITextField!
    private var endDate: Date?
    private var endDateCell: PaymentAddTableViewCellTextField?
    private let endDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCellData = leaseDetailCellData;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
        cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
        
        if arrayOfCellData[indexPath.row].cell == "Input" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
            // Paid Amount
            if(arrayOfCellData[indexPath.row].code == "rentAmount"){
                if(self.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreement?.detail?.getRentalAmountText()
                } else {
                    cell.TextField.placeholder = "Required"
                    cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
//                self.setupDoneButtonToPaymentKeyboard(textfield: cell.TextField)
//                self.billAmount = cell.TextField
//                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            return cell
            
        } 
        return cell
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
