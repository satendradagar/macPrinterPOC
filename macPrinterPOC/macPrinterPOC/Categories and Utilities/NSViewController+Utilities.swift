//
//  NSViewController+Utilities.swift
//  AJPlayerMac
//
//  Created by Satendra Singh on 31/10/17.
//  Copyright © 2017 Satendra. All rights reserved.
//

import Foundation
import Cocoa

let topID = "sstop"
let bottomID = "ssbottom"
let leadingID = "ssleading"
let trailingID = "sstrailing"
let widthID = "sswidth"

@objc extension NSViewController{
    
    class func instance() -> Self {
        //Bundle.init(identifier:nil )"com.gtdigital.AJDisplay"
        let storyboardName = String(describing: self)
        
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        
        return storyboard.initialViewController()
    }
    
    func addSSChildViewController(child:NSViewController){
        
        let subView = child.view;//Child
        self.addSSChildViewController(child: child, withView: subView)
    }
    func fit(childView: NSView, parentView: NSView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = childView.topAnchor.constraint(equalTo: parentView.topAnchor)
        top.identifier = topID
        top.isActive = true
        
        let leading = childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor)
        leading.identifier = leadingID
        leading.isActive = true
        
        let trailing = childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        trailing.isActive = true
        trailing.identifier = trailingID
        
        let bottom = childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        bottom.isActive = true
        bottom.identifier = bottomID
    }
    
    func addSSChildViewController(child:NSViewController, withView subView:NSView){
        
        //        let subView = child.view;//Child
        let parent = self.view;//Parent
        self.addChild(child)
        parent.addSubview(subView)
        subView.alphaValue = 0.0
        NSAnimationContext.runAnimationGroup({(_ context: NSAnimationContext) -> Void in
            context.duration = 0.7
            subView.animator().alphaValue = 1.0
        }, completionHandler: {() -> Void in
            //            self.view.isHidden = true
            subView.alphaValue = 1
        })
        fit(childView: subView, parentView: parent)
        subView.translatesAutoresizingMaskIntoConstraints = false
        //        parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subView": subView]))
        //        parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subView": subView]))
        //
        //        return
        //        //width
        //        let width = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: parent, attribute: .width, multiplier: 1.0, constant: 0.0)        //
        //
        //        //height
        //        let height = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: .equal, toItem: parent, attribute: .height, multiplier: 1.0, constant: 0.0)        //
        //
        //        //top
        //        let top = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1.0, constant: 0.0)        //
        //
        //        //Leading
        //        let leading = NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: 0.0)
        //        parent.addConstraints([leading,top,height,width])
    }
    
    func pushViewController(controller:NSViewController) -> Void {
        
        let subView = controller.view;//Child
        let parent = self.view;//Parent
        self.addChild(controller)
        var initalFrame = parent.bounds
        initalFrame.origin.x = 0.0 + initalFrame.size.width
        subView.frame = initalFrame
        parent.addSubview(subView)
        NSAnimationContext.runAnimationGroup({(_ context: NSAnimationContext) -> Void in
            context.duration = 0.3
            subView.animator().frame = parent.bounds
        }, completionHandler: {() -> Void in
            //            self.view.isHidden = true
            //            subView.alphaValue = 1
            subView.frame = parent.bounds
            self.fit(childView: subView, parentView: parent)
            subView.translatesAutoresizingMaskIntoConstraints = false
            
        })
        
    }
    func popViewController(animated:Bool = true) -> Void {
        
        //        let parent = subView.superview;//Parent
        if animated == false {
            removeController()
            return
        }
        let subView = self.view;//Child1

        NSAnimationContext.runAnimationGroup({(_ context: NSAnimationContext) -> Void in
            context.duration = 0.3
            var finalFrame = subView.bounds
            finalFrame.origin.x = 0.0 + finalFrame.size.width
            subView.animator().frame = finalFrame
        }, completionHandler: {() -> Void in
            //            self.view.isHidden = true
            //            subView.alphaValue = 1
            //            subView.frame = parent.bounds
            //            self.fit(childView: subView, parentView: parent)
            //            subView.translatesAutoresizingMaskIntoConstraints = false
            self.removeController()
        })
    }
    
    func removeController()  {
        
        let subView = self.view;//Child1
        subView.removeFromSuperview()
        self.removeFromParent()
        
    }
    func ssReomveController() -> Void {
        
        NSAnimationContext.runAnimationGroup({(_ context: NSAnimationContext) -> Void in
            context.duration = 0.7
            self.view.animator().alphaValue = 1.0
        }, completionHandler: {() -> Void in
            //            self.view.isHidden = true
            self.view.alphaValue = 0.0
            self.view.removeFromSuperview()
            self.removeFromParent()
            
        })
        
        
    }
}


extension NSView {
    func constraint(withIdentifier:String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withIdentifier }.first
    }
}

