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
    weak var leaseAgreementAddViewController : LeaseAgreementAddViewController?
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
    
    // rental payment
    private var rentalPaymentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        arrayOfCellData = leaseDetailCellData;
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
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
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getRentalAmountText()
                } else {
                    cell.TextField.placeholder = "Required"
                    cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonToPaymentKeyboard(textfield: cell.TextField)
                self.rentalPaymentField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
//                self.setupDoneButtonToPaymentKeyboard(textfield: cell.TextField)
//                self.billAmount = cell.TextField
//                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            return cell
            
        }
        // placeholder
        else if arrayOfCellData[indexPath.row].cell == "Placeholder" {
            let cell = Bundle.main.loadNibNamed("PlaceholderTableViewCell", owner: self, options: nil)?.first as! PlaceholderTableViewCell
            return cell
            
        }
        return cell
    }
    
    
    @objc func hidePaymentKeyboard(){
        // to hide keyboards
        self.rentalPaymentField.resignFirstResponder()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // handle icons
    func inputFieldIconConfig(cell: PaymentAddTableViewCellTextField,icon_name: String ){
        let calendarImageView = UIImageView(frame: CGRect(x:0, y: 0, width:50, height: cell.TextField!.frame.size.height))
        calendarImageView.image = UIImage(named: icon_name)
        calendarImageView.contentMode = .center
        cell.TextField.leftView = calendarImageView
        cell.TextField.leftViewMode = .always
    }
    
    // 1. Payment Keyboard
    func setupDoneButtonToPaymentKeyboard(textfield: UITextField){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        self.rentalPaymentField = textfield
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hidePaymentKeyboard))
        toolbarDone.setItems([done], animated: false)
        
        textfield.inputAccessoryView = toolbarDone
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
