//
//  ReceiptViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/30/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //var data: [String] = ["Row 1","Row 2","Row 3"]
    var selectedRow:Int = -1
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipts"
        let addReceiptButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceipt))
        self.navigationItem.rightBarButtonItem = addReceiptButton

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data.count
        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        return appDelegrate.receiptsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        let object = appDelegrate.receiptsArray[indexPath.row]
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "receiptTableCell")!
        cell.textLabel?.text = "\(object.amount ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        //let object = appDelegrate.receiptsArray[indexPath.row]
        self.performSegue(withIdentifier: "receiptDetailSegue", sender: nil)
        //print("\(object.amount ?? 0)")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiptDetailSegue" {
            let detailView: ReceiptDetailViewController = segue.destination as! ReceiptDetailViewController
            selectedRow = table.indexPathForSelectedRow!.row
            detailView.masterView = self
            
            let appDelegrate = UIApplication.shared.delegate as! AppDelegate
            let object = appDelegrate.receiptsArray[selectedRow]
            
            detailView.detailItem = object
            
            // print("\(object.amount ?? 0)")
        }
        
        
        //detailView.setText(t: data[selectedRow].address!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addReceipt(){
        self.performSegue(withIdentifier: "receiptAddSegue", sender: self)
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
