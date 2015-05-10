//
//  EnterCardDetailViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class EnterCardDetailViewController: BaseViewController, UITextFieldDelegate, ConnectionManagerDelegate {
    
    var Amount : Int?

    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtCardNo: UITextField!
    
    var strMonth : String = ""
    var strYear : String = ""

    @IBOutlet weak var expirydate: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    @IBAction func btnpayCalled(sender: UIButton) {
        
        txtCardNo .resignFirstResponder()
        txtCVV .resignFirstResponder()
        
        
        self .showLaodingPopup()
        
//        var DataDict = [ "userid":appDelegate.strUsertID, "card_number" :txtCardNo.text, "expiry_month" :strMonth, "expiry_year" :strYear, "card_name" :"","card_bank":""]
        
        var DataDict = [ "userid":appDelegate.strUsertID, "amount":Amount!,"description":""]
        
        var Path = "moneyToWallet"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
        
    }
    
    func showAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    {
        
        dispatch_async(dispatch_get_main_queue(),{
            
            self.hideLoadingPoup()
            self.showAlert(strData)
            
            
        })

    }
    
    
    func webServiceResponseFail(strError: NSString)
    {
        dispatch_async(dispatch_get_main_queue(),{
            
            self.hideLoadingPoup()
            self.showAlert(strError)
            
            
        })


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if  (textField == expirydate)
        {
            println("entered")
            expirydate.text = ""
            var datePickerView  : UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
        
    {
        textField .resignFirstResponder()
        return true
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        expirydate.text = dateFormatter.stringFromDate(sender.date)
        dateFormatter.dateFormat = "MMM"
        strMonth = dateFormatter.stringFromDate(sender.date)
        dateFormatter.dateFormat = "yyyy"
        strYear = dateFormatter.stringFromDate(sender.date)


    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
