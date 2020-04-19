//
//  ViewController.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 18/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openFilePicker()
        // Do any additional setup after loading the view.
    }

    func openFilePicker() {
        // NSOpenPanel
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = [kUTTypePDF as String] // "com.adobe.pdf"
        openPanel.allowsMultipleSelection = true
        if (openPanel.runModal() != NSApplication.ModalResponse.OK) { return }
        
        let filePaths: [String] = openPanel.urls.compactMap({ $0.path })
        guard let file = filePaths.first else {
            return
        }
        
        let url = URL(fileURLWithPath: file)
        let printMamager = PdfFilePrinter(withPrintInfo: NSPrintInfo(), fileURL: url, mimeType: MimeType.pdf.rawValue)
        printMamager.printPDF()
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

