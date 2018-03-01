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
    private var paymentTypeData = [pickerItemData]()
    private var lateFeePercentageData = [pickerItemData]()
    
    @IBOutlet weak var tableView: UITableView!
    var arrayOfCellData = [cellData]()
    var property : Property?
    var viewTitle: String!
    var leaseAgreement: LeaseAgreement?
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        // Save Button
        self.dbReference = Database.database().reference()
        self.configRightBarButton()
        self.getPickerOptionsFromFB(inputField: "payment_type")
        self.getPickerOptionsFromFB(inputField: "late_fee_percentage")
        
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
            controller.paymentTypeData = self.paymentTypeData
            controller.lateFeePercentageData = self.lateFeePercentageData
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
        //print(post)
        let leaseAgreementRef = self.dbReference?.child("lease_agreement")
        let lRef =  leaseAgreementRef?.childByAutoId()
        let rlid = lRef?.key
        let _ = lRef?.setValue(post)
        for tenant in (self.leaseAgreement?.tenants)! {
            let tenant_p = tenant.toAnyObject()
            leaseAgreementRef?.child(rlid!).child("tenants").childByAutoId().setValue(tenant_p)
        }
        
        //leaseAgreementRef?.setValue(post)
        
        
        
    }
    
    func getPickerOptionsFromFB(inputField: String!) {
        // get frequency from firebase
        
        _ = (self.dbReference?.child(inputField))?.queryOrdered(byChild: "value").observe(.value, with: { snapshot in
            var newItems: [pickerItemData] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for item in snapshots {
                    let snapshotValue = item.value as? Dictionary<String, AnyObject>
                    let p = pickerItemData(label: snapshotValue!["label"] as! String, code: snapshotValue!["code"] as! String, value: snapshotValue!["value"] as! Double)
                    newItems.append(p)
                }
                if(inputField == "payment_type"){
                    self.paymentTypeData = newItems;
                }
                if(inputField == "late_fee_percentage"){
                    self.lateFeePercentageData = newItems;
                }
            }
        })
    }

}
