//
//  ReceiptAddViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/30/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

struct cellData {
    let cell: Int!
    let text: String!
    
}

class ReceiptAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrayOfCellData = [cellData]()
    
    var receipt : Receipt?
    
    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var paidDateField: UITextField!
    var paidDate: Date?
    
    var property : Property?
    let paidDatePicker = UIDatePicker()
    
    func addButtonPressed() {
        let r = Receipt(amount: Double(billAmount.text!)!)
        
        if((self.paidDate) != nil){
            r?.date = self.paidDate
        } else {
            r?.date = Date()
        }            
        if property == nil {
        } else {
            r?.property_id = property?.id
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
            cellData(cell: 1, text: "Paid Amount")
            ,cellData(cell: 1, text: "Date")
            ,cellData(cell: 2, text: "Annualized")
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
    
    func createPaidDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePaidDatePickerPressed))
        toolbar.setItems([done], animated: false)
        
        paidDateField.inputAccessoryView = toolbar
        paidDateField.inputView = paidDatePicker
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
        paidDateField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // table view
    // list of questions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptAddCell", for: IndexPath)
//        
//        let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellTextField", owner: self, options: nil)?.first as! ReceiptAddTableViewCellTextField
//        cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].text
//        return cell
        
        if arrayOfCellData[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellTextField", owner: self, options: nil)?.first as! ReceiptAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].text
            return cell
            
        } else if arrayOfCellData[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellSwitch", owner: self, options: nil)?.first as! ReceiptAddTableViewCellSwitch
            cell.switchTextLabel.text = arrayOfCellData[indexPath.row].text
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("ReceiptAddTableViewCellTextField", owner: self, options: nil)?.first as! ReceiptAddTableViewCellTextField
            cell.TextFieldLabel.text = arrayOfCellData[indexPath.row].text
            return cell
        }
        
    }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 305
//        if arrayOfCellData[indexPath.row].cell == 1 {
//            return 305
//            
//        } else if arrayOfCellData[indexPath.row].cell == 2 {
//            return 200
//        } else {
//           return 305
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
