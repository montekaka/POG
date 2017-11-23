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
    
    @IBOutlet weak var tableView: UITableView!
    var paymentRecords: [paymentData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentRecords = detailItem!.get()
        // Do any additional setup after loading the view.
        // Remove extra empty cells in TableViewController
        tableView.tableFooterView = UIView()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
