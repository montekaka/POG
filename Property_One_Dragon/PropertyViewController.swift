//
//  PropertyViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/23/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit

class PropertyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    // var data:[Property] = []
    var selectedRow:Int = -1
    var newRowText:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Properties"
    
        // add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        // load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // to handle update info from new/edit view
        super.viewWillAppear(animated)
//        if selectedRow == -1 {
//            return
//        }
//        
//        // data[selectedRow].address = newRowText
//
//        if newRowText == "" {
//            //data.remove(at: selectedRow)
//            
//        }
        
        table.reloadData()
        // save()
    }
    
    func addNote(){
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
        //data.remove(at: indexPath.row)
        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        appDelegrate.propertiesArray.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        // save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        return appDelegrate.propertiesArray.count
        //return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let appDelegrate = UIApplication.shared.delegate as! AppDelegate
        
        let object = appDelegrate.propertiesArray[indexPath.row]
        cell.textLabel!.text = object.address
        //cell.textLabel?.text = data[indexPath.row].address
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "propertyDetail", sender: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "propertyDetail" {
            let detailView: PropertyDetailViewController = segue.destination as! PropertyDetailViewController
            selectedRow = table.indexPathForSelectedRow!.row
            detailView.masterView = self
            
            let appDelegrate = UIApplication.shared.delegate as! AppDelegate
            let object = appDelegrate.propertiesArray[selectedRow]
            detailView.detailItem = object
        }

        
        //detailView.setText(t: data[selectedRow].address!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
