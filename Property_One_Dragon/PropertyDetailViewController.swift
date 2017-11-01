//
//  PropertyDetailViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/25/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import MapKit

class PropertyDetailViewController: UIViewController {
    var masterView: PropertyViewController!
    
    @IBOutlet weak var addressLabel : UILabel?
    
    @IBOutlet weak var mapView : MKMapView?
    
    var detailItem : Property? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView(){
        
        if let detail = self.detailItem{
            self.title = detail.address
            addressLabel?.text = detail.address
            
            if let address = detail.address {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address){
                    (placemarks, error) -> Void in
                    if let firstPlacemark = placemarks?[0]{
                        let pm = MKPlacemark(placemark: firstPlacemark)
                        self.mapView?.addAnnotation(pm)
                        let region = MKCoordinateRegionMakeWithDistance(pm.coordinate, 2000, 2000)
                        self.mapView?.setRegion(region, animated: false)
                    }
                }
            }
        }
        
        //        if let p = Property(address: addressField.text!) {
        //            print("Created a property: \(p.address ?? "gg")")
        //        } else {
        //            print("Error creating property")
        //        }
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        // add edit button
        let editPropertyButton =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProperty))
        self.navigationItem.rightBarButtonItem = editPropertyButton
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "propertyEditSegue" {
            let controller = segue.destination as! PropertyAddViewController
            controller.property = detailItem
        }
    }

    func editProperty(){
        self.performSegue(withIdentifier: "propertyEditSegue", sender: self)
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
