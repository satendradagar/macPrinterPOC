//
//  AddPrinterController.swift
//  macPrinterPOC
//
//  Created by Satendra Dagar on 08/05/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa

class AddPrinterController: NSViewController {
    
    @IBOutlet weak var printerMenu: NSPopUpButton!
    @IBOutlet weak var printerType: NSPopUpButton!
    var applyChangeBlock: (() -> Void)?
    var printersToList: [PMPrinterObj]?
    var printerTypes: [String]?
    var priority = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePrinterMenu()
        populatePrinterTypeMenu()
        // Do view setup here.
    }
    
    func populatePrinterMenu() -> Void {
        self.printerMenu.removeAllItems()
        if let printers = self.printersToList{
            for printer in printers {
                guard let printerTitle = printer.name else {
                    self.printerMenu.addItem(withTitle: "-")
                    continue
                }
                self.printerMenu.addItem(withTitle: printerTitle)
            }
        }
    }
    
    func populatePrinterTypeMenu() -> Void {
        self.printerType.removeAllItems()
        if let types = self.printerTypes{
            self.printerType.addItems(withTitles: types)
        }
    }

    @IBAction func addPrinterClicked(_ sender: Any?){
        if  self.printerMenu.indexOfSelectedItem != NSNotFound{
            if var pmObj = self.printersToList?[self.printerMenu.indexOfSelectedItem], let type = self.printerTypes?[self.printerType.indexOfSelectedItem]{
                pmObj.priority = self.priority
                CoreDataManager.shared.addPrinter(printer: pmObj, type: type)
                self.applyChangeBlock?()
            }
            self.cancelClicked(sender)
        }
    }

    @IBAction func cancelClicked(_ sender: Any?){
        self.dismiss(sender)
    }

}
