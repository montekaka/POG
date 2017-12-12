//
//  PropertyDetailViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/25/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class PropertyDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var masterView: PropertyViewController!
    @IBOutlet weak var tableView: UITableView!
    var selectedPropertyReceiptRow:Int = -1
    var dbReference: DatabaseReference?

    var uid: String?
    var propertyID: String?
    
    var detailItem : Property?
    var propertyTableCells:[tableCellData] = []
    var paymentData:[Payment] = []
    
    var arrayOfFrequencyPickerData: [frequencyData] = []
    var arrayOfExpenseCategoryData: [categoryData] = []
    var arrayOfIncomeCategoryData: [categoryData] = []
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.propertyTableCells = (self.detailItem?.get())!
        // textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        // add edit button
//        let editPropertyButton =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProperty))
//        self.navigationItem.rightBarButtonItem = editPropertyButton
        
        // table view config
        self.configureDatabase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.dbReference = Database.database().reference()
//        self.propertyTableCells = (self.detailItem?.get())!
//        self.getFrequenceFromFB()
//        self.getPaymentCategoryFromFB(payment_type: "expenseCategory")
//        self.getPaymentCategoryFromFB(payment_type: "incomeCategory")
//        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "propertyEditSegue" {
            let controller = segue.destination as! PropertyAddViewController
            controller.property = detailItem
        }
        // Expense
        if segue.identifier == "propertyAddPaymentSegue" {
            let controller = segue.destination as! PaymentAddViewController
            controller.property = detailItem
            controller.viewTitle = "New Expense"
            // * enhancement * move the following array into a property list or json file
            controller.arrayOfCellData = [
                cellData(cell: "Input", code: "payment", label: "Amount")
                ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
                //,cellData(cell: "Switch", text: "Annualized")
                ,cellData(cell: "Picker", code: "category", label: "Category")
                ,cellData(cell: "Picker", code: "freqency",  label: "Paid")
                ,cellData(cell: "Picker", code: "enddate", label: "Payment ends")
                ,cellData(cell:"Button", code: "savebutton", label:"Save")
            ]
            controller.arrayOfFrequencyPickerData = self.arrayOfFrequencyPickerData
            controller.arrayOfCategoryData = self.arrayOfExpenseCategoryData
        }
        
        if segue.identifier == "propertyPaymentTableSegue" {
            let controller = segue.destination as! PaymentViewController
            controller.property = detailItem
            controller.viewTitle = "Expense"
            
            //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
            //controller.dataArray = appDelegrate.receiptsArray
        }
        // Revenue
        if segue.identifier == "propertyAddRevenueSegue" {
            let controller = segue.destination as! PaymentAddViewController
            controller.property = detailItem
            controller.viewTitle = "New Income"
            // * enhancement * move the following array into a property list or json file
            controller.arrayOfCellData = [
                cellData(cell: "Input", code: "payment", label: "Rent Amount")
                ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
                //,cellData(cell: "Switch", text: "Annualized")
                ,cellData(cell: "Picker", code: "category", label: "Category")
                ,cellData(cell: "Picker", code: "freqency",  label: "Rent paid")
                ,cellData(cell: "Picker", code: "enddate", label: "Lease ends")
                ,cellData(cell:"Button", code: "savebutton", label:"Save")
            ]
            controller.arrayOfFrequencyPickerData = self.arrayOfFrequencyPickerData
            controller.arrayOfCategoryData = self.arrayOfIncomeCategoryData
            
//            controller.arrayOfCategoryData = [
//                categoryData(label: "Expense 1", value: 1),
//                categoryData(label: "Expense 2", value: 2),
//                categoryData(label: "Expense 3", value: 3),
//                categoryData(label: "Expense 4", value: 4)
//            ]
        }
        
        if segue.identifier == "propertyRevenueTableSegue" {
            let controller = segue.destination as! PaymentViewController
            controller.property = detailItem
            controller.viewTitle = "Income"
            let appDelegrate = UIApplication.shared.delegate as! AppDelegate
            controller.dataArray = appDelegrate.revenueArray
        }
        
    }

    @objc func editProperty(){
        self.performSegue(withIdentifier: "propertyEditSegue", sender: self)
    }
    
    @objc func addPaymentButtonPressed() {
        self.performSegue(withIdentifier: "propertyAddPaymentSegue", sender: self)
    }
    
    @objc func viewPaymentButtonPressed() {
        self.performSegue(withIdentifier: "propertyPaymentTableSegue", sender: self)
    }
    
    @objc func addRevenueButtonPressed() {
        self.performSegue(withIdentifier: "propertyAddRevenueSegue", sender: self)
    }
    
    @objc func viewRevenueButtonPressed() {
        self.performSegue(withIdentifier: "propertyRevenueTableSegue", sender: self)
    }
    
   // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyTableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let p = propertyTableCells[indexPath.row]
        
        if (p.cellType == "CellWithButton") {
            let cell = Bundle.main.loadNibNamed("PropertyDetailTableViewCellWithButton", owner: self, options: nil)?.first as! PropertyDetailTableViewCellWithButton
            cell.label.text = propertyTableCells[indexPath.row].label
            cell.value.text = propertyTableCells[indexPath.row].value
            cell.selectionStyle = .none
            if (p.label == "Expense") {
                cell.newButton.addTarget(self, action: #selector(addPaymentButtonPressed), for: .touchUpInside)
                cell.detailButton.addTarget(self, action: #selector(viewPaymentButtonPressed), for: .touchUpInside)
            } else if (p.label == "Income") {
                cell.newButton.addTarget(self, action: #selector(addRevenueButtonPressed), for: .touchUpInside)
                cell.detailButton.addTarget(self, action: #selector(viewRevenueButtonPressed), for: .touchUpInside)
            }
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("PropertyDetailTableViewCellText", owner: self, options: nil)?.first as! PropertyDetailTableViewCellText
            cell.label.text = propertyTableCells[indexPath.row].label
            cell.value.text = propertyTableCells[indexPath.row].value
            cell.selectionStyle = .none
            // edit button
            cell.editButton.addTarget(self, action: #selector(editProperty), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let p = propertyTableCells[indexPath.row]

        if (p.cellType == "CellWithButton") {
            return 100
        } else {
            return 80
        }
    }
    
    func getFrequenceFromFB() {
        // get frequency from firebase
        
        _ = (self.dbReference?.child("paymentFrequency"))?.queryOrdered(byChild: "value").observe(.value, with: { snapshot in
            var newItems: [frequencyData] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for item in snapshots {
                    let snapshotValue = item.value as? Dictionary<String, AnyObject>
                    let p = frequencyData(label: snapshotValue!["label"] as! String, code: snapshotValue!["code"] as! String, value: snapshotValue!["value"] as! Float32)
                    newItems.append(p)
                }
                self.arrayOfFrequencyPickerData = newItems;
            }
        })
    }
    
    func getPaymentCategoryFromFB(payment_type:String){
        // get payment category from firebase
        // paymentType = "expenseCategory","incomeCategory"
        _ = (self.dbReference?.child(payment_type))?.queryOrdered(byChild: "value").observe(.value, with: { snapshot in
            var newItems: [categoryData] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for item in snapshots {
                    let snapshotValue = item.value as? Dictionary<String, AnyObject>
                    let p = categoryData(label: snapshotValue!["label"] as! String, code: snapshotValue!["code"] as! String, value: snapshotValue!["value"] as! Float32)
                    newItems.append(p)
                }
                if (payment_type == "expenseCategory") {
                 self.arrayOfExpenseCategoryData = newItems;
                } else if (payment_type == "incomeCategory") {
                 self.arrayOfIncomeCategoryData = newItems;
                }
                
            }
        })
    }
    
    func configureDatabase(){
        if(self.propertyID != nil){
            self.getPropertyFromFB()
        } else {
            self.setupUILabels()
        }
        
    }
    
    func getPropertyFromFB(){
        self.dbReference = Database.database().reference()
        _ = self.dbReference?.child("users").child(uid!).child("properties").child(propertyID!).observe(DataEventType.value, with: {(snapshot) in
            let item = snapshot as DataSnapshot
                let p = Property(snapshot: item)
                self.detailItem = p
                self.setupUILabels()
        })
    }
    
    func setupUILabels(){
        self.propertyTableCells = (self.detailItem?.get())!
        self.getFrequenceFromFB()
        self.getPaymentCategoryFromFB(payment_type: "expenseCategory")
        self.getPaymentCategoryFromFB(payment_type: "incomeCategory")
        self.tableView.reloadData()
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
