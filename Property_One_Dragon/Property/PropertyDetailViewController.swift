//
//  PropertyDetailViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/25/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import MapKit

class PropertyDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var masterView: PropertyViewController!
    @IBOutlet weak var tableView: UITableView!
    var selectedPropertyReceiptRow:Int = -1

    var detailItem : Property?
    var propertyTableCells:[tableCellData] = []
    var paymentData:[Payment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.propertyTableCells = (self.detailItem?.get())!
        
        // textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        // add edit button
        let editPropertyButton =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProperty))
        self.navigationItem.rightBarButtonItem = editPropertyButton
        
        // table view config
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.propertyTableCells = (self.detailItem?.get())!
        tableView.reloadData()
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
        
        if segue.identifier == "propertyAddPaymentSegue" {
            let controller = segue.destination as! PaymentAddViewController
            controller.property = detailItem
        }
        
        if segue.identifier == "propertyPaymentTableSegue" {
            let controller = segue.destination as! PaymentViewController
            controller.property = detailItem
        }
        
//        if segue.identifier == "propertyPaymentDetailSegue" {
//            let detailView: PaymentDetailViewController = segue.destination as! PaymentDetailViewController
//            selectedPropertyReceiptRow = receiptTable.indexPathForSelectedRow!.row
//
//
//            let appDelegrate = UIApplication.shared.delegate as! AppDelegate
//            let receiptsArray = appDelegrate.receiptsArray.filter{
//                $0.property_id == detailItem?.id
//            }
//
//            let object = receiptsArray[selectedPropertyReceiptRow]
//
//            detailView.detailItem = object
//            
//            // print("\(object.amount ?? 0)")
//        }
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
            }
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("PropertyDetailTableViewCellText", owner: self, options: nil)?.first as! PropertyDetailTableViewCellText
            cell.label.text = propertyTableCells[indexPath.row].label
            cell.value.text = propertyTableCells[indexPath.row].value
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let p = propertyTableCells[indexPath.row]

        if (p.cellType == "CellWithButton") {
            return 100
        } else {
            return 60
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
