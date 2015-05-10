//
//  ProfileViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController , ConnectionManagerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reenterPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.hidden = true
        reenterPassword.hidden = true
        updateButton.hidden = true
        name.enabled = false
        phone.enabled = false
        email.enabled = false
        
        self .showLaodingPopup()
        
        var DataDict = [ "userid": appDelegate.strUsertID]
        
        var Path = "getUserDetails"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    {
        
        
        if(tag == 101)
        {
        var err: NSError?
        
        var dataobject : NSData = data as NSData
        
        var json = NSJSONSerialization.JSONObjectWithData(dataobject, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSArray
        //
        //        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
        if(err != nil) {
            println(err!.localizedDescription)
            let jsonStr = NSString(data: dataobject, encoding: NSUTF8StringEncoding) as String
            println("Error could not parse JSON: '\(jsonStr)'")
        }
            
        else
        {
            
            
            var dictEvents = NSDictionary()
            
            
            if (json.isKindOfClass(NSArray))
            {
                if let topApps = json.objectAtIndex(0) as? NSDictionary {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self .hideLoadingPoup()
                        self.name.text =  topApps.objectForKey("name") as String
                        self.phone.text =  topApps.objectForKey("number") as String
                        self.email.text =  topApps.objectForKey("email_id") as String
                        
                    })
          
                    
                }
            }
        }
            
        }
        
        else
        {
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self .hideLoadingPoup()
            self.showAlert(strData)
                
                
            })
            
            

        }
    }
    
    
    func webServiceResponseFail(strError: NSString)
    {
        
        self.showAlert(strError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedClicked(sender: AnyObject) {
        
        
        if (segmentedControl.selectedSegmentIndex == 0)
        {
            name.enabled = false
            phone.enabled = false
            email.enabled = false
            password.hidden = true
            reenterPassword.hidden = true
            updateButton.hidden = true
        }
        else
        {
            name.enabled = true
            phone.enabled = false
            email.enabled = false
            password.hidden = false
            reenterPassword.hidden = false
            updateButton.hidden = false
        }
    }
    
    
    func showAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func updateClicked(sender: AnyObject) {
        
        if reenterPassword.text == password.text
        {
            
            
            self .showLaodingPopup()
            
            var DataDict = [ "userid":appDelegate.strUsertID, "email_id" :email.text,"name": name.text,"password":password.text,"number":phone.text]
            
            var Path = "updateUserDetails"
            
            var objConnectionManager :ConnectionManager = ConnectionManager()
            objConnectionManager.delegate = self
            objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 103)
            
        }
        else
        {
            var alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "Password does not match"
            alert.delegate = self
            alert.addButtonWithTitle("Cancle")
            alert.show()
            
        }
    }
    
     func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    
     {
        textField .resignFirstResponder()
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
