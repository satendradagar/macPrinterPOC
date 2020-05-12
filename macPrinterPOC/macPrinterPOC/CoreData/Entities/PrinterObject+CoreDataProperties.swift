//
//  PrinterObject+CoreDataProperties.swift
//  macPrinterPOC
//
//  Created by Satendra Dagar on 11/05/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension PrinterObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrinterObject> {
        return NSFetchRequest<PrinterObject>(entityName: "PrinterObject")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var model: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var priority: Int64

}
