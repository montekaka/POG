//
//  PaymentDetailTextViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 12/20/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

// UITextView Tutorial to hide keyboard
// https://www.youtube.com/watch?time_continue=181&v=oienPcLcbkA
// pass data back to AddViewController
// https://stackoverflow.com/questions/28476036/passing-variable-back-to-parent-in-swift
import UIKit

class PaymentDetailTextViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    weak var paymentAddViewController : PaymentAddViewController?
    var payment: Payment? // if we have payment then it's edit mode
    var savingButton: Bool?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        //self.textView.resignFirstResponder()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        if(payment != nil){
            self.textView.text = payment?.paymentNotes 
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        // Save Button
        self.configRightBarButton()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.lightGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white
    }
    
    @objc func updateTextView(notification:Notification){
        // handle text is getting too long that keyboard is overlap on it
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide{
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configRightBarButton(){
        if(self.savingButton == true){
            self.setupSavingButton()
        } else {
            let editTextButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTextViewButtonPressed))
            self.navigationItem.rightBarButtonItem = editTextButton
        }
    }
    
    func setupSavingButton(){
        let saveTextButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveText))
        self.navigationItem.rightBarButtonItem = saveTextButton
        self.textView.isEditable = true
        self.setupDoneButtonToKeyboard()
        self.textView.becomeFirstResponder()
    }
    
    @objc func saveText(){
        if(payment != nil) {
            // edit
            self.payment?.paymentNotes = self.textView.text
            let post = self.payment!.toAnyObject(repeatPayment: true)
            self.payment?.ref?.updateChildValues(post as! [AnyHashable : Any])
            self.paymentAddViewController?.paymentNotes = self.textView.text
        } else {
            // new
            self.paymentAddViewController?.paymentNotes = self.textView.text
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editTextViewButtonPressed(){
        self.setupSavingButton()
    }
    
    @objc func hideKeyboard(){
        // to hide keyboards
        self.textView.endEditing(true)
    }
    
    func setupDoneButtonToKeyboard(){
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(hideKeyboard))
        
        toolbarDone.setItems([done], animated: false)
        self.textView.inputAccessoryView = toolbarDone
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
