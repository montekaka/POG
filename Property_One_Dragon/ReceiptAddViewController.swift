//
//  ReceiptAddViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/30/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

struct cellData {
    let cell: String!
    let text: String!
    
}


class ReceiptAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var arrayOfCellData = [cellData]()
    var arrayOfFrequencyPickerData = [frequencyData]()
    var arrayOfCategoryData = [categoryData]()
    
    var receipt : Receipt?
    
    var billAmount: UITextField!
    var paidDateField: UITextField!
    var paidDate: Date?
    var paidDateCell: ReceiptAddTableViewCellPicker?
    
    var property : Property?
    let paidDatePicker = UIDatePicker()
    
    // picker view
    var fequencyPickerView = UIPickerView()
    var fequencyPickerCell: ReceiptAddTableViewCellPicker?
    var selectedFrequenceData: frequencyData?
    
    var categoryPickerView = UIPickerView()
    var categoryPickerCell: ReceiptAddTableViewCellPicker?
    var selectedCategoryData: categoryData?
    
    // var isAnnualization
    var AnnualizationCell: ReceiptAddTableViewCellSwitch?
    
    func addButtonPressed() {
        let r = Receipt(amount: Double(billAmount.text!)!)
        
        if((self.paidDate) != nil){
            r?.date = self.paidDate
        } else {
            r?.date = Date()
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
        receipt = r
        
        // create a new receipt
        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        // this should sit inside property instead its own, we will refactor it later on
        appDelegrate.receiptsArray.append(receipt!)
        // add the new receipt cost to property expense
        
        let propertyArray = appDelegrate.propertiesArray.filter{
            $0.id == property?.id
        }
        
        if(propertyArray.count > 0 ){
            propertyArray[0].totalExpense = propertyArray[0].totalExpense! + (r?.amount)!
            // after we successfully create the receipt, then go back
            self.navigationController?.popViewController(animated: true)
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // add cell data
        arrayOfCellData = [
            cellData(cell: "Input", text: "Paid Amount")
            ,cellData(cell: "Picker", text: "Date")
            ,cellData(cell: "Picker", text: "Frequency")
            ,cellData(cell: "Switch", text: "Annualized")
            ,cellData(cell: "Picker", text: "Category")
        ]
        // add frequence data 
        arrayOfFrequencyPickerData = [
            frequencyData(label: "Not Repeat", value: 0),
            frequencyData(label: "Semi Monthly", value: 0.5),
            frequencyData(label: "Monthly", value: 1),
            frequencyData(label: "Semi Annually", value: 6),
            frequencyData(label: "Annually", value: 12)
        ]
        
        // add category data
        arrayOfCategoryData = [
            categoryData(label: "Expense 1", value: 1),
            categoryData(label: "Expense 2", value: 2),
            categoryData(label: "Expense 3", value: 3),
            categoryData(label: "Expense 4", value: 4)
        ]
        // billAmount.keyboardType = UIKeyboardType.numberPad
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        self.title = "New Expense"
        
        // add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
        
        // add date picker
        // createPaidDatePicker()
        
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func createPaidDatePicker(cell: ReceiptAddTableViewCellPicker){
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
    
    func donePaidDatePickerPressed(){
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
    
    
    // picker veiw
    func createFrequencePicker(cell: ReceiptAddTableViewCellPicker){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        fequencyPickerView.delegate = self
        fequencyPickerView.dataSource = self
        fequencyPickerView.tag = 1
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = fequencyPickerView
        cell.TextField.placeholder = "e.g. Monthly"
    }
    
    func createCategoryPicker(cell: ReceiptAddTableViewCellPicker){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.tag = 2
        
        cell.TextField.inputAccessoryView = toolbar
        cell.TextField.inputView = categoryPickerView
        cell.TextField.placeholder = "e.g. Expense 1"
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
            let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellTextField", owner: self, options: nil)?.first as! ReceiptAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].text
            self.billAmount = cell.TextField
            return cell
            
        } else if arrayOfCellData[indexPath.row].cell == "Switch" {
            let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellSwitch", owner: self, options: nil)?.first as! ReceiptAddTableViewCellSwitch
            cell.switchTextLabel.text = arrayOfCellData[indexPath.row].text
            self.AnnualizationCell = cell
            return cell
        } else if arrayOfCellData[indexPath.row].cell == "Picker" {
         let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellPicker", owner: self, options: nil)?.first as! ReceiptAddTableViewCellPicker
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].text
            
            if arrayOfCellData[indexPath.row].text == "Date" {
                self.paidDateCell = cell
                createPaidDatePicker(cell: cell)
            } else if arrayOfCellData[indexPath.row].text == "Frequency" {
                self.fequencyPickerCell = cell
                createFrequencePicker(cell: cell)
            } else if arrayOfCellData[indexPath.row].text == "Category" {
                self.categoryPickerCell = cell
                createCategoryPicker(cell: cell)
            }

            return cell
        }
        else {
            let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellTextField", owner: self, options: nil)?.first as! ReceiptAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].text
            return cell
        }
        
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].cell == "Input" {
            return 90
            
        } else if arrayOfCellData[indexPath.row].cell  == "Picker"  {
            return 44
        }
        else if arrayOfCellData[indexPath.row].cell  == "Switch"  {
            return 44
        } else {
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
