//
//  NSWindowController+Utilities.swift
//  ReppertFactor Authenticator
//
//  Created by Satendra Singh on 25/08/19.
//  Copyright © 2019 REPPERTFACTOR LLC. All rights reserved.
//

import Foundation
import Cocoa

extension NSWindowController{
    
    class func instance() -> Self {
        //Bundle.init(identifier:nil )"com.gtdigital.AJDisplay"
        let storyboardName = String(describing: self)
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        return storyboard.initialViewController()
    }
    
}
