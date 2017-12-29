//
//  ReceiptDetailViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/1/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class PaymentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var masterView: PaymentViewController!
    var detailItem : Payment?
    var property : Property?
    var viewType: String?
    
    var arrayOfFrequencyPickerData: [frequencyData] = []
    var arrayOfExpenseCategoryData: [categoryData] = []
    var arrayOfIncomeCategoryData: [categoryData] = []
    
    @IBOutlet weak var tableView: UITableView!
    var paymentRecords: [paymentData] = []
    
    // firebase
    var dbReference: DatabaseReference?
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Remove extra empty cells in TableViewController
        tableView.tableFooterView = UIView()
        
        // add edit button
        let editPaymentButton =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPayment))
        self.navigationItem.rightBarButtonItem = editPaymentButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.configData()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paymentRecord = paymentRecords[indexPath.row]
        
        if( paymentRecord.label == "Payment Notes"){
            let cell = Bundle.main.loadNibNamed("PaymentDetailTableViewCellNotes", owner: self, options: nil)?.first as! PaymentDetailTableViewCellNotes
            cell.noteLabel.text = paymentRecord.value as? String
            cell.noteTitle.text = paymentRecord.label
            cell.noteViewMoreButton.addTarget(self, action: #selector(viewMoreNoteButtonPressed), for: .touchUpInside)
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("PaymentDetailTableViewCellText", owner: self, options: nil)?.first as! PaymentDetailTableViewCellText
            cell.fieldLabel.text = paymentRecord.label
            cell.fieldValue.text = paymentRecord.format
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let paymentRecord = paymentRecords[indexPath.row]
        if( paymentRecord.label == "Payment Notes"){
            return 90
        } else {
            return 44
        }
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let paymentRecord = paymentRecords[indexPath.row]
//        if (paymentRecord.label == "Payment Notes") {
//            self.performSegue(withIdentifier: "paymentDetailNoteShowSegue", sender: nil)
//        }
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentEditSegue" {
            let controller = segue.destination as! PaymentAddViewController
            controller.property = self.property
            // * enhancement * move the following array into a property list or json file
            controller.arrayOfCellData = [
                cellData(cell: "Input", code: "payment", label: "Amount")
                ,cellData(cell: "Picker", code: "startdate", label: "Paid on")
                //,cellData(cell: "Switch", text: "Annualized")
                ,cellData(cell: "Picker", code: "category", label: "Category")
                ,cellData(cell: "Picker", code: "freqency",  label: "Paid")
                ,cellData(cell: "Picker", code: "enddate", label: "Payment ends")
                ,cellData(cell: "Action", code: "text", label: "Notes")
                ,cellData(cell:"Button", code: "savebutton", label:"Save")
            ]
            
            
            controller.payment = self.detailItem
            controller.arrayOfFrequencyPickerData = self.arrayOfFrequencyPickerData
            controller.viewType = self.viewType
            if(self.viewType == "Expenses"){
                controller.viewTitle = "Edit Expense"
                controller.arrayOfCategoryData = self.arrayOfExpenseCategoryData // depends on income or expense
            } else if(self.viewType == "Incomes") {
                controller.viewTitle = "Edit Income"
                controller.arrayOfCategoryData = self.arrayOfIncomeCategoryData // depends on income or expense
            } else {
                print("Something went wrong in payment detail view controller")
            }
        }
        if segue.identifier == "paymentDetailNoteShowSegue" {
            let controller = segue.destination as! PaymentDetailTextViewController
            controller.payment = self.detailItem
        }
    }
    
    @objc func editPayment(){
        self.performSegue(withIdentifier: "paymentEditSegue", sender: self)
    }
    
    @objc func viewMoreNoteButtonPressed() {
        self.performSegue(withIdentifier: "paymentDetailNoteShowSegue", sender: self)
    }
    
    func configData(){
        self.dbReference = Database.database().reference()
        self.paymentRecords = detailItem!.get()
        
        detailItem?.ref?.observe(.childChanged, with: { (snapshot) in
            let sp: [String: AnyObject] = [snapshot.key: snapshot.value as AnyObject]
            self.detailItem?.update(viewType: self.viewType!, snapshotValue: sp, dbReference: self.dbReference!)
            self.paymentRecords = (self.detailItem?.get())!
            self.tableView.reloadData()
        })
        
        detailItem?.ref?.observe(.childAdded, with: {(snapshot) in
            let sp: [String: AnyObject] = [snapshot.key: snapshot.value as AnyObject]
            self.detailItem?.update(viewType: self.viewType!, snapshotValue: sp, dbReference: self.dbReference!)
            self.paymentRecords = (self.detailItem?.get())!
            self.tableView.reloadData()
        })
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
