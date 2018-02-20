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
    
    private var formValues = [String: Any]()
    
    // rental payment
    private var rentalPaymentField: UITextField!
    private var rentalSecurityDepositField: UITextField!
    private var lateFeeAmountField: UITextField!
    private var petSecurityDepositAmountField: UITextField!
    private var petAdditionalFeeField: UITextField!
    private var parkingFeeField: UITextField!
    
    private var rentalPaymentVal: String!
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        // Save Button
        self.configRightBarButton()
    }
    
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
        
        //self.formValues[arrayOfCellData[indexPath.row].label] = cell.TextField
        if arrayOfCellData[indexPath.row].cell == "Input" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
            // Paid Amount
            if(arrayOfCellData[indexPath.row].code == "rentAmount"){
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getPaymentAmountText(inputCode: arrayOfCellData[indexPath.row].code)
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonNumberKeyboard(textfield: cell.TextField, inputCode: arrayOfCellData[indexPath.row].code)
                self.rentalPaymentField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            // security deposit
            if(arrayOfCellData[indexPath.row].code == "securityDepositAmount"){
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getPaymentAmountText(inputCode: arrayOfCellData[indexPath.row].code)
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonNumberKeyboard(textfield: cell.TextField, inputCode: arrayOfCellData[indexPath.row].code)
                self.rentalSecurityDepositField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            // late fee
            if(arrayOfCellData[indexPath.row].code == "lateFeeAmount"){
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getPaymentAmountText(inputCode: arrayOfCellData[indexPath.row].code)
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonNumberKeyboard(textfield: cell.TextField, inputCode: arrayOfCellData[indexPath.row].code)
                self.lateFeeAmountField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            // petSecurityDepositAmount
            if(arrayOfCellData[indexPath.row].code == "petSecurityDepositAmount"){
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getPaymentAmountText(inputCode: arrayOfCellData[indexPath.row].code)
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonNumberKeyboard(textfield: cell.TextField, inputCode: arrayOfCellData[indexPath.row].code)
                self.petSecurityDepositAmountField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            // petAdditionalFee
            if(arrayOfCellData[indexPath.row].code == "petAdditionalFee"){
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getPaymentAmountText(inputCode: arrayOfCellData[indexPath.row].code)
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonNumberKeyboard(textfield: cell.TextField, inputCode: arrayOfCellData[indexPath.row].code)
                self.petAdditionalFeeField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            // ParkingFee
            if(arrayOfCellData[indexPath.row].code == "parkingFee"){
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getPaymentAmountText(inputCode: arrayOfCellData[indexPath.row].code)
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonNumberKeyboard(textfield: cell.TextField, inputCode: arrayOfCellData[indexPath.row].code)
                self.parkingFeeField = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            
            return cell
            
        }
        // picker
        else if arrayOfCellData[indexPath.row].cell == "Picker" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
            
            // DATE PICKERS
            // Start Date
            
            if(arrayOfCellData[indexPath.row].code == "startdate"){
                self.inputFieldIconConfig(cell:cell, icon_name:"CalendarIcon")
                self.startDateCell = cell
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getDateString(inputCode: arrayOfCellData[indexPath.row].code)
                    self.startDate = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.startDate
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }

                createStartDatePicker(cell: cell)
            }
            // End Date
            
            if(arrayOfCellData[indexPath.row].code == "enddate"){
                self.inputFieldIconConfig(cell:cell, icon_name:"CalendarIcon")
                self.endDateCell = cell
                if(self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil){
                    cell.TextField.text = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.getDateString(inputCode: arrayOfCellData[indexPath.row].code)
                    self.endDate = self.leaseAgreementAddViewController?.leaseAgreement?.detail?.endDate
                } else {
                    cell.TextField.placeholder = "Required"
                    //cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                
                createEndDatePicker(cell: cell)
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
    func setupDoneButtonNumberKeyboard(textfield: UITextField, inputCode: String){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        switch inputCode {
        case "rentAmount":
            self.rentalPaymentField = textfield
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideRentAmountKeyboard))
            toolbarDone.setItems([done], animated: false)
            textfield.inputAccessoryView = toolbarDone
        case "securityDepositAmount":
            self.rentalSecurityDepositField = textfield
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideSecurityDepositAmountKeyboard))
            toolbarDone.setItems([done], animated: false)
            textfield.inputAccessoryView = toolbarDone
        case "lateFeeAmount":
            self.lateFeeAmountField = textfield
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideLateFeeAmountKeyboard))
            toolbarDone.setItems([done], animated: false)
            textfield.inputAccessoryView = toolbarDone
        case "petSecurityDepositAmount":
            self.petSecurityDepositAmountField = textfield
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hidePetSecurityDepositAmountKeyboard))
            toolbarDone.setItems([done], animated: false)
            textfield.inputAccessoryView = toolbarDone
        case "petAdditionalFee":
            self.petAdditionalFeeField = textfield
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hidePetAdditionalFeeAmountKeyboard))
            toolbarDone.setItems([done], animated: false)
            textfield.inputAccessoryView = toolbarDone
        case "parkingFee":
            self.parkingFeeField = textfield
            let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideParkingFeeAmountKeyboard))
            toolbarDone.setItems([done], animated: false)
            textfield.inputAccessoryView = toolbarDone
            
        default:
            print("something is wrong")
        }
        
    }
    
    // start date date picker
    func createStartDatePicker(cell: PaymentAddTableViewCellTextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneStartDatePickerPressed))
        toolbar.setItems([done], animated: false)
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = self.startDatePicker
        //paidDateField.inputAccessoryView = toolbar
        // paidDateField.inputView = paidDatePicker
        // format picker for date
        self.startDatePicker.datePickerMode = .date
        if ( self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil ) {
            self.startDatePicker.date = (self.leaseAgreementAddViewController?.leaseAgreement?.detail?.startDate)!
        }
        
    }
    
    // end date date picker
    func createEndDatePicker(cell: PaymentAddTableViewCellTextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEndDatePickerPressed))
        toolbar.setItems([done], animated: false)
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = self.endDatePicker
        //paidDateField.inputAccessoryView = toolbar
        // paidDateField.inputView = paidDatePicker
        // format picker for date
        self.endDatePicker.datePickerMode = .date
        if ( self.leaseAgreementAddViewController?.leaseAgreement?.detail != nil ) {
            self.endDatePicker.date = (self.leaseAgreementAddViewController?.leaseAgreement?.detail?.endDate)!
        }
        
    }
    
    
    @objc func doneStartDatePickerPressed(){
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.startDate = self.startDatePicker.date
        let dateString = formatter.string(from: startDatePicker.date)
        self.startDateCell?.TextField.text = "\(dateString)"
        //paidDateField.text = "\(dateString)"
        self.view.endEditing(true)
        
        self.setFormValues()
    }
    
    @objc func doneEndDatePickerPressed(){
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.endDate = self.endDatePicker.date
        let dateString = formatter.string(from: endDatePicker.date)
        self.endDateCell?.TextField.text = "\(dateString)"
        //paidDateField.text = "\(dateString)"
        self.view.endEditing(true)
        self.setFormValues()
    }
    
    @objc func hideRentAmountKeyboard(){
        // to hide keyboards
        self.setFormValues()
        self.rentalPaymentField.resignFirstResponder()
    }
    
    @objc func hideSecurityDepositAmountKeyboard(){
        // to hide keyboards
        self.setFormValues()
        self.rentalSecurityDepositField.resignFirstResponder()
    }
    
    @objc func hideLateFeeAmountKeyboard(){
        // to hide keyboards
        self.setFormValues()
        self.lateFeeAmountField.resignFirstResponder()
    }
    
    @objc func hidePetSecurityDepositAmountKeyboard(){
        // to hide keyboards
        self.setFormValues()
        self.petSecurityDepositAmountField.resignFirstResponder()
    }
    
    @objc func hidePetAdditionalFeeAmountKeyboard(){
        // to hide keyboards
        self.setFormValues()
        self.petAdditionalFeeField.resignFirstResponder()
    }
    
    @objc func hideParkingFeeAmountKeyboard(){
        // to hide keyboards
        self.setFormValues()
        self.parkingFeeField.resignFirstResponder()
    }
    
    
// Save button
    func configRightBarButton(){
        self.setupSavingButton()
    }
    
    func setupSavingButton(){
        let saveTextButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateLeaseForm))
        self.navigationItem.rightBarButtonItem = saveTextButton
        self.tableView.becomeFirstResponder()
    }
    
    @objc func updateLeaseForm(){
        //self.navigationController?.popViewController(animated: true)
        print(self.formValues)
    }
    
    func setFormValues(){
//        private var rentalPaymentField: UITextField!
//        private var rentalSecurityDepositField: UITextField!
//        private var lateFeeAmountField: UITextField!
//        private var petSecurityDepositAmountField: UITextField!
//        private var petAdditionalFeeField: UITextField!
//        private var parkingFeeField: UITextField!
//        private var endDateField: UITextField!
//        private var startDateField: UITextField!
        
        if((self.rentalPaymentField.text) != nil){
            self.formValues["rentAmount"] = self.rentalPaymentField.text
        }
        if((self.rentalSecurityDepositField.text) != nil){
            self.formValues["securityDepositAmount"] = self.rentalSecurityDepositField.text
        }
        if((self.lateFeeAmountField.text) != nil){
            self.formValues["lateFeeAmount"] = self.lateFeeAmountField.text
        }
        if((self.petSecurityDepositAmountField.text) != nil){
            self.formValues["petSecurityDepositAmount"] = self.petSecurityDepositAmountField.text
        }
        if((self.petAdditionalFeeField.text) != nil){
            self.formValues["petAdditionalFee"] = self.petAdditionalFeeField.text
        }
        if((self.parkingFeeField.text) != nil){
            self.formValues["parkingFee"] = self.parkingFeeField.text
        }
        if((self.startDate) != nil){
            self.formValues["startDate"] = self.startDate
        }
        if((self.endDate) != nil){
            self.formValues["endDate"] = self.endDate
        }
//        if((self.startDateField.text) != nil){
//            self.formValues["startDate"] = self.startDateField.text
//        }
//        if((self.endDateField.text) != nil){
//            self.formValues["endDate"] = self.endDateField.text
//        }
        
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
