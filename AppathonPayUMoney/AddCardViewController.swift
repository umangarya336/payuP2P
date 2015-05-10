//
//  AddCardViewController.swift
//  AppathonPayUMoney
//
//  Created by Ajitesh Koushal on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class AddCardViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate,ConnectionManagerDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expirydate: UITextField!
    @IBOutlet weak var addCardButton: UIButton!
    var activityIndicator:UIActivityIndicatorView!
    var imageView = UIImageView()
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        var logoutButton = UIBarButtonItem(title: "Sign out", style: UIBarButtonItemStyle.Plain, target: self, action: "signOutClicked")
        self.navigationItem.rightBarButtonItem = logoutButton
        self.navigationItem.title = "Home"
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func signOutClicked()
    {
        let loginViewController =  self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController_iPhone") as LoginViewController_iPhone
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonClicked(sender: AnyObject) {
        imageView.frame = CGRectMake((self.view.frame.size.width-300)/2, 100, 300, 150)
        self.view.addSubview(imageView)
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("camera")
            self.openCamera()
            
        })
        let galleryAction = UIAlertAction(title: "Gallery", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            println("File Saved")
            self.openGallery()
        })
        
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            var imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePickerController.allowsEditing = false
            addActivityIndicator()
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        else
        {
            var alert = UIAlertView()
            //title: "No camera", message: "Your device dose not have camera", delegate: self, cancelButtonTitle: "Ok", otherButtonTitles: nil)
            alert.title = "No camera"
            alert.message = "Your device dose not have camera. Will go to Liberary"
            alert.delegate = self
            alert.addButtonWithTitle("Ok")
            alert.show()
            
            var imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePickerController.allowsEditing = true
            addActivityIndicator()
            self.presentViewController(imagePickerController, animated: true, completion: { imageP in
                
            })
        }
    }
    
    func openGallery()
    {
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePickerController.allowsEditing = true
        addActivityIndicator()
        self.presentViewController(imagePickerController, animated: true, completion: { imageP in
            
        })
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //        imageView.setBackgroundImage(info[UIImagePickerControllerOriginalImage] as? UIImage, forState: UIControlState.Normal)
        //addActivityIndicator()
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("returned")
    }
    
    
    @IBAction func addCardClicked(sender: AnyObject) {
        
        
        self.showLaodingPopup()
        
        var DataDict = [ "userid":appDelegate.strUsertID, "card_number":cardNumber.text,"card_name":name.text,"expiry_detail":expirydate.text,"card_bank":""]
        
        var Path = "storeCardDetails"
        
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
            
            self .hideLoadingPoup()
            
            self.showAlert(strData)
            
            
        })
        
    }
    
    
    func webServiceResponseFail(strError: NSString)
    {
        
        
        
        dispatch_async(dispatch_get_main_queue(),{
            print(strError)
            
            self.showAlert(strError)

            self .hideLoadingPoup()
            
            
        })
        
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
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        expirydate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func performImageRecognition(image: UIImage) {
//        var textView = UITextView(frame: imageView.frame)
//        textView.backgroundColor = UIColor.grayColor()
//        self.view.addSubview(textView)
//        // 1
//        let tesseract = G8Tesseract()
//        
//        // 2
//        tesseract.language = "eng+fra"
//        
//        // 3
//        tesseract.engineMode = .TesseractCubeCombined
//        
//        // 4
//        tesseract.pageSegmentationMode = .Auto
//        
//        // 5
//        tesseract.maximumRecognitionTime = 60.0
//        
//        // 6
//        tesseract.image = image.g8_blackAndWhite()
//        tesseract.recognize()
//        
//        // 7
//        imageView.hidden = true
//        
//        
//        textView.text = tesseract.recognizedText
//        textView.editable = true
        removeActivityIndicator()
        
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        if i == 0
        {
            i = i+1
        }
        else
        {
            performImageRecognition(imageView.image!)
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
