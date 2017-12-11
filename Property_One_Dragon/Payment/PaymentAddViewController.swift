//
//  ReceiptAddViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/30/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class PaymentAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    // firebase
    var dbReference: DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    var property : Property?
    var viewTitle: String!
    var arrayOfCellData = [cellData]()
    var arrayOfFrequencyPickerData = [frequencyData]()
    var arrayOfCategoryData = [categoryData]()
    
    private var payment : Payment?
    private var billAmount: UITextField!
    // button
    private var saveButtonCell: PaymentAddTableViewCellButton?
    private var button: UIButton?
    // date picker
    private var paidDateField: UITextField!
    private var paidDate: Date?
    private var paidDateCell: PaymentAddTableViewCellTextField?
    private let paidDatePicker = UIDatePicker()

    private var endDateField: UITextField!
    private var endDate: Date?
    private var endDateCell: PaymentAddTableViewCellTextField?
    private let endDatePicker = UIDatePicker()
    
    // picker view
    private var fequencyPickerView = UIPickerView()
    private var fequencyPickerCell: PaymentAddTableViewCellTextField?
    private var selectedFrequenceData: frequencyData?
    
    private var categoryPickerView = UIPickerView()
    private var categoryPickerCell: PaymentAddTableViewCellTextField?
    private var selectedCategoryData: categoryData?
    
    // var isAnnualization
    private var AnnualizationCell: PaymentAddTableViewCellSwitch?
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    @objc func addButtonPressed() {
        
        let r = Payment(amount: Double(billAmount.text!)!)
        
        if((self.paidDate) != nil){
            r?.date = self.paidDate
        } else {
            r?.date = Date()
        }
        
        if((self.endDate) != nil){
            r?.endDate = self.endDate
        } else {
            r?.endDate = Date()
        }
        
        if((self.selectedFrequenceData) != nil){
            r?.frequency = self.selectedFrequenceData
        }
        
        if((self.selectedCategoryData) != nil){
            r?.category = self.selectedCategoryData
        }
        
        if property == nil {
        } else {
            r?.property_id = property?.id
        }
        if(self.AnnualizationCell?.switchValue == true) {
            r?.isAnnualized = true
        } else {
            r?.isAnnualized = false
        }
        payment = r
        
        // create a new payment
        self.dbReference = Database.database().reference()
        //property.ref.child
        
        if(self.viewTitle == "New Income") {
            // Add new Income
            self.addNewPayment(payment_type: "Incomes")
            //self.navigationController?.popViewController(animated: true)
        } else {
            // Add new Expense
            self.addNewPayment(payment_type: "Expenses")
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()        
        // add cell data
        // billAmount.keyboardType = UIKeyboardType.numberPad
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        self.title = self.viewTitle
        
        // add button
//        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addButtonPressed))
//        self.navigationItem.rightBarButtonItem = addButton
        
        // add date picker
        // createPaidDatePicker()
        
        // Remove extra empty cells in TableViewController    
        tableView.tableFooterView = UIView()
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    // date picker
    func createPaidDatePicker(cell: PaymentAddTableViewCellTextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePaidDatePickerPressed))
        toolbar.setItems([done], animated: false)
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = paidDatePicker
        //paidDateField.inputAccessoryView = toolbar
        // paidDateField.inputView = paidDatePicker
        // format picker for date
        paidDatePicker.datePickerMode = .date
    }
    
    @objc func donePaidDatePickerPressed(){
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.paidDate = self.paidDatePicker.date
        let dateString = formatter.string(from: paidDatePicker.date)
        self.paidDateCell?.TextField.text = "\(dateString)"
        //paidDateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    // end date date picker
    func createEndDatePicker(cell: PaymentAddTableViewCellTextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEndDatePickerPressed))
        toolbar.setItems([done], animated: false)
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = endDatePicker
        //paidDateField.inputAccessoryView = toolbar
        // paidDateField.inputView = paidDatePicker
        // format picker for date
        endDatePicker.datePickerMode = .date
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
    }
    
    // picker veiw
    func createFrequencePicker(cell: PaymentAddTableViewCellTextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        fequencyPickerView.delegate = self
        fequencyPickerView.dataSource = self
        fequencyPickerView.tag = 1
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = fequencyPickerView
        cell.TextField.placeholder = "e.g. Monthly"
    }
    
    func createCategoryPicker(cell: PaymentAddTableViewCellTextField){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.tag = 2
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = categoryPickerView
        cell.TextField.placeholder = "Required"
//        if(self.viewTitle == "New Expense"){
//            cell.TextField.placeholder = "Required"
//        } else {
//            cell.TextField.placeholder = "e.g. Rental Income"
//        }
        
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
        
        if arrayOfCellData[indexPath.row].cell == "Input" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
            // Paid Amount
            if(arrayOfCellData[indexPath.row].code == "payment"){
                self.billAmount = cell.TextField
                cell.TextField.placeholder = "Required"
                // add icon to the input field
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            return cell
            
        } else if arrayOfCellData[indexPath.row].cell == "Switch" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellSwitch", owner: self, options: nil)?.first as! PaymentAddTableViewCellSwitch
            cell.switchTextLabel.text = arrayOfCellData[indexPath.row].label
            self.AnnualizationCell = cell
            return cell
        } else if arrayOfCellData[indexPath.row].code == "savebutton" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellButton", owner: self, options: nil)?.first as! PaymentAddTableViewCellButton
            self.saveButtonCell = cell
            cell.button.setTitle(arrayOfCellData[indexPath.row].label, for: .normal)
            cell.button.addTarget(self, action: #selector(addButtonPressed), for: UIControlEvents.touchUpInside)

            return cell
        }
        
        else if arrayOfCellData[indexPath.row].cell == "Picker" {
         let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
            
            if arrayOfCellData[indexPath.row].code == "startdate" {
                self.paidDateCell = cell
                createPaidDatePicker(cell: cell)
                // add icon to the input field
                self.inputFieldIconConfig(cell:cell, icon_name:"CalendarIcon")
                cell.TextField.placeholder = "Required"
                
            } else if arrayOfCellData[indexPath.row].code == "enddate" {
                self.endDateCell = cell
                createEndDatePicker(cell: cell)
                // add icon to the input field
                self.inputFieldIconConfig(cell:cell, icon_name:"CalendarIcon")
            }
            else if arrayOfCellData[indexPath.row].code == "freqency" {
                self.fequencyPickerCell = cell
                createFrequencePicker(cell: cell)
                self.inputFieldIconConfig(cell:cell, icon_name:"Frequency")
                
            } else if arrayOfCellData[indexPath.row].code == "category" {
                self.categoryPickerCell = cell
                createCategoryPicker(cell: cell)
                self.inputFieldIconConfig(cell:cell, icon_name:"Category")
            }
            return cell
        }
        else {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextField", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].label
            return cell
        }
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].cell == "Input" {
            return 90
            
        } else if arrayOfCellData[indexPath.row].cell  == "Picker"  {
            return 90
        }
        else if arrayOfCellData[indexPath.row].cell  == "Switch"  {
            return 44
        } else if arrayOfCellData[indexPath.row].cell  == "Button"  {
            return 100
        }
        else {
            return 90
        }
    }
    
    // picker view implemenation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        if(pickerView.tag == 1) {
            // frequency
            count = arrayOfFrequencyPickerData.count
        }
        
        if(pickerView.tag == 2) {
            // category
            count = arrayOfCategoryData.count
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var label = ""

        if(pickerView.tag == 1) {
            // frequency
            label = arrayOfFrequencyPickerData[row].label
        }
        
        if(pickerView.tag == 2) {
            // category
            label = arrayOfCategoryData[row].label
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            fequencyPickerCell?.TextField.text = arrayOfFrequencyPickerData[row].label
            self.selectedFrequenceData = arrayOfFrequencyPickerData[row]
            fequencyPickerCell?.TextField.resignFirstResponder()
        } else if (pickerView.tag == 2){
            categoryPickerCell?.TextField.text = arrayOfCategoryData[row].label
            self.selectedCategoryData = arrayOfCategoryData[row]
            categoryPickerCell?.TextField.resignFirstResponder()
        }
    }
    
    
    func addNewPayment(payment_type: String) {
        // payment_type: Expense / Incomes
        let uid = self.property?.uid
        //let key = self.property!.ref!.child("Expenses").childByAutoId().key
        let propertyKey = self.property!.ref!.key
        let post = self.payment?.toAnyObject()
        let propertyRef = self.dbReference?.child("users").child(uid!).child("properties").child(propertyKey).child(payment_type)
        propertyRef?.childByAutoId().setValue(post)
        self.navigationController?.popViewController(animated: true)
    }
    
    func inputFieldIconConfig(cell: PaymentAddTableViewCellTextField,icon_name: String ){
        let calendarImageView = UIImageView(frame: CGRect(x:0, y: 0, width:50, height: cell.TextField!.frame.size.height))
        calendarImageView.image = UIImage(named: icon_name)
        calendarImageView.contentMode = .center
        cell.TextField.leftView = calendarImageView
        cell.TextField.leftViewMode = .always
    }
    
    // end picker view
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
