//
//  NSPrintInfoCustomized.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 19/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import AppKit

extension NSPrintInfo{
    
    func applyCustomSettings() -> Void {
        
        self.paperName = NSPrinter.PaperName(rawValue: PageNameConstants.diskTrayM.rawValue)
        self.scalingFactor = PageScale.hundred.rawValue;

    }
    
}
