//
//  LeaseAgreementViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 2/24/18.
//  Copyright © 2018 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class LeaseAgreementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var property : Property?
    // firebase
    var dbReference: DatabaseReference?
    var dbHandle: DatabaseHandle?
    var dataArray:[LeaseAgreement] = []
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dbReference = Database.database().reference()
        self.configureData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureData(){
        let property_key = self.property?.ref?.key
        let query = self.dbReference?.child("lease_agreement").queryOrdered(byChild: "propertyKey").queryEqual(toValue: property_key)
        
        query?.observe(.value, with: { snapshot in
            var newItems: [LeaseAgreement] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for item in snapshots {
                    let p = LeaseAgreement(snapshot: item)
                    //print("created new lease agreement...")
                    newItems.append(p!)
                }
                self.dataArray = newItems
                self.table.reloadData()
                print("reloaded...")
                
            }
        })
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let object = dataArray[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("LeaseAgreementTableViewCell", owner: self, options: nil)?.first as! LeaseAgreementTableViewCell
        
        cell.fromDateLabel.text = object.getFormattedString(valueType: "startDate")
        cell.rentAmountLabel.text = object.getFormattedString(valueType: "rentAmount")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
