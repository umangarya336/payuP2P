//
//  BaseViewController.swift
//  AppathonPayUMoney
//
//  Created by Puneet on 09/05/15.
//  Copyright (c) 2015 AppathonPayUMoney. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var appdelegate = UIApplication.sharedApplication().delegate as AppDelegate

    
    
    func showLaodingPopup()
    {
        
        var loadingView = LoadingSpinnerView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingPoup()
    {
        for view in self.view.subviews as [UIView]
        {
            if(view.isKindOfClass(LoadingSpinnerView))
            {
                view.removeFromSuperview()
            }
        }
    }

}
