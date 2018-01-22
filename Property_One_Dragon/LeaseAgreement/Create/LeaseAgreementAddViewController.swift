//
//  LeaseAgreementAddViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 1/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class LeaseAgreementAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // firebase
    var dbReference: DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfCellData = [cellData]()
    var property : Property?
    var viewTitle: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCellData = newLeaseAgreementCellData;
        // Do any additional setup after loading the view.
        self.title = "New Agreement"
        tableView.tableFooterView = UIView()
        //self.title = self.viewTitle;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("LAAddTableViewCell", owner: self, options: nil)?.first as! LAAddTableViewCell
        cell.label.text = arrayOfCellData[indexPath.row].label
        return cell
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
