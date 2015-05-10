//
//  ConnectionManager.swift
//  WorkflowPrototype
//
//  Created by Manoj Kumar Das on 13/03/15.
//  Copyright (c) 2015 Manoj K Das. All rights reserved.
//

import UIKit

@objc protocol ConnectionManagerDelegate
{
    /// This will return response from webservice if request successfully done to server
    func webServiceResponseSuccess(data:AnyObject, tag :Int, strData: String)
    
    /// This is for Fail request or server give any error
    optional func webServiceResponseFail(strError: NSString)
}

public class ConnectionManager: NSObject,NSURLConnectionDelegate
{
    enum TypeOfMethod : Int{
        case GET = 1
        case POST = 2
        case JSON = 3
        case IMAGE = 4
    }
    
    public enum IdentiFier : Int{
        case APP_LOGIN_ID = 100
        case APP_CREATE_RQUEST_ID
        case APP_MY_REQUESTS_ID
        case APP_REQUESTS_FOR_ME_ID
    }
    
    //Time Out interval will be 2 minutes
    let timeinterval:Int = 120
    private var objUrlConnection:NSURLConnection?
    private var strURL:NSString!
    public  var responseData:NSData!
    var delegate:ConnectionManagerDelegate?
    public var ApiIdentifier:NSString!=""
    public var serviceTag:Int!
    var sessionForBlock : NSURLSession?

        
    // MARK: Method Web API
    
    func callTheServiceMethod(ParaDict: NSDictionary, strPath:String, tag:Int)
    {
        
        self.serviceTag = tag
        
        var strURL =  "\(BaseURL)" + "\(strPath)"
        
        print("the parameter is \(ParaDict.description)")
        
        var request = NSMutableURLRequest(URL: NSURL(string: strURL)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var params = ParaDict as Dictionary<String, AnyObject>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Responsen: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding) as String
            
            var date = NSDate()
            println(strData)
            var err: NSError?
            
            if(strData == "404 Not Found: Requested route ('eventappservices.mybluemix.net') does not exist.\n")
            {
                self.delegate?.webServiceResponseFail!(strData)
                
                return;
            }
            else if (strData == "503 Service Unavailable: The server is not available now. Please try your request later.\n")
            {
                
                self.delegate?.webServiceResponseFail!(strData)
                
                return
            }
            else if(strData == "")
            {
                self.delegate?.webServiceResponseFail!(strData)
                
                return
            }
            
            else
            {
          
                self.delegate?.webServiceResponseSuccess(data, tag: self.serviceTag, strData: strData)
            
            }
            
            //        var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
            //
            //        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            //        if(err != nil) {
            //            println(err!.localizedDescription)
            //            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding) as String
            //            println("Error could not parse JSON: '\(jsonStr)'")
            //      }
            //        else {
            //            
            //            self.delegate?.webServiceResponseSuccess(json, tag: self.serviceTag)
            //            
            //            
            //        }
        })
        
        task.resume()
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
        
    
}
