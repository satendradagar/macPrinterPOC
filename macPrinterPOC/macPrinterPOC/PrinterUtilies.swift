//
//  PrinterUtilies.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 19/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Foundation

class PrinterUtilities {
    
   class func mimeType(printer:PMPrinter, settings:PMPrintSettings, orignalMime:String) -> String {
        var findMime:String = orignalMime
        var mimeTypesUnmanaged: Unmanaged<CFArray>?
        var _ = PMPrinterGetMimeTypes(printer, settings, &mimeTypesUnmanaged)
        if let mimeTypes = mimeTypesUnmanaged?.takeUnretainedValue() {
            for idx in 0..<CFArrayGetCount(mimeTypes) {
                let mime: CFString = unsafeBitCast(CFArrayGetValueAtIndex(mimeTypes, idx), to: CFString.self)
                if mime as String == orignalMime {
                    findMime = mime as String
                    break
                }
            }
        }
        return findMime
    }
}
