//
//  UserSignUpViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 12/31/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

import UIKit
import Firebase

class UserSignUpViewController: UIViewController {
    var dbReference: DatabaseReference?
    
    @IBOutlet weak var txtAuthStatus: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    deinit {
        // remove all firebase observers
        self.dbReference?.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // setup text field icon
        inputFieldIconConfig(textField: self.txtEmail, icon_name: "Email")
        inputFieldIconConfig(textField: self.txtPassword, icon_name: "Password")
    }

//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
                    
                    self.performSegue(withIdentifier: "signUpToAppSegue", sender: self)
                }
            }
            
        }
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
