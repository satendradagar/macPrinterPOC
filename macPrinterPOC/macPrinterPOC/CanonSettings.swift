//
//  CanonSettings.swift
//  macPrinterPOC
//
//  Created by Satendra Singh on 19/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Foundation

public enum CanonSettingsKey: String{
    case mediaType = "CNIJMediaType"
    case paperSource = "CNIJMediaSupply"
    case printQuality = "CNIJPrintQuality"
}

public enum CanonMediaPaperSource: String{
    case discTray = "26"
}

public enum CanonMediaType: String{
    case printableDisc = "31"
}

public enum CanonPrintQuality: String{
    case fine = "5"
}


