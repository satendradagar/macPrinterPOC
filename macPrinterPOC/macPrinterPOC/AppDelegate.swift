//
//  AppDelegate.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 18/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var preferencesWindowController:PreferencesWindowController?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        CoreDataManager.shared.saveAction(sender)
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        return CoreDataManager.shared.windowWillReturnUndoManager(window: window)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return CoreDataManager.shared.applicationShouldTerminate()
    }

    @IBAction func showPreferences(_ sender:AnyObject?){
        preferencesWindowController = PreferencesWindowController.instance()
        preferencesWindowController?.showWindow(sender)
        preferencesWindowController?.window?.makeKeyAndOrderFront(sender)
    }
}

