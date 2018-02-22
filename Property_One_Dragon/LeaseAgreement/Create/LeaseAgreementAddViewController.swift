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
    var leaseAgreement: LeaseAgreement?
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        // Save Button
        self.configRightBarButton()
    }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // detail
        if(self.arrayOfCellData[indexPath.row].code == "lease_detail"){
            self.performSegue(withIdentifier: "laDetailAddSegue", sender: nil)
        }
        
        if(self.arrayOfCellData[indexPath.row].code == "tenant"){
            self.performSegue(withIdentifier: "laTenantsSegue", sender: nil)
        }
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "laDetailAddSegue" {
            let controller = segue.destination as! leaseFormViewController
//            print("Property Id")
//            print(self.property?.ref?.key)
            self.setupLeaseAgreement()
            controller.leaseAgreementAddViewController = self
            ////controller.property = detailItem
            //print("hello world");
        }
        //laTenantsSegue
        if segue.identifier == "laTenantsSegue" {
            let controller = segue.destination as! TenantsViewController
            self.setupLeaseAgreement()
            controller.leaseAgreementAddViewController = self
            ////controller.property = detailItem
            //print("hello world");
        }
    }
    
    func setupLeaseAgreement(){
         if self.leaseAgreement == nil {
            let la = LeaseAgreement(propertyKey: (self.property?.ref?.key)!)
            self.leaseAgreement = la
        }
    }
    
    func configRightBarButton(){
        if(self.leaseAgreement != nil){
         self.setupSavingButton()
        }
    }
    
    func setupSavingButton(){
        let saveTextButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePost))
        self.navigationItem.rightBarButtonItem = saveTextButton
    }
    
    @objc func savePost(){
        print("start saving...")
        let post = self.leaseAgreement?.toAnyObject()
        //self.leaseAgreement?.detail
        self.dbReference = Database.database().reference()
        //print(post)
        let leaseAgreementRef = self.dbReference?.child("lease_agreement").childByAutoId()
        leaseAgreementRef?.setValue(post)
        
    }
    
    // laDetailAddSegue
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
