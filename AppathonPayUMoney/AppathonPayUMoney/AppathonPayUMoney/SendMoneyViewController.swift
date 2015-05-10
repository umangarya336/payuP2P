//
//  SendMoneyViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class SendMoneyViewController: BaseViewController, UITextFieldDelegate, ConnectionManagerDelegate,ABPeoplePickerNavigationControllerDelegate {

    @IBOutlet weak var recipientContact: UITextField!
    @IBOutlet weak var recipientEmail: UITextField!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var OTP: UITextField!
    @IBOutlet weak var des: UITextField!
    
    var addressBookController : ABPeoplePickerNavigationController!


    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        recipientContact.delegate = self
        recipientEmail.delegate = self
        amount.delegate = self
        OTP.delegate = self
        OTP.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnContactClicked(sender: AnyObject) {
        

        self .showAddressBook()
//

    }
    
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        
      
        let name = ABRecordCopyCompositeName(person).takeRetainedValue()
        let nam = name as NSString
        var phonesRef: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValueRef
        var phonesArray  = Array<Dictionary<String,String>>()
        for var i:Int = 0; i < ABMultiValueGetCount(phonesRef); i++ {
            var label: String = ABMultiValueCopyLabelAtIndex(phonesRef, i).takeRetainedValue() as NSString as String
            var value: String = ABMultiValueCopyValueAtIndex(phonesRef, i).takeRetainedValue() as NSString as String
            
            println("Phone: \(label) = \(value)")
            
            var phone = [label: value]
            phonesArray.append(phone)
            if label == "_$!<Home>!$_"
            {
                recipientContact.text = value
            }
            else if label == "_$!<Other>!$_"
            {
                recipientContact.text = value
            }
            else if label == "_$!<Mobile>!$_"
            {
                recipientContact.text = value
            }
            else if label == "_$!<Main>!$_"
            {
                recipientContact.text = value
            }
            
        }
        
        var emailsRef: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() as ABMultiValueRef
        var emailsArray = Array<Dictionary<String, String>>()
        for var i:Int = 0; i < ABMultiValueGetCount(emailsRef); i++ {
            var label: String = ABMultiValueCopyLabelAtIndex(emailsRef, i).takeRetainedValue() as NSString as String
            var value: String = ABMultiValueCopyValueAtIndex(emailsRef, i).takeRetainedValue() as NSString as String
            
            println("Email: \(label) = \(value)")
            
            var email = [label: value]
            emailsArray.append(email)
            if label == "_$!<Work>!$_"
            {
                recipientEmail.text = value
            }
            else if label == "_$!<Home>!$_"
            {
                recipientEmail.text = value
            }
        }
        
        
    }
    
    
    func showAddressBook()
    {
        addressBookController = ABPeoplePickerNavigationController()
        addressBookController.peoplePickerDelegate = self
        self.presentViewController(addressBookController, animated: false, completion: nil)
        
    }
    
    

    
    @IBAction func actionButtonClicked(sender: AnyObject) {
        
    
        self .showLaodingPopup()
        
        var intAmount : Int = amount.text.toInt()!

         recipientContact.text .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        
       recipientContact.text = recipientContact.text.stringByReplacingOccurrencesOfString("\\s", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        recipientContact.text = recipientContact.text .stringByReplacingOccurrencesOfString("  ", withString: "", options: nil, range: nil)

        
        recipientContact.text = recipientContact.text .stringByReplacingOccurrencesOfString("(", withString: "", options: nil, range: nil)

        recipientContact.text = recipientContact.text .stringByReplacingOccurrencesOfString(")", withString: "", options: nil, range: nil)

        
        recipientContact.text = recipientContact.text .stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil)

        println(recipientContact.text)

        
        var DataDict = ["userid" :appDelegate.strUsertID, "number" : recipientContact.text, "amount" :intAmount]
        
        var Path = "sendBalance"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
        

    }
    
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    {
        var err: NSError?
        
        var dataobject : NSData = data as NSData
        
        
        
        if(tag==101)
        {
        dispatch_async(dispatch_get_main_queue(),{
            
            self.hideLoadingPoup()
            
            if(strData == "user id of getter not received")
            {
                self.showErrorAlert("This mobile No doesn't have the PayUMoney account")

            }
            
            else
            {
            
            self.showAlert("Money Trancation to the wallet Successfully")
            }
            
            
        })
            
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(),{
                var json = NSJSONSerialization.JSONObjectWithData(dataobject, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSArray
                self.hideLoadingPoup()
                if err != nil
                {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: dataobject, encoding: NSUTF8StringEncoding) as String
                    println("Error could not parse JSON: '\(jsonStr)'")
                }
                else
                {
                    var dicvar = NSDictionary()
                    dicvar = json.objectAtIndex(0) as NSDictionary
                    println(dicvar)
                    appDelegate.walletBalance = dicvar.objectForKey("balance") as Int
                }
                
            })

        }
    }
    
    
    func showErrorAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            
            
       
            
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func showAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
       
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    func webServiceResponseFail(strError: NSString)
    {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
