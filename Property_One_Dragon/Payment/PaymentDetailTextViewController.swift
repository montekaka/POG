//
//  PaymentDetailTextViewController.swift
//  Property_One_Dragon
//
//  Created by Jia Chen on 12/20/17.
//  Copyright © 2017 BruinSquare. All rights reserved.
//

// UITextView Tutorial to hide keyboard
// https://www.youtube.com/watch?time_continue=181&v=oienPcLcbkA
import UIKit

class PaymentDetailTextViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        //self.textView.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        
        // to hide keyboards
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentDetailTextViewController.updateTextView(notification: )), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentDetailTextViewController.updateTextView(notification: )), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
