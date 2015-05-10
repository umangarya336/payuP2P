//
//  LoadingSpinnerView.swift
//  WealthAdvisor
//
//  Created by MarkD on 2014-10-29.
//  Copyright (c) 2014 IBM. All rights reserved.
//

import UIKit

public class LoadingSpinnerView: UIView {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.WhiteLarge)

    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.4

        self.addSubview(activityIndicator)
        activityIndicator.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        activityIndicator.startAnimating()
    }
    
}


 