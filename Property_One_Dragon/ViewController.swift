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
    
    @IBAction func btnCreateUser(_ sender: Any) {
        if let email:String = txtEmail.text, let pass: String = txtPassword.text {

            Auth.auth().createUser(withEmail: email, password: pass) {
                (user, error) in
                if let error = error {
                    self.txtAuthStatus.text = error.localizedDescription;
                }
                
                if let user = user {
                    self.txtAuthStatus.text = "Signed in as " + user.email!;
                    self.txtEmail.text = nil;
                    self.txtPassword.text = nil;
                    
                    // save user to database
                    self.dbReference = Database.database().reference()
                    self.dbReference?.child("users").child(user.uid).setValue(["uid":user.uid])
                }
            }
            
        }
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
                }
            }
            
        }
    }
    @IBAction func btnSignOut(_ sender: Any) {
        try! Auth.auth().signOut();
        
        self.txtAuthStatus.text = "Signed Out";
        self.txtEmail.text = nil;
        self.txtPassword.text = nil;
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
            self.txtAuthStatus.text = "Signed Out";
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

