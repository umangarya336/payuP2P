//
//  SignUpViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController , ConnectionManagerDelegate {

    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var emailIDTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var sender: AnyObject?
    
    var segue1 : UIStoryboardSegue?
   
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func registerButtonClicked(sender: AnyObject) {
        
        
        emailIDTextfield .resignFirstResponder()
        passwordTextfield .resignFirstResponder()
        phoneTextfield .resignFirstResponder()
        confirmPasswordTextfield .resignFirstResponder()
        txtName .resignFirstResponder()
        
        
//        emailIDTextfield.text = "honeylakhani28@gmail.com"
        
        if(emailIDTextfield.text == "")
        {
            self.showErrorAlert("Please enter the EmailId")
        }
        else if(passwordTextfield.text == "")
        {
            self.showErrorAlert("Plese enter the password")
        }
            else if(phoneTextfield.text == "")
        {
            self.showErrorAlert("Plese enter the mobile number")
        }
            else if (txtName.text == "")
        {
            self.showErrorAlert("Plese enter your name")

        }
        else
        {
            self .showLaodingPopup()

        var DataDict = [ "email_id":emailIDTextfield.text, "password" :passwordTextfield.text,"number":phoneTextfield.text,"name":txtName.text]
        
        var Path = "signup"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
            
        }
        
    }
    
    
    
    // MARK: Textfields Delgate methods
    
    // Do any additional setup after loading the view.
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        
        if textField.tag<1010
        {
            let myField: UITextField = self.view.viewWithTag(textField.tag+1) as UITextField
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                myField.becomeFirstResponder()
                
                return
            })
            
        }
            
        else
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                textField.resignFirstResponder()
                return
            })
            
        }
        return true
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
    {
        
        if textField.tag == 1006
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
            })
            
        }
        else if textField.tag == 1007
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
            })
        }
        else if textField.tag == 1008
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
            })
        }
        else if textField.tag == 1009
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
            })
        }
        else
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                
            })
        }
        
        
        
        return true
        
    }
    
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    {
        if(strData == "email id already exist")
        {
            self.showErrorAlert(strData)

        }
        else
        {
            
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.showAlert(strData)
                self.hideLoadingPoup()
                
            })
            
            
        }
    }
    
    
    func webServiceResponseFail(strError: NSString)
    {
        dispatch_async(dispatch_get_main_queue(),{
            print(strError)
            
                        self.hideLoadingPoup()
            
            self .showErrorAlert(strError)
            
        })
        
    }
    
    
    
    func showErrorAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            self.call()

        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func call()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func showAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: "Registion is Successful", preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
           // self .performSegueWithIdentifier("SidebarMenuViewController", sender: self.sender)
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if (segue.identifier  == "SidebarMenuViewController") {
            
            var sidebarMenuVC : SidebarMenuViewController = SidebarMenuViewController()
            sidebarMenuVC = segue.destinationViewController as SidebarMenuViewController
            
            
            let homeViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController_iPhone") as HomeViewController_iPhone
            self.navigationController?.pushViewController(homeViewController, animated: true)
            
            let detailViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController_iPhone") as DetailViewController_iPhone
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
            let profileViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
            
            
            let cardsViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("CardsViewController") as CardsViewController
            self.navigationController?.pushViewController(cardsViewController, animated: true)
            
            var arrControllers : NSArray = NSArray(objects: homeViewController,homeViewController, cardsViewController, homeViewController, homeViewController, homeViewController, homeViewController)
            
            var arrNames : NSArray = NSArray(objects: "MyProfile","Wallet","My Cards", "My Contacts", "Pay", "Transaction History", "Feedback")
            
            sidebarMenuVC.menuItemViewControllers = arrControllers as [AnyObject]
            
            sidebarMenuVC.menuItemNames = arrNames as [AnyObject]
            
        }
        
        if (segue.identifier  == "SignUpViewController") {
            
            var signVC : SignUpViewController = SignUpViewController()
            signVC = segue.destinationViewController as SignUpViewController
        }
        
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
