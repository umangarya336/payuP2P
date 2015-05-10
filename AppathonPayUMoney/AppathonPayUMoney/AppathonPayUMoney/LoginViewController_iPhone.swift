//
//  LoginViewController_iPhone.swift
//  AppathonPayUMoney
//
//  Created by Puneet on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class LoginViewController_iPhone:BaseViewController, ConnectionManagerDelegate  {
    
    
    @IBOutlet weak var txtUserNsme: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    
    var sender: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        
        txtUserNsme.layer.borderWidth = 1.0
        txtUserNsme.layer.borderColor = UIColor.lightBlueCustom().CGColor
        txtPassword.layer.borderWidth = 1.0
        txtPassword.layer.borderColor = UIColor.lightBlueCustom().CGColor
        
        var vwTitle =  UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:64))
        
        vwTitle.backgroundColor = UIColor.colorWithHexValue("#4cbce8")
        self.view .addSubview(vwTitle)
        
        var lblTitle = UILabel()
        
        lblTitle.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        lblTitle.text = "PayUMoney"
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.textColor = UIColor.whiteColor()
        self.view .addSubview(lblTitle)
        
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        println("here")
        
        
        self.performSegueWithIdentifier("SignUpViewController", sender: sender)
        
        
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        
        txtUserNsme.text = "honeylakhani28@gmail.com"
        txtPassword.text = "1234"
        
        
        self .showLaodingPopup()
        
        var DataDict = [ "email_id":txtUserNsme.text, "password" :txtPassword.text]
        
        var Path = "login"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
        
    }
    
    
    func showAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            
            self .performSegueWithIdentifier("SidebarMenuViewController", sender: self.sender)
            
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
 
    func showErrorAlert(strAlert:String)
    {
        let alert = UIAlertController(title: "Alert", message: strAlert, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
        }
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    {
        

        if(strData == "failure")
        {
            dispatch_async(dispatch_get_main_queue(),{
                
                self.showErrorAlert(strData)
                self.hideLoadingPoup()
                
            })
        }
        
        else
        {
            dispatch_async(dispatch_get_main_queue(),{
                
                appDelegate.strUsertID = strData
                self.hideLoadingPoup()
                
                self .performSegueWithIdentifier("SidebarMenuViewController", sender: self.sender)

                
                
            })
        }
            
    }
    
    
    func webServiceResponseFail(strError: NSString)
    {
        
        

        dispatch_async(dispatch_get_main_queue(),{
            print(strError)
            
            self .hideLoadingPoup()

            
            self.showErrorAlert(strError)

        })
        
    }
    
    
     func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
      
        textField.resignFirstResponder()
        
        return true
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
            
            
            let walletViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("WalletViewController") as WalletViewController
            self.navigationController?.pushViewController(walletViewController, animated: true)
            
            let transactionViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("TransactionViewController") as TransactionViewController
            self.navigationController?.pushViewController(transactionViewController, animated: true)
            

            
            var arrControllers : NSArray = NSArray(objects: homeViewController,profileViewController,walletViewController, cardsViewController, transactionViewController)
            
            var arrNames : NSArray = NSArray(objects: "Home", "MyProfile","Wallet","My Cards", "Transaction History")

            sidebarMenuVC.menuItemViewControllers = arrControllers as [AnyObject]
            
            sidebarMenuVC.menuItemNames = arrNames as [AnyObject]
            
        }
        
        if (segue.identifier  == "SignUpViewController") {
            
            var signVC : SignUpViewController = SignUpViewController()
            signVC = segue.destinationViewController as SignUpViewController
        }
        
}

}


