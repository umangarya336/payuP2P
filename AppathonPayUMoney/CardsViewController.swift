//
//  CardsViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class CardsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate , ConnectionManagerDelegate{
    
    @IBOutlet weak var tblCards: UITableView!
    var btn = UIButton()
    
    var Amount : String?
    
    var arrCard : NSMutableArray = NSMutableArray()

    
    override func viewDidDisappear(animated: Bool) {
        
        btn .removeFromSuperview()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        
        
        self .showLaodingPopup()
        
        var DataDict = [ "userid": appDelegate.strUsertID]
        
        var Path = "fetchCardDetails"
        
        var objConnectionManager :ConnectionManager = ConnectionManager()
        objConnectionManager.delegate = self
        objConnectionManager.callTheServiceMethod(DataDict, strPath: Path, tag: 101)
        

        
        btn.frame = CGRectMake(300, 600, 50, 50)
        btn.setImage(UIImage(named: "add.png"), forState:UIControlState.Normal)
        btn .setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "addButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        appDelegate.window!.addSubview(btn)
        

        // Do any additional setup after loading the view.
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
                        
                        var objCard: CardBO = CardBO()
                        objCard.cardNumber = topApps.objectForKey("card_number") as String
                        objCard.name = topApps.objectForKey("card_name") as String
                        objCard.expiryMonth = topApps.objectForKey("expiry_detail") as String
                        
                        self.arrCard.addObject(objCard)
                        
                    }
                    
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self .hideLoadingPoup()
                
                self.tblCards .reloadData()
                
                        
            
               // self.tblTransaction .reloadData()
                
                
            })
            
        }
        
    }
    


func webServiceResponseFail(strError: NSString)
{
    
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButtonClicked()
    {
        let addCardsViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("AddCardsViewController") as AddCardViewController
        self.navigationController?.pushViewController(addCardsViewController, animated: true)
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrCard.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
           let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as cardCell
        
        var objCard : CardBO = self.arrCard .objectAtIndex(indexPath.row) as CardBO
        cell.cardHolder.text = "Aushotush"
        cell.cardHolder.text = objCard.name
        cell.lblCardNumber.text = objCard.cardNumber
        cell.lblExpiry.text =   "Valid Upto: " + objCard.expiryMonth +  " " + objCard.expiryYear
        
        //cell.textLabel?.text = "2342 2354 2354 5685"
        //cell.detailTextLabel?.text = "Aushotush"
        
        //cardCell()
        
        return cell
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
