//
//  ReceiptDetailViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/1/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class PaymentDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var masterView: PaymentViewController!
    var detailItem : Payment?
    var property : Property?
    
    var arrayOfFrequencyPickerData: [frequencyData] = []
    var arrayOfExpenseCategoryData: [categoryData] = []
    var arrayOfIncomeCategoryData: [categoryData] = []
    
    @IBOutlet weak var tableView: UITableView!
    var paymentRecords: [paymentData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentRecords = detailItem!.get()
        // Do any additional setup after loading the view.
        // Remove extra empty cells in TableViewController
        tableView.tableFooterView = UIView()
        
        // add edit button
        let editPaymentButton =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPayment))
        self.navigationItem.rightBarButtonItem = editPaymentButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PaymentDetailTableViewCellText", owner: self, options: nil)?.first as! PaymentDetailTableViewCellText
        cell.fieldLabel.text = paymentRecords[indexPath.row].label
        cell.fieldValue.text = paymentRecords[indexPath.row].format        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentEditSegue" {
            let controller = segue.destination as! PaymentAddViewController
            controller.property = self.property
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
            controller.payment = self.detailItem
            controller.arrayOfFrequencyPickerData = self.arrayOfFrequencyPickerData
            controller.arrayOfCategoryData = self.arrayOfExpenseCategoryData // depends on income or expense            
            
        }
    }
    
    @objc func editPayment(){
        self.performSegue(withIdentifier: "paymentEditSegue", sender: self)
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
