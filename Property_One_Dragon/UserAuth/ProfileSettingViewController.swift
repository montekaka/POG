//
//  ProfileSettingViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 12/29/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class ProfileSettingViewController: UIViewController {
    var dbReference: DatabaseReference?
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    @IBOutlet weak var userNamelLabel: UILabel!
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        try! Auth.auth().signOut();
        self.performSegue(withIdentifier: "backToHomePageSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setup()        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        if let user = Auth.auth().currentUser {
            //print(user.email ?? "gg")
            self.userNamelLabel.text =  user.email
        } else {
            self.userNamelLabel.text  = "gg"
        }
    }
    

}
