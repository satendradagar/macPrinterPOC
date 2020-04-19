//
//  FilePrintController.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 18/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa
import ApplicationServices
import Quartz

class PdfFilePrinter: NSObject {

    var printInfo:NSPrintInfo!
    var fileURL: URL!
    var mimeType: String!
    
    
    init(withPrintInfo info: NSPrintInfo?, fileURL:URL, mimeType:String) {
        self.printInfo = info ?? NSPrintInfo.shared
        self.fileURL = fileURL
        self.mimeType = mimeType
    }
        
    func printPDF() {
        
        guard PDFDocument(url: fileURL) != nil else { return }
        
        var printInfo = NSPrintInfo()
        
         let settings  = PMPrintSettings(printInfo.pmPrintSettings())
        let settingsConfigurator = CanonSettingsConfigurator(withSettings: settings)
        settingsConfigurator.applyCanonSettings()
        
        printInfo.updateFromPMPrintSettings()
        
        //Apply custom Print Info
        printInfo.applyCustomSettings()

        // --- Print Panel ---
        let printPanel = NSPrintPanel()

        printPanel.options = [
            NSPrintPanel.Options.showsCopies,
            NSPrintPanel.Options.showsPageSetupAccessory
        ]
        
        if printPanel.runModal(with: printInfo) != NSApplication.ModalResponse.OK.rawValue {
            return
        }
        printInfo = printPanel.printInfo
//        print(printInfo.paperName)
//        print(printInfo.printSettings)

        // Obtain the print session from the printInfo.
        let printSession = PMPrintSession(self.printInfo?.pmPrintSession());
        var printDestination:PMDestinationType = 0;
        var status:OSStatus = noErr;
        
        // Verify that the destination is the printer.
        status = PMSessionGetDestinationType(printSession!, settings, &printDestination);
        
        if ((status != noErr) || (printDestination != kPMDestinationPrinter)) {
            
            print("Either got an error from PMSessionGetDestinationType or the print destination wasn't kPMDestinationPrinter");
            return;
        }

        var currentPrinter:PMPrinter? = nil;
         status = PMSessionGetCurrentPrinter(printSession!, &currentPrinter);
        
        if (status != noErr) {
            
            print("Got an error from PMSessionGetCurrentPrinter (%d)", status);
            return;
        }
        guard let printer = currentPrinter else { fatalError() }
        print(printInfo.printer.deviceDescription)
        
        
        let outMimeType = PrinterUtilities.mimeType(printer: printer, settings: settings, orignalMime: mimeType)
                
        self.printInfo?.pmPageFormat()
        let format = PMPageFormat(self.printInfo?.pmPageFormat())
        PMPrinterPrintWithFile(currentPrinter!, settings, format, outMimeType as CFString, fileURL as CFURL)
    }
    
}
