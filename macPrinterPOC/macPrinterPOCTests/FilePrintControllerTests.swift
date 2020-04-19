//
//  FilePrintControllerTests.swift
//  macPrinterPOCTests
//
//  Created by Satendra Singh on 18/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import XCTest
@testable import macPrinterPOC

class FilePrintControllerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testPrinterControllerShouldHoldPrintInfo()  {
        
        let info = NSPrintInfo()
        let controller = PdfFilePrinter.init(withPrintInfo: info, fileURL: URL(fileURLWithPath:"~/Documents" ) )
        XCTAssertEqual(info, controller.printInfo, "Info should be stored into controller")
    }
    
    func testPrinterControllerShouldHoldUrl()  {
        
        let info = NSPrintInfo()
        let url = URL(fileURLWithPath:"~/Documents/" )
        let controller = PdfFilePrinter.init(withPrintInfo: info, fileURL: url )
        XCTAssertNotNil(controller.fileURL, "URL should not be nil")
    }

}
