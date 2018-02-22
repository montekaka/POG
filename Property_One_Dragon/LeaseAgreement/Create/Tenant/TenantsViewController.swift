//
//  TenantsViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/21/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit
//import Firebase

class TenantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    weak var leaseAgreementAddViewController : LeaseAgreementAddViewController?
    
    //var tenants:[LeaseAgreementTenant] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTenant))
        self.navigationItem.rightBarButtonItem = addButton
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        //print(self.leaseAgreementAddViewController?.leaseAgreement?.tenants)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.leaseAgreementAddViewController?.leaseAgreement?.tenants?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TenantsTableViewCell", owner: self, options: nil)?.first as! TenantsTableViewCell
        let tenant = self.leaseAgreementAddViewController?.leaseAgreement?.tenants![indexPath.row]
        cell.nameLabel.text = tenant?.getFullName()
        cell.phoneNumberLabel.text = tenant?.getPhoneNumber()
        return cell
    }
    
    @objc func addTenant(){
        // go to add view controller
        self.performSegue(withIdentifier: "tenantNewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tenantNewSegue" {
            let controller = segue.destination as! TenantNewViewController
            controller.leaseAgreementAddViewController = self.leaseAgreementAddViewController
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
