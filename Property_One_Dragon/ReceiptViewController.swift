//
//  ReceiptViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/30/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var data: [String] = ["Row 1","Row 2","Row 3"]
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipts"
        let addReceiptButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceipt))
        self.navigationItem.rightBarButtonItem = addReceiptButton

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "receiptTableCell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(data[indexPath.row])")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addReceipt(){
        
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
