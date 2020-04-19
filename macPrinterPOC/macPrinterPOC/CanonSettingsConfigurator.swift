//
//  CanonSettingsConfigurator.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 19/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Foundation

class CanonSettingsConfigurator: NSObject {
    
    private var setting: PMPrintSettings!
    
     init(withSettings pmSettings:PMPrintSettings) {
        self.setting = pmSettings
    }
    
    func applyCanonSettings() -> Void {
        
        applySetting(CanonSettingsKey.mediaType.rawValue, value: CanonMediaType.printableDisc.rawValue)
        applySetting(CanonSettingsKey.paperSource.rawValue, value: CanonMediaPaperSource.discTray.rawValue)
        applySetting(CanonSettingsKey.printQuality.rawValue, value: CanonPrintQuality.fine.rawValue)
    }
    
   private func applySetting(_ key:String, value:String) {
        PMPrintSettingsSetValue(setting, key as CFString, value as CFTypeRef, false)
    }
}
