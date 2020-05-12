//
//  NSAlert+Utilities.swift
//  ThinPrint
//
//  Created by Satendra Singh on 22/04/18.
//  Copyright © 2018 TP. All rights reserved.
//

import Foundation
import Cocoa

extension NSAlert{
    
    static func show(title:String, details:String?,keyButton:String, otherButton:String?) -> NSApplication.ModalResponse {
        
        let alert = NSAlert()
        alert.messageText = title
        
        if let detail = details {
            alert.informativeText = detail
        }
        alert.addButton(withTitle: keyButton)
        
        if let other  = otherButton {
            alert.addButton(withTitle: other)
        }
        
        let answer = alert.runModal()
        return answer
    }
}
