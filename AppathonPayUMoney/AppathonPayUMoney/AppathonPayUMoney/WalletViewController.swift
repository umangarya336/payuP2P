//
//  WalletViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class WalletViewController: BaseViewController, ConnectionManagerDelegate {
    
    @IBOutlet weak var txtAmount: UITextField!
    
    @IBOutlet weak var lblWalletAmount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }
    
     override func viewWillAppear(animated: Bool) {
        
        self .showLaodingPopup()
        
        var DataDict = ["userid" :appDelegate.strUsertID]
        
        var Path = "getWalletBalance"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 102)
        
        
    }
    
    
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    {
        
        
        var err: NSError?
        
        var dataobject : NSData = data as NSData
        
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
                
                self.lblWalletAmount.text = String(appDelegate.walletBalance)

            }
            
        })
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
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToWalletButtonClicked(sender: AnyObject) {
        
        txtAmount .resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: "Mode of payment", preferredStyle: .ActionSheet)
        
        // 2
        let debit = UIAlertAction(title: "Debit card", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let enterCardDetailViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("EnterCardDetailViewController") as EnterCardDetailViewController
            enterCardDetailViewController.Amount = self.txtAmount.text
            self.navigationController?.pushViewController(enterCardDetailViewController, animated: true)
            
        })
        let saved = UIAlertAction(title: "Saved Card", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let cardsViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("CardsViewController") as CardsViewController
            self.navigationController?.pushViewController(cardsViewController, animated: true)
            
        })
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        optionMenu.addAction(debit)
        optionMenu.addAction(saved)
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
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
