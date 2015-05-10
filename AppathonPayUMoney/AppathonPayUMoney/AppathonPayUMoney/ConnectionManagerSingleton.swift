//
//  AppDelegate.swift
//  AppathonPayUMoney
//
//  Created by Puneet on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import Foundation

class ConnectionManagerSingleton: NSObject {
    
    var sessionForBlock : NSURLSession?
    var serviceTag:Int!

    //1
    class var sharedInstance: ConnectionManagerSingleton {
        //2
        struct Singleton {
            //3
            static let instance = ConnectionManagerSingleton()
        }
        //4
        return Singleton.instance
    }
    
    
    func callTheServiceBlockWithAction(ParaDict: NSDictionary, strPath:String, tag:Int, httpMethod:String, completionHandler: (Int, AnyObject!, NSError!)->()) ->() {
        
        
        
        self.serviceTag = tag
        
        var strURL =  "\(BaseURL)" + "\(strPath)"
        
        var request = NSMutableURLRequest(URL: NSURL(string: strURL)!)
        
        
        self.sessionForBlock = NSURLSession.sharedSession()
        request.HTTPMethod = httpMethod
        var err: NSError?
        
        if httpMethod == "POST" {
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(ParaDict, options: nil, error: &err)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = self.sessionForBlock?.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //            dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            dispatch_async(dispatch_get_main_queue(),{
                if let err123 = error{
                    completionHandler(self.serviceTag, nil, error)
                }
                else {
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding) as String
                    
                    var date = NSDate()
                    println(strData)
                    var err: NSError?
                    
                    if(strData == "404 Not Found: Requested route ('eventappservices.mybluemix.net') does not exist.\n")
                    {
                        completionHandler(self.serviceTag, strData, nil)
                        return;
                    }
                    else if (strData == "503 Service Unavailable: The server is not available now. Please try your request later.\n")
                    {
                        completionHandler(self.serviceTag, strData, nil)
                        return
                    }
                    else if(strData == "")
                    {
                        completionHandler(self.serviceTag, strData, nil)
                        return
                    }
                    else
                    {
                        var jsonError : NSError?
                        var dataobject : NSData = data as NSData
                        
                        let jsonResult : AnyObject? = NSJSONSerialization.JSONObjectWithData(dataobject, options: nil, error: &jsonError)
                        
                        if let error = jsonError{
                            println("error occurred in parsing: \(error.localizedDescription)")
                            completionHandler(self.serviceTag, nil, jsonError)
                        }
                        else if let jsonDict = jsonResult as? NSDictionary{
                            println("json is dictionary \(jsonDict)")
                            completionHandler(self.serviceTag, jsonDict, nil)
                        }
                        else if let jsonArray = jsonResult as? NSArray{
                            println("json is an array: \(jsonArray)")
                            completionHandler(self.serviceTag, jsonArray, nil)
                        }
                        completionHandler(self.serviceTag, data, nil)
                    }
                }
            })
        })
        
        task?.resume()
    }
    
    
    func dismissSessionRequest() {
//        if self.sessionForBlock.is
        self.sessionForBlock?.invalidateAndCancel()
    }
}

