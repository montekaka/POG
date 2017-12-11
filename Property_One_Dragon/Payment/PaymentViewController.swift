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
    var viewType: String!
    var dataArray:[Payment] = []

    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewTitle
//        let addReceiptButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceipt))
//        self.navigationItem.rightBarButtonItem = addReceiptButton

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //property?.ref
        // retrieve data from firebase
        if(self.viewTitle == "Income") {
            self.viewType = "Incomes"
        } else if(self.viewTitle == "Expense"){
            self.viewType = "Expenses"
        } else {
            self.viewType = "Other"
        }
        self.property?.ref?.child(self.viewType).observe(.value, with: { snapshot in
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
        
        // table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data.count
//        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegrate.receiptsArray.count
       return dataArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        //let object = appDelegrate.receiptsArray[indexPath.row]
        
        let object = dataArray[indexPath.row]
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentTableCell")!
        cell.textLabel?.text = "\(object.amount ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentDetailSegue" {
            let detailView: PaymentDetailViewController = segue.destination as! PaymentDetailViewController
            selectedRow = table.indexPathForSelectedRow!.row
            detailView.masterView = self
            
            //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
            //let object = appDelegrate.receiptsArray[selectedRow]
            
            let object = dataArray[selectedRow]
            detailView.detailItem = object
            
            // print("\(object.amount ?? 0)")
        }
        
        
        //detailView.setText(t: data[selectedRow].address!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addReceipt(){
        self.performSegue(withIdentifier: "paymentAddSegue", sender: self)
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
