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
    var viewType: String!
    var arrayOfCellData = [cellData]()
    var arrayOfFrequencyPickerData = [frequencyData]()
    var arrayOfCategoryData = [categoryData]()
    private var paymentTextField: UITextField!
    private var frequencyTextField: UITextField!
    private var categoryTextField: UITextField!
    
    var payment : Payment?
    private var isEditingViewController: Bool?
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
    private var selectedFrequenceId: Int!
    
    
    private var categoryPickerView = UIPickerView()
    private var categoryPickerCell: PaymentAddTableViewCellTextField?
    private var selectedCategoryData: categoryData?
    private var selectedCategoryId: Int!
    
    // notes
    var paymentNotes: String?

    // var isAnnualization
    private var AnnualizationCell: PaymentAddTableViewCellSwitch?
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    
    @objc func addButtonPressed() {
        
        // create a new payment
        self.dbReference = Database.database().reference()

        if(self.isEditingViewController == true){
            // edit
            self.editPayment()
        } else {
            // new
            self.createPayment()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
        // add cell data
        // billAmount.keyboardType = UIKeyboardType.numberPad
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        self.title = self.viewTitle
        if(self.payment == nil){
            self.isEditingViewController = false
        } else {
            self.isEditingViewController = true 
        }

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
        if ( self.payment != nil ) {
            paidDatePicker.date = (payment?.getPaidDate())!
        }
        
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
        cell.TextField.inputView = self.endDatePicker
        //paidDateField.inputAccessoryView = toolbar
        // paidDateField.inputView = paidDatePicker
        // format picker for date
        self.endDatePicker.datePickerMode = .date
        if ( self.payment != nil ) {
            self.endDatePicker.date = (payment?.endDate)!
        }
        
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
        // done button config
        self.setupDoneButtonToFrequecyKeyboard(textfield: cell.TextField)
        
        if(self.payment != nil){
            let freq = self.payment?.getPaymentFrquence()
            //let id = self.arrayOfFrequencyPickerData.index
            let id = self.findIdFromArray(item_name: "frequence", val_code: (freq?.code)!)
            fequencyPickerView.selectRow(id, inComponent: 0, animated: false)
        }
        
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
        
        self.setupDoneButtonToCategoryKeyboard(textfield: cell.TextField)
        
        if(self.payment != nil){
            //let c = self.payment?.category
            let c = self.payment?.getPaymentCategory()
            //let id = self.arrayOfFrequencyPickerData.index
            let id = self.findIdFromArray(item_name: "category", val_code: (c?.code)!)
            categoryPickerView.selectRow(id, inComponent: 0, animated: false)
        }
        
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
                if(self.payment != nil){
                    //self.billAmount = self.payment?.amount
                    cell.TextField.text = self.payment?.getPaidAmountText()
                } else {
                    cell.TextField.placeholder = "Required"
                    cell.TextField.becomeFirstResponder()
                    // add icon to the input field
                }
                cell.TextField.keyboardType = UIKeyboardType.decimalPad
                self.setupDoneButtonToPaymentKeyboard(textfield: cell.TextField)
                self.billAmount = cell.TextField
                self.inputFieldIconConfig(cell:cell, icon_name:"Money")
            }
            
            return cell
            
        }
        else if arrayOfCellData[indexPath.row].cell == "Action" {
            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellTextView", owner: self, options: nil)?.first as! PaymentAddTableViewCellTextView
//            cell.notesLabel.text = arrayOfCellData[indexPath.row].label
            //cell.notesActionButton.titleLabel?.text = "Add"
            let buttonTitle = self.paymentNoteActionButtonTitle()
            cell.notesActionButton.setTitle(buttonTitle, for: .normal)
            cell.notesActionButton.addTarget(self, action: #selector(self.addPaymentNotes), for: .touchUpInside)
            return cell
        }
        else if arrayOfCellData[indexPath.row].code == "savebutton" {
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
                
                // add icon to the input field
                self.inputFieldIconConfig(cell:cell, icon_name:"CalendarIcon")
                if(self.payment != nil){
                    cell.TextField.text = self.payment?.getFormattedString(valueType: "paidDate")
                    self.paidDate = self.payment?.getPaidDate()
                    //self.paidDateField.text = cell.TextField.text
                } else {
                    cell.TextField.placeholder = "Required"
                }
                self.paidDateCell = cell
                
                createPaidDatePicker(cell: cell)
                
            } else if arrayOfCellData[indexPath.row].code == "enddate" {
                
                // add icon to the input field
                self.inputFieldIconConfig(cell:cell, icon_name:"CalendarIcon")
                if(self.payment != nil){
                    cell.TextField.text = self.payment?.getFormattedString(valueType: "paidEndDate")
                    self.endDate = self.payment?.endDate
                }
                self.endDateCell = cell
                //self.endDateField.text = cell.TextField.text
                createEndDatePicker(cell: cell)
            }
            else if arrayOfCellData[indexPath.row].code == "freqency" {
                
                self.inputFieldIconConfig(cell:cell, icon_name:"Frequency")
                if(self.payment != nil){
                    let freq = self.payment?.getPaymentFrquence()
                    let freq_label = freq?.label
                    cell.TextField.text = freq_label
                }
                self.fequencyPickerCell = cell
                createFrequencePicker(cell: cell)
                
            } else if arrayOfCellData[indexPath.row].code == "category" {
                self.inputFieldIconConfig(cell:cell, icon_name:"Category")
                if(self.payment != nil){
                    //let categoryLabel = self.payment?.category?.label
                    let categoryLabel = self.payment?.getPaymentCategory()?.label
                    cell.TextField.text = categoryLabel
                }
                self.categoryPickerCell = cell
                createCategoryPicker(cell: cell)
            }
            return cell
        }
            //        else if arrayOfCellData[indexPath.row].cell == "Switch" {
            //            let cell = Bundle.main.loadNibNamed("PaymentAddTableViewCellSwitch", owner: self, options: nil)?.first as! PaymentAddTableViewCellSwitch
            //            cell.switchTextLabel.text = arrayOfCellData[indexPath.row].label
            //            self.AnnualizationCell = cell
            //            return cell
            //        }
        // this should never call
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
            return 70
        } else if arrayOfCellData[indexPath.row].cell == "Action"{
            return 70
        }
        else {
            return 70
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
            self.selectedFrequenceId = row
            fequencyPickerCell?.TextField.text = arrayOfFrequencyPickerData[row].label
            self.selectedFrequenceData = arrayOfFrequencyPickerData[row]
            fequencyPickerCell?.TextField.resignFirstResponder()
            
        } else if (pickerView.tag == 2){
            
            self.selectedCategoryId = row
            categoryPickerCell?.TextField.text = arrayOfCategoryData[row].label
            self.selectedCategoryData = arrayOfCategoryData[row]
            categoryPickerCell?.TextField.resignFirstResponder()
        }
    }
    
    
    func inputFieldIconConfig(cell: PaymentAddTableViewCellTextField,icon_name: String ){
        let calendarImageView = UIImageView(frame: CGRect(x:0, y: 0, width:50, height: cell.TextField!.frame.size.height))
        calendarImageView.image = UIImage(named: icon_name)
        calendarImageView.contentMode = .center
        cell.TextField.leftView = calendarImageView
        cell.TextField.leftViewMode = .always
    }
    
    func findIdFromArray(item_name: String, val_code: String) -> Int {
        var result = -1;
        //var arrayOfCellData = [cellData]()
        //var arrayOfFrequencyPickerData = [frequencyData]()
        //var arrayOfCategoryData = [categoryData]()
        if (item_name == "frequence") {
            let items = self.arrayOfFrequencyPickerData
            var i = 0
            for item in items {
                if(item.code == val_code){
                    result = i
                }
                i = i + 1
            }
            self.selectedFrequenceId = result;
        } else if (item_name == "category") {
            let items = self.arrayOfCategoryData
            var i = 0
            for item in items {
                if(item.code == val_code){
                    result = i
                }
                i = i + 1
            }
            self.selectedCategoryId = result;
        }
        
        return result
    }
    
    func updatePayment(r: Payment){
        if self.property == nil {
        } else {
            r.property_id = property?.id
        }

        if((self.endDate) != nil){
            r.endDate = self.endDate
        } else {
            r.endDate = Date()
        }

        self.payment = r
        self.addNewPayment(payment_type: self.viewType)
    }
    
    func addNewPayment(payment_type: String) {
        // payment_type: Expense / Incomes
        let uid = self.property?.uid
        //let key = self.property!.ref!.child("Expenses").childByAutoId().key
        let propertyKey = self.property!.ref!.key
        if (self.isEditingViewController == false) {
            // new
            var post = self.payment?.toAnyObject(repeatPayment: true)
            if(self.payment?.isRecurrentPayment())!{
                // create both payment and recurrent payment
                let repeatPaymentRef = self.dbReference?.child("users").child(uid!).child("properties").child(propertyKey).child("recurrent").child(payment_type)
                
                let postRepeatPaymentRef = repeatPaymentRef?.childByAutoId()
                postRepeatPaymentRef?.setValue(post)
                let rpid = postRepeatPaymentRef?.key
                self.payment?.setRecurrentPaymentID(key: rpid!)
                post = self.payment?.toAnyObject(repeatPayment: false)
            }
            // create payment
            let propertyRef = self.dbReference?.child("users").child(uid!).child("properties").child(propertyKey).child(payment_type)
            propertyRef?.childByAutoId().setValue(post)
        } else {
            // edit non recurrent payment
            let post = self.payment!.toAnyObject(repeatPayment: false)
            //print(post)
            self.payment?.ref?.updateChildValues(post as! [AnyHashable : Any])
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addPaymentNotes(){
        self.performSegue(withIdentifier: "paymentNotesAddSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentNotesAddSegue" {
            let notesView: PaymentDetailTextViewController = segue.destination as! PaymentDetailTextViewController
            notesView.paymentAddViewController = self
            notesView.savingButton = true
            if(self.isEditNote() == true){
                notesView.payment = self.payment
            }
        }
    }
    
    func paymentNoteActionButtonTitle() -> String{
        var buttonTitle = "New notes"
        if(self.isEditNote() == true){
            // editing
            buttonTitle = "Edit notes"
        }
        return buttonTitle
    }
    
    func isEditNote() -> Bool {
        var result = false
        let payment_note = self.payment?.paymentNotes
        let paymentNoteLenght = payment_note?.count ?? 0
        
        if(self.isEditingViewController! == true && paymentNoteLenght > 0){
            result = true
        }
        return result
    }
    
    
    // done button setup
    
    // 1. Payment Keyboard
    func setupDoneButtonToPaymentKeyboard(textfield: UITextField){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        self.paymentTextField = textfield
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hidePaymentKeyboard))
        toolbarDone.setItems([done], animated: false)
        
        textfield.inputAccessoryView = toolbarDone
    }
    
    @objc func hidePaymentKeyboard(){
        // to hide keyboards
        self.paymentTextField.resignFirstResponder()
    }
    
    // 2. Category Picker
    func setupDoneButtonToCategoryKeyboard(textfield: UITextField){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        self.categoryTextField = textfield
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideCategoryPicker))
        toolbarDone.setItems([done], animated: false)
        
        textfield.inputAccessoryView = toolbarDone
    }
    
    @objc func hideCategoryPicker(){
        // to hide keyboards
        if(self.selectedCategoryId == nil){
            self.selectedCategoryId = 0;
        }
        let row = self.selectedCategoryId!
        //print(row)
        self.categoryTextField.text = arrayOfCategoryData[row].label
        self.selectedCategoryData = arrayOfCategoryData[row]
        self.categoryTextField.resignFirstResponder()
    }
    // 3. Frequency Picker
    func setupDoneButtonToFrequecyKeyboard(textfield: UITextField){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        self.frequencyTextField = textfield
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideFrequecyPicker))
        toolbarDone.setItems([done], animated: false)
        
        textfield.inputAccessoryView = toolbarDone
    }
    
    @objc func hideFrequecyPicker(){
        // to hide keyboards
        if(self.selectedFrequenceId == nil){
            self.selectedFrequenceId = 0;
        }
        let row = self.selectedFrequenceId!
        //print(row)
        self.frequencyTextField.text = arrayOfFrequencyPickerData[row].label
        self.selectedFrequenceData = arrayOfFrequencyPickerData[row]
        self.frequencyTextField.resignFirstResponder()
    }
    // create new payment
    func createPayment(){
        var r: Payment!
        let bill_amount = Double(self.billAmount.text!) ?? 0
        let paid_date = self.paidDate ?? Date()
        
        if let p = Payment(amount: bill_amount) {
            r = p
            let end_date = self.endDate ?? paid_date
            r.endDate = end_date
            print(paid_date)
            if(self.paymentNotes != nil) {
                r.paymentNotes = self.paymentNotes
            }
            
            do {
                try r!.setPaidAmount(amount: bill_amount)
                try r!.setPaidDate(paid_date: paid_date, end_date: end_date)
                try r!.setPaymentFrequency(freq: self.selectedFrequenceData)
                try r!.setPaymentCategory(category_item: self.selectedCategoryData)
                
                self.updatePayment(r:r)
            } catch let error as PaymentValidationError{
                var errorMsg = ""
                switch(error) {
                case .InvalidPayAmount:
                    errorMsg = "Invalid Amount"
                case .InvalidPaidDate:
                    errorMsg = "Invalid Date"
                case .InvalidPaymentFrequence:
                    errorMsg = "Payment frequency is required"
                case .InvalidPaymentCategory:
                    errorMsg = "Payment category is required"
                }
                let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } catch {
                
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Error creating payment", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    // update
    func editPayment(){
        var r: Payment!
        r = self.payment
        let bill_amount = Double(self.billAmount.text!) ?? 0
        let end_date = self.endDate ?? self.paidDate
        let selected_freq_data = self.selectedFrequenceData ?? self.payment?.getPaymentFrquence()
        let selected_category_data = self.selectedCategoryData ?? self.payment?.getPaymentCategory()
        r.endDate = end_date
        if(self.paymentNotes != nil) {
            r.paymentNotes = self.paymentNotes
        }
        //r.amount = Double(billAmount.text!)
        
        do {
            try r!.setPaidAmount(amount: bill_amount)
            
            if((self.paidDate) != nil){
                //r?.date = self.paidDate
                try r.setPaidDate(paid_date: self.paidDate!, end_date: end_date!)
            } else {
                let paid_date = Date()
                try r.setPaidDate(paid_date: paid_date, end_date: end_date!)
            }
            
            try r!.setPaidDate(paid_date: self.paidDate!, end_date: end_date!)
            try r!.setPaymentFrequency(freq: selected_freq_data)
            try r!.setPaymentCategory(category_item: selected_category_data)
            self.updatePayment(r:r)
        } catch let error as PaymentValidationError {
            var errorMsg = ""
            switch(error) {
            case .InvalidPayAmount:
                errorMsg = "Invalid amount"
            case .InvalidPaidDate:
                errorMsg = "Paid Date can't be later than payment end date"
            case .InvalidPaymentFrequence:
                errorMsg = "Payment frequency is required"
            case .InvalidPaymentCategory:
                errorMsg = "Payment category is required"
            }
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } catch {
        }

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
