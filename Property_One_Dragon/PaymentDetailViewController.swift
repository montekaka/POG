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
    var detailItem : Payment? {
        didSet {
            self.configureView()
        }
    }
    
    @IBOutlet weak var billAmountLabel : UILabel?
    @IBOutlet weak var paidDateLabel : UILabel?
    
    @IBOutlet weak var paymentFrequencyLabel: UILabel!
    
    @IBOutlet weak var isAnnualizedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var paymentRecords: [paymentData] = []
    
    func configureView(){
        if let detail = self.detailItem {
            self.title = "Receipt"
            billAmountLabel?.text = "\(detail.amount ?? 0)"
            
            // date
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let dateString = formatter.string(from: detail.date!)
            paidDateLabel?.text = "\(dateString)"
            
            // frequency
            if((detail.frequency) != nil) {
                paymentFrequencyLabel?.text = detail.frequency?.label
            }

            // category
            if((detail.category) != nil) {
                categoryLabel?.text = detail.category?.label
            }
            
            // isAnnualized
            if(detail.isAnnualized == true) {
                isAnnualizedLabel?.text = "Annualized"
            } else {
                isAnnualizedLabel?.text = "Not Annualized"
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentRecords = detailItem!.get()
        // self.configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureView()
    }

    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PaymentDetailTableViewCellText", owner: self, options: nil)?.first as! PaymentDetailTableViewCellText
        cell.fieldLabel.text = paymentRecords[indexPath.row].label
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
