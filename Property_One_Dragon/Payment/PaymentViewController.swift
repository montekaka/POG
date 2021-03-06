//
//  ReceiptViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/30/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class PaymentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //var data: [String] = ["Row 1","Row 2","Row 3"]
  
    var selectedRow:Int = -1
    var property : Property?
    var viewTitle: String!
    var viewType: String! // "Incomes", "Expenses"
    var dataArray:[Payment] = []
    var tableViewPickID: Int? // init from the property detail view contorller
    var repeatPayment: Bool?
    
    var arrayOfFrequencyPickerData: [frequencyData] = []
    var arrayOfExpenseCategoryData: [categoryData] = []
    var arrayOfIncomeCategoryData: [categoryData] = []
    
    // firebase
    var dbReference: DatabaseReference?
    var dbHandle: DatabaseHandle?
    
    @IBAction func switchTableViewAction(_ sender: UISegmentedControl) {
        self.tableViewPickID = sender.selectedSegmentIndex
        self.configData()
    }
    

    
    @IBOutlet weak var table: UITableView!
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableViewPickID = 0
        self.tabBarController?.tabBar.isHidden = true
        self.title = viewTitle
        self.dbReference = Database.database().reference()
        self.configData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        //let object = appDelegrate.receiptsArray[indexPath.row]
        
        let object = dataArray[indexPath.row]
        
        //let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentTableCell")!
        
        let cell = Bundle.main.loadNibNamed("PaymentTableViewCell", owner: self, options: nil)?.first as! PaymentTableViewCell
        
        //cell.paidDateLabel.text = object.date
        cell.paidDateLabel.text = object.getFormattedString(valueType: "paidDate")
        cell.paymentAmountLabel.text = object.getFormattedString(valueType: "paidAmount")
        let category_itme = object.getPaymentCategory()
        if (category_itme != nil){
            cell.categoryLabel.text = category_itme?.label
            cell.categoryImage?.image = UIImage(named: (category_itme?.code)!)
        } else {
            cell.categoryLabel.text = object.categoryCode
            self.getCategoryFromFB(payment: object, paymentType: self.viewTitle, cell: cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "paymentDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let p = dataArray[indexPath.row]
            p.ref?.removeValue()
            FirebaseService.sharedInstance.updatePropertyTotalPayment(property: (self.property)!)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentDetailSegue" {
            let detailView: PaymentDetailViewController = segue.destination as! PaymentDetailViewController
            selectedRow = table.indexPathForSelectedRow!.row
            detailView.arrayOfFrequencyPickerData = self.arrayOfFrequencyPickerData
            detailView.arrayOfExpenseCategoryData = self.arrayOfExpenseCategoryData
            detailView.arrayOfIncomeCategoryData = self.arrayOfIncomeCategoryData
            detailView.viewType = self.viewType
            
            detailView.property = self.property
            detailView.masterView = self
            detailView.viewType = self.viewType
            detailView.repeatPayment = self.repeatPayment
            let object = dataArray[selectedRow]
            detailView.detailItem = object
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func addReceipt(){
//        self.performSegue(withIdentifier: "paymentAddSegue", sender: self)
//    }
    
    func configData(){
        // retrieve data from firebase
        if(self.viewTitle == "Income") {
            self.viewType = "Incomes"
        } else if(self.viewTitle == "Expense"){
            self.viewType = "Expenses"
        } else {
            self.viewType = "Other"
        }
        if(self.tableViewPickID == 0){
            self.repeatPayment = false
            self.configPaymentData()
        }
        else {
            self.repeatPayment = true
            self.configRecurrentPaymentData()
        }

    }
    
    func configPaymentData(){
        let property_key = self.property?.ref?.key
        let query = self.dbReference?.child(self.viewType).queryOrdered(byChild: "propertyId").queryEqual(toValue: property_key)
        
        query?.observe(.value, with: { snapshot in
            var newItems: [Payment] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
            for item in snapshots {
                let p = Payment(snapshot: item,paymentType: self.viewType)
                newItems.append(p!)
            }
            self.dataArray = newItems
            self.table.reloadData()
            }
        })
    }
    
    func configRecurrentPaymentData(){
        let property_key = self.property?.ref?.key
        let query = self.dbReference?.child("recurrent_payments").child(self.viewType).queryOrdered(byChild: "propertyId").queryEqual(toValue: property_key)
        
        query?.observe(.value, with: { snapshot in
            var newItems: [Payment] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for item in snapshots {
                    let p = Payment(snapshot: item,paymentType: self.viewType)
                    newItems.append(p!)
                }
                self.dataArray = newItems
                self.table.reloadData()
            }
        })
    }
    
    func getCategoryFromFB(payment: Payment, paymentType: String, cell: PaymentTableViewCell){
        if((payment.categoryCode) != nil) {
            
            let paymentCategoryCode = payment.categoryCode
            var paymentCategory = "expenseCategory"
            if( paymentType == "Income"){
                paymentCategory = "incomeCategory"
            }
            self.dbReference?.child(paymentCategory).child(paymentCategoryCode!).observe(.value, with: { (categorySnapshot) in
                let snapValue = categorySnapshot.value as? NSDictionary
                let label = snapValue!["label"] as? String ?? ""
                let code = snapValue!["code"] as? String ?? ""
//                let value = snapValue!["value"] as? Float32
                
                cell.categoryLabel.text = label
                cell.imageView?.image = UIImage(named: code)
                self.table.reloadData()
//                self.category = categoryData(label: label, code: code, value: value)
            })
        }
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
