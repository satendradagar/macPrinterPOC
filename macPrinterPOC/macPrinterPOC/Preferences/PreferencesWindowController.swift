//
//  PreferencesWindowController.swift
//  macPrinterPOC
//
//  Created by Satendra Dagar on 07/05/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        print(NSPrinter.printerNames)
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
//        if segue.destinationController == NSViewController{
//
//        }
        if let controller = segue.destinationController as? PreferencesViewController{
            //use it
            print("controller:\(controller)")
        }
    }
    
}
