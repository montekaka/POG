//
//  LeaseAgreementViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/25/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit

class LeaseAgreementShowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var agreement: LeaseAgreement?
    
    @IBOutlet weak var table: UITableView!
    var tableData: [tableCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableData = (self.agreement?.toTableCells())!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        //return appDelegrate.propertiesArray.count
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("LeaseAgreementShowTableViewCell", owner: self, options: nil)?.first as! LeaseAgreementShowTableViewCell
        let object = self.tableData[indexPath.row]
        cell.filedLabel.text = object.label
        cell.fieldValueLabel.text = object.value
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
