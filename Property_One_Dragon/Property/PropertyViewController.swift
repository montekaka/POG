//
//  PropertyViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/23/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class PropertyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    var data:[Property] = []
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    var dbReference: DatabaseReference?
    var dbHandle: DatabaseHandle?

    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Property"
        // add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        //self.navigationItem.leftBarButtonItem = editButtonItem
        
        // retrive data from firebase for current user
        self.configureDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // to handle update info from new/edit view
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureDatabase(){
        print("Start loading data...")
        let uid = Auth.auth().currentUser?.uid
        self.dbReference = Database.database().reference()
//        let query = self.dbReference?.child("properties").queryEqual(toValue: uid, childKey: "addedByUser")
//        let query = self.dbReference?.child("properties").queryOrdered(byChild: "addedByUser").queryEqual(toValue: uid)
    let query = self.dbReference?.child("properties").queryOrdered(byChild: "owners/uid").queryEqual(toValue: uid)
        
        self.dbHandle = query?.observe(.value, with: { snapshot in
            var newItems: [Property] = []
            // let name:String? = snapshot.value as? String
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for item in snapshots {
                    print("start adding property")
                    print(item)
                    let p = Property(snapshot: item)
                    //let property_id = p?.ref?.key
                    // update the property payment data here
                    newItems.append(p!)
                    
                }
                if (newItems.count == 0 ){
                    self.performSegue(withIdentifier: "propertyAddSegue", sender: self)
                }
                self.data = newItems
                self.table.reloadData()
            }
        })
        
    }
    
    @objc func addNote(){
        // handle the add button when it's in editing mode
        if (table.isEditing){
            return
        }
        // go to add view controller
        self.performSegue(withIdentifier: "propertyAddSegue", sender: self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let p = data[indexPath.row]
            FirebaseService.sharedInstance.deletePropertyPayments(property: p)
            p.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        //return appDelegrate.propertiesArray.count
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PropertyViewCustomCell
        let cell = Bundle.main.loadNibNamed("PropertyViewTableViewCell", owner: self, options: nil)?.first as! PropertyViewTableViewCell
        
//        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
//        let object = appDelegrate.propertiesArray[indexPath.row]
        let object = data[indexPath.row]
        cell.address!.text = object.address
//        cell.revenueLabel!.text =  "$\(object.totalIncome ?? 0)"
//        cell.expenseLabel!.text =  "$\(object.totalExpense ?? 0)"

        cell.revenueLabel!.text = object.getPaymentTextLabel(paymentType: "Income")
        cell.expenseLabel!.text = object.getPaymentTextLabel(paymentType: "Expense")
        cell.profitLoss!.text = object.getPaymentTextLabel(paymentType: "ProfitLoss")
        // map 
        if let address = object.address {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address){
                (placemarks, error) -> Void in
                if let firstPlacemark = placemarks?[0]{
                    let pm = MKPlacemark(placemark: firstPlacemark)
                    cell.mapView?.addAnnotation(pm)
                    let region = MKCoordinateRegionMakeWithDistance(pm.coordinate, 500, 500)
                    cell.mapView?.setRegion(region, animated: false)
                }
            }
        }
        
        //cell.textLabel?.text = data[indexPath.row].address
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "propertyDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return 400
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "propertyDetail" {
            let detailView: PropertyDetailViewController = segue.destination as! PropertyDetailViewController
            selectedRow = table.indexPathForSelectedRow!.row
            detailView.masterView = self
            
            //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
            //let object = appDelegrate.propertiesArray[selectedRow]
            let object = data[selectedRow]
            detailView.detailItem = object
            detailView.uid = object.uid            
            detailView.propertyID = object.ref?.key
        }

        
        //detailView.setText(t: data[selectedRow].address!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
