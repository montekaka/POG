//
//  ReceiptDetailViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 11/1/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class ReceiptDetailViewController: UIViewController {
    var masterView: ReceiptViewController!
    var detailItem : Receipt? {
        didSet {
            self.configureView()
        }
    }
    
    @IBOutlet weak var billAmountLabel : UILabel?
    @IBOutlet weak var paidDateLabel : UILabel?
    
    @IBOutlet weak var paymentFrequencyLabel: UILabel!
    
    @IBOutlet weak var isAnnualizedLabel: UILabel!
    
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
        self.configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureView()
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
