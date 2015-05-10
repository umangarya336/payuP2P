//
//  TransactionViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class TransactionViewController: BaseViewController, UITableViewDataSource , UITableViewDelegate, ConnectionManagerDelegate{
    @IBOutlet weak var tableViewInstance: UITableView!
    
    var arrTransactions : NSMutableArray = NSMutableArray()

    @IBOutlet weak var tblTransaction: UITableView!
    
    
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Amount: UILabel!
    
    @IBOutlet weak var Date: UILabel!
    var dateLabel: UILabel!
    var nameLabel : UILabel!
    var descriptionLabel : UILabel!
    var amountLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInstance.delegate = self
        tableViewInstance.dataSource = self
        var logoutButton = UIBarButtonItem(title: "Sign out", style: UIBarButtonItemStyle.Plain, target: self, action: "signOutClicked")
        self.navigationItem.rightBarButtonItem = logoutButton
        self.navigationItem.title = "Home"
        // Do any additional setup after loading the view.
        
        
        self .showLaodingPopup()
        
        var DataDict = ["userid" : "tftp9116"]
        
        var Path = "fetchTransactionDetails"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
        
    }
    
    func signOutClicked()
    {
        
    
        
      //  self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
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
                
                for (var index = 0; index < json.count; index++) {
                    
                    
                    var arrJson : NSMutableArray?
                    
//                    let topApps : NSArray = arrJson?.objectAtIndex(index) as NSDictionary
                    
                    if let topApps = json.objectAtIndex(index) as? NSDictionary {
                        
                        var objTransaction: TransactionBO = TransactionBO()
                        objTransaction.strFrom = topApps.objectForKey("from") as String
                        objTransaction.strTo = topApps.objectForKey("to") as String
                        objTransaction.intBalance = topApps.objectForKey("balance") as NSInteger
                       // objTransaction.strDate = topApps.objectForKey("date") as String

                        self.arrTransactions.addObject(objTransaction)

                    }
                    
                }

            }
        
        dispatch_async(dispatch_get_main_queue(),{
            
            self .hideLoadingPoup()
            
            self.tblTransaction .reloadData()

            
        })
    }
        
    }
    
    
    func webServiceResponseFail(strError: NSString)
    {
        
        dispatch_async(dispatch_get_main_queue(),{
            print(strError)
            
            self.hideLoadingPoup()
            
            
            self.showErrorAlert(strError)
            
        })
        
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
    
    
    
//    
//    func signOutClicked()
//    {
//        let loginViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController_iPhone") as LoginViewController_iPhone
//        self.navigationController?.pushViewController(loginViewController, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.arrTransactions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TransactionCell
        
        var objTransaction: TransactionBO
        objTransaction = self.arrTransactions .objectAtIndex(indexPath.row) as TransactionBO
        
        cell.lblAmount.text =  String(objTransaction.intBalance) +  " Rs."
        cell.lblName.text = objTransaction.strFrom
        cell.lblToName.text = objTransaction.strTo
    
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
