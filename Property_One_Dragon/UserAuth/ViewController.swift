//
//  ViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 10/23/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var dbReference: DatabaseReference?
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    
    @IBAction func btnSignIn(_ sender: Any) {
        if let email:String = txtEmail.text, let pass: String = txtPassword.text {
            
            Auth.auth().signIn(withEmail: email, password: pass) {
                (user, error) in
                if let error = error {
                    self.txtAuthStatus.text = error.localizedDescription;
                }
                
                if let user = user {
                    self.txtAuthStatus.text = "Signed in as " + user.email!;
                    self.txtEmail.text = nil;
                    self.txtPassword.text = nil;
                    
                    self.performSegue(withIdentifier: "signInToAppSegue", sender: self)
                }
            }
            
        }
    }
    
    @IBOutlet weak var txtAuthStatus: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Check if user is signed in, if so then update status text
        if let user = Auth.auth().currentUser {
            self.txtAuthStatus.text = "Signed in as " + user.email!;
        } else {
            self.txtAuthStatus.text = "";
        }
        // setup text field icon
        inputFieldIconConfig(textField: self.txtEmail, icon_name: "Email")
        inputFieldIconConfig(textField: self.txtPassword, icon_name: "Password")
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

