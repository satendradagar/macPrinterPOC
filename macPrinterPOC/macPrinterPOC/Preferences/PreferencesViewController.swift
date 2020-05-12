//
//  PreferencesViewController.swift
//  macPrinterPOC
//
//  Created by Satendra Dagar on 09/05/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa

// Let's say our app can accept this "macPrinter.printer" type
let printerPasteboardType = NSPasteboard.PasteboardType(rawValue: "macPrinter.printer")


class PreferencesViewController: NSViewController {

    @IBOutlet weak var printerTable: NSTableView!
    
    var configuredPrinters: [PrinterObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.printerTable.dataSource = self
        self.reloadPrinters()
        self.printerTable.registerForDraggedTypes([printerPasteboardType])
        // Do view setup here.
    }
    
    @IBAction func addPrinterAction(_ sender: NSButton) {
        let printers = avaialblePrinterExcAlreadyAdded()
        if printers.count == 0{
            showErrorMessage(message: "No printer available to add")
        }
        else{
            let addController = AddPrinterController.instance()
            addController.printersToList = printers
            addController.printerTypes = PrinterTypeSource.sources()
            addController.priority = printers.count
            addController.applyChangeBlock = {
                self.reloadPrinters()
            }
            self.presentAsSheet(addController)
        }
    }
    
    func avaialblePrinterExcAlreadyAdded() -> [PMPrinterObj] {
        let printers = PMPrinterDataSource.availablePrinterObjects()
        return printers
        let filtered = printers.filter { (sourcePrinter) -> Bool in
            
            var isMatched = false
            for p in self.configuredPrinters ?? []{
                if (p.identifier == sourcePrinter.printerID){
                    isMatched = true
                    break
                }
            }
            return !isMatched
        }
        return filtered
    }
    
    func reloadPrinters() -> Void {
        self.configuredPrinters = CoreDataManager.shared.fetchPrinters()
        self.printerTable.reloadData()
    }
    
    @IBAction func removePrinterAction(_ sender: NSButton) {
        
        if printerTable.selectedRow != NSNotFound{
            if let printer = self.configuredPrinters?[printerTable.selectedRow]{
                CoreDataManager.shared.removePrinter(printer: printer)
                self.reloadPrinters()
            }
        }
    }
}

extension PreferencesViewController :NSTableViewDataSource{
    func numberOfRows(in tableView: NSTableView) -> Int{
        return configuredPrinters?.count ?? 0
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        
        if let printer = self.configuredPrinters?[row]{
         
            switch tableColumn?.identifier.rawValue {
            case "name":
                return printer.name
            case "model":
                return printer.model
            case "type":
                return printer.type
            default:
                return "Unmatched Identifier"
            }
        }
        return "No record data"
    }
    
//    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int){
//
//    }
//
//    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]){
//
//    }

//    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet)
//    {
//        print("Function: \(#function), line: \(#line)")
//    }
//
//    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation){
//        print("Function: \(#function), line: \(#line)")
//
//    }
//
//    func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo){
//        print("Function: \(#function), line: \(#line)")
//   }

//    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool{
//        print("Function: \(#function), line: \(#line)")
//
//         return true
//    }
    
    
    // For the source table view
      func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
//        let account = self.configuredPrinters![row]
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString("\(row)" , forType: printerPasteboardType)
          return pasteboardItem
      }
    
    // For the destination table view
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        if dropOperation == .above {
            return .move
        } else {
            return []
        }
    }
    
    // For the destination table view
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        //let originalRow = self.configuredPrinters?.firstIndex(of: account)
//        let account = self.configuredPrinters?.first(where: { $0.identifier == theString })
        
        guard
            let item = info.draggingPasteboard.pasteboardItems?.first,
            let theString = item.string(forType: printerPasteboardType), let originalRow = Int(theString)

            else { return false }

        var newRow = row
        // When you drag an item downwards, the "new row" index is actually --1. Remember dragging operation is `.above`.
        print("Original:\(originalRow), row:\(row)")
        if originalRow < newRow {
            newRow = row - 1
        }
        print("Original:\(originalRow), new:\(newRow)")

        // Persist the ordering by saving your data model
        saveAccountsReordered(at: originalRow, to: newRow)
        self.configuredPrinters = CoreDataManager.shared.fetchPrinters()
        // Animate the rows
        tableView.beginUpdates()
        tableView.moveRow(at: originalRow, to: newRow)
        tableView.endUpdates()

        return true
    }
    
    func saveAccountsReordered(at originalRow:Int, to newRow:Int) -> Void {
        
        let printer1 = self.configuredPrinters?[originalRow]
        let printer2 = self.configuredPrinters?[newRow]
//        let priorityOfTwo = printer2?.priority
        printer1?.priority = Int64(newRow)
        printer2?.priority = Int64(originalRow)
        CoreDataManager.shared.saveAction(nil)
    }
}

