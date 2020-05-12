//
//  PMPrinterObj.swift
//  macPrinterPOC
//
//  Created by Satendra Dagar on 10/05/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Foundation

struct PMPrinterObj: CustomStringConvertible {
    
    var name:String?
    var model:String?
    let printerID:String
    var uri:String?
    var priority:Int = 0
    var description: String{
        return  "name:\(name ?? ""),model:\(model ?? ""),printerID:\(printerID),uri:\(uri ?? "")"
    }

}
