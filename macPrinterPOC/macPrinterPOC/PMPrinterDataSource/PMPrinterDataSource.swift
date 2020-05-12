//
//  PMPrinterDataSource.swift
//  macPrinterPOC
//
//  Created by Satendra Dagar on 10/05/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

import Cocoa


class PMPrinterDataSource: NSObject {

    public static func availablePrinterObjects() -> [PMPrinterObj]
    {
        var printers = [PMPrinterObj]()
        
        let res = getAvailablePrinterList()
        for idx in 0 ..< CFArrayGetCount(res.printers) {
            let printer = PMPrinter(CFArrayGetValueAtIndex(res.printers, idx))!
            guard let printerObj = preparePrinter(pmPrinter: printer) else {
                continue
            }
            printers.append(printerObj)
          }
        return printers
    }

    public static func preparePrinter(pmPrinter: PMPrinter) -> PMPrinterObj?{
        // Printer ID
        let idUnmanaged: Unmanaged<CFString>? = PMPrinterGetID(pmPrinter)
        if let printerID = idUnmanaged?.takeUnretainedValue() as String? {
            var printerObj = PMPrinterObj.init(name: "", model: "", printerID: printerID, uri: "")
            // Device URI
            var printerDeviceURIUnmanaged: Unmanaged<CFURL>?
            let _ = PMPrinterCopyDeviceURI(pmPrinter, &printerDeviceURIUnmanaged)
            if let printerDeviceURI: CFURL = printerDeviceURIUnmanaged?.takeUnretainedValue() {
                let deviceURI = printerDeviceURI as URL
                printerObj.uri = deviceURI.absoluteString
            }
            // Printer Human Readable Name
            let nameUnmanaged: Unmanaged<CFString>? = PMPrinterGetName(pmPrinter)
            let name = nameUnmanaged?.takeUnretainedValue() as String?
            printerObj.name = name
            // Manufacturer & Model
            var modelUnmanaged: Unmanaged<CFString>?
            let _ = PMPrinterGetMakeAndModelName(pmPrinter, &modelUnmanaged)
            let model = modelUnmanaged?.takeUnretainedValue() as String?
            printerObj.model = model
            return printerObj
        }
        return nil
    }

    
//    public static func availablePrinterList() -> Void
//    {
//        let res = getAvailablePrinterList()
//        for idx in 0 ..< CFArrayGetCount(res.printers) {
//              let printer = PMPrinter(CFArrayGetValueAtIndex(res.printers, idx))!
//              let nameUnmanaged: Unmanaged<CFString>? = PMPrinterGetName(printer)
//              guard let name = nameUnmanaged?.takeUnretainedValue() as String? else {
//                  continue
//              }
//            let dict = getPMPrinterInfo(pmPrinter: printer)
//            print(dict)
//          }
//    }
    
    public static func getAvailablePrinterList() -> (err: OSStatus, printers: CFArray?, printerNames: [String]?)
    {
        var outPrinters: CFArray? = nil
        var outPrinterNames: [String]? = nil
        
        // Obtain the list of PMPrinters
        var outPrintersUnmanaged: Unmanaged<CFArray>?
        let err: OSStatus = PMServerCreatePrinterList( nil, &outPrintersUnmanaged )
        outPrinters = outPrintersUnmanaged?.takeUnretainedValue()
        
        if let printerArray = outPrinters {
            var printerNames: [String] = []
            for idx in 0 ..< CFArrayGetCount(printerArray) {
                let printer = PMPrinter(CFArrayGetValueAtIndex(printerArray, idx))!
                let nameUnmanaged: Unmanaged<CFString>? = PMPrinterGetName(printer)
                guard let name = nameUnmanaged?.takeUnretainedValue() as String? else {
                    continue
                }
                printerNames.append(name)
            }
            outPrinterNames = printerNames
        }
        
        return (err, outPrinters, outPrinterNames)
    }
    
//      public static func getPMPrinterInfo(pmPrinter: PMPrinter) -> Dictionary<String, Any> {
//          // https://developer.apple.com/documentation/applicationservices/core_printing
//          var d = Dictionary<String, Any>()
//
//          // Printer ID
//          let idUnmanaged: Unmanaged<CFString>? = PMPrinterGetID(pmPrinter)
//          if let printerID = idUnmanaged?.takeUnretainedValue() as String? {
//              d["printerID"] = printerID
//          }
//
//          // Host Name
//          var hostNameUnmanagedOptional: Unmanaged<CFString>?
//          let _ = PMPrinterCopyHostName(pmPrinter, &hostNameUnmanagedOptional)
//          guard let hostNameUnmanaged = hostNameUnmanagedOptional else { fatalError() }
//          let hostName = hostNameUnmanaged.takeUnretainedValue() as String
//          d["hostName"] = String(hostName)
//
//          // Device URI
//          var printerDeviceURIUnmanaged: Unmanaged<CFURL>?
//          let _ = PMPrinterCopyDeviceURI(pmPrinter, &printerDeviceURIUnmanaged)
//          if let printerDeviceURI: CFURL = printerDeviceURIUnmanaged?.takeUnretainedValue() {
//              d["printerDeviceURI"] = printerDeviceURI as URL
//              // "You are responsible for releasing the URL."
//          }
//
//          // Description File URI
//          var printerDescriptionURLUnmanaged: Unmanaged<CFURL>?
//          let _ = PMPrinterCopyDescriptionURL(pmPrinter, kPMPPDDescriptionType as CFString, &printerDescriptionURLUnmanaged)
//          if let printerDescriptionURL = printerDescriptionURLUnmanaged?.takeUnretainedValue() as URL? {
//              d["printerDescriptionURL"] = printerDescriptionURL
//          }
//
//          // Communication Channel Info
//          var supportsControlCharRangeP: DarwinBoolean = false
//          var supportsEightBitP: DarwinBoolean = false
//          let _ = PMPrinterGetCommInfo(pmPrinter, &supportsControlCharRangeP, &supportsEightBitP)
//          d["commChannelSupportsControlChar"] = supportsControlCharRangeP.boolValue
//          d["commChannelSupportsEightBit"] = supportsEightBitP.boolValue
//
//          // Printer Human Readable Name
//          let nameUnmanaged: Unmanaged<CFString>? = PMPrinterGetName(pmPrinter)
//          if let name = nameUnmanaged?.takeUnretainedValue() as String? {
//              d["nameReadble"] = name
//          }
//
//          // Printer Location (may be user created)
//          let locationUnmanaged: Unmanaged<CFString>? = PMPrinterGetLocation(pmPrinter)
//          if let location = locationUnmanaged?.takeUnretainedValue() as String? {
//              d["location"] = location
//          }
//
//          // Manufacturer & Model
//          var modelUnmanaged: Unmanaged<CFString>?
//          let _ = PMPrinterGetMakeAndModelName(pmPrinter, &modelUnmanaged)
//          if let model = modelUnmanaged?.takeUnretainedValue() as String? {
//              d["model"] = model
//          }
//
//          // Resolution
//          var resolutionCount: UInt32 = 0
//          let result = PMPrinterGetPrinterResolutionCount(pmPrinter, &resolutionCount)
//          if result == Int32(kPMNotImplemented) {
//              d["resolutionCount"] = -1
//          }
//          else {
//              d["resolutionCount"] = resolutionCount
//              var resolutionList = [PMResolution]()
//              for idx:UInt32 in 1...resolutionCount {
//                  var pmResolution = PMResolution()
//                  let _ = PMPrinterGetIndexedPrinterResolution(pmPrinter, idx, &pmResolution)
//                  resolutionList.append(pmResolution)
//                  // CHECK: pmResolution.hRes x pmResolution.vRes
//              }
//              d["resolutionList"] = resolutionList
//          }
//
//          // Printer State
//          var printerState: PMPrinterState = 0
//          let _ = PMPrinterGetState(pmPrinter, &printerState)
//          d["printerState"] = printerState
//          switch printerState {
//          case UInt16(kPMPrinterIdle) :
//              d["printerStateName"] = "kPMPrinterIdle"
//          case UInt16(kPMPrinterProcessing) :
//              d["printerStateName"] = "kPMPrinterProcessing"
//          case UInt16(kPMPrinterStopped) :
//              d["printerStateName"] = "kPMPrinterStopped"
//          default:
//              d["printerStateName"] = "UNSPECIFIED"
//          }
//
//          // Default
//          d["isDefaultPrinter"] = PMPrinterIsDefault(pmPrinter)
//
//          // Favorite
//          d["isFavoritePrinter"] = PMPrinterIsFavorite(pmPrinter)
//
//          // Postscript Capable.  possibly rendered via macOS printing system
//          d["isPostscriptCapable"] = PMPrinterIsPostScriptCapable(pmPrinter)
//
//          // Postscript Printer. printer is a postscript printer
//          var isPostScriptPrinter: DarwinBoolean = false
//          let _ = PMPrinterIsPostScriptPrinter(pmPrinter, &isPostScriptPrinter)
//          d["isPostscriptCapable"] = isPostScriptPrinter.boolValue
//
//          // Remote Printer
//          var isRemotePrinter: DarwinBoolean = false
//          let _ = PMPrinterIsRemote(pmPrinter, &isRemotePrinter)
//          d["isRemote"] = isRemotePrinter.boolValue
//
//          // Driver Creater. 4-byte creater code. 'APPL' is Apple
//          var osType: OSType = UInt32(0)
//          let _ = PMPrinterGetDriverCreator(pmPrinter, &osType)
//          d["osType"] = String(format: "%c", osType)
//
//          // Driver Version (use here for information only)
//          // Note: application use of version can make application version dependent.
//          //var versionRecord:VersRec // Error: Use of undeclared type 'VersRec'
//          //let _ = PMPrinterGetDriverReleaseInfo(pmPrinter, &versionRecord)
//
//          // Language Information
//          // uses Darwin.Str32 aka Str32
//
////          var pmLanguageInfo: PMLanguageInfo = PMLanguageInfo()
////          var _ = PMPrinterGetLanguageInfo(pmPrinter, &pmLanguageInfo)
////          d["pmLanguageInfo"] = [
////              "level" : darwinStr32ToString(darwinStr32: pmLanguageInfo.level),
////              "version" : darwinStr32ToString(darwinStr32: pmLanguageInfo.version),
////              "release" : darwinStr32ToString(darwinStr32: pmLanguageInfo.release)
////          ]
//
//          // MIME Types
//          // typically used in conjunction with func PMPrinterPrintWithFile(_:_:_:_:_:)
//          var mimeTypeArray = [String]()
//          var mimeTypesUnmanaged: Unmanaged<CFArray>?
//          let settings: PMPrintSettings? = nil
//          var _ = PMPrinterGetMimeTypes(pmPrinter, settings, &mimeTypesUnmanaged)
//          if let mimeTypes = mimeTypesUnmanaged?.takeUnretainedValue() {
//              for idx in 0..<CFArrayGetCount(mimeTypes) {
//                  let mime: CFString = unsafeBitCast(CFArrayGetValueAtIndex(mimeTypes, idx), to: CFString.self)
//                  mimeTypeArray.append(mime as String)
//              }
//              d["mimeTypes"] = mimeTypeArray
//          }
//
//          // Printer Presets
//          // use PMPrinterCopyPresets(_:_:) to obtain available presets
//          // use PMPresetGetAttributes(_:_:) to obtain preset information
//          // use PMPresetCreatePrintSettings(_:_:_:) to create a print settings object
//          var presetArray = Array<CFDictionary>()
//          var presetListUnmanaged: Unmanaged<CFArray>?
//          let _ = PMPrinterCopyPresets(pmPrinter, &presetListUnmanaged)
//          if let presetList = presetListUnmanaged?.takeUnretainedValue() {
//              for idx in 0..<CFArrayGetCount(presetList) {
//                  let preset = PMPreset( CFArrayGetValueAtIndex(presetList, idx) )!
//                  var attributesUnmanaged: Unmanaged<CFDictionary>?
//                  let _ = PMPresetGetAttributes(preset, &attributesUnmanaged)
//                  if let attributes: CFDictionary = attributesUnmanaged?.takeUnretainedValue() {
//                      presetArray.append(attributes)
//                  }
//              }
//              d["presets"] = presetArray
//          }
//
//
//          // Printer Paper List
//          // Get the array of pre-defined PMPapers this printer supports.
//          // PMPrinterGetPaperList(PMPrinter, UnsafeMutablePointer<Unmanaged<CFArray>?>)
////          var paperArray = Array<Dictionary<String, Any>>()
////          var paperListUnmanaged: Unmanaged<CFArray>?
////          let _ = PMPrinterGetPaperList(pmPrinter, &paperListUnmanaged)
////          if let paperList = paperListUnmanaged?.takeUnretainedValue() {
////              //PMPaperGetPrinterID(PMPaper, UnsafeMutablePointer<Unmanaged<CFString>?>)
////              for idx in 0..<CFArrayGetCount(paperList) {
////                  let paper = PMPaper(CFArrayGetValueAtIndex(paperList, idx))!
////                  paperArray.append(getPMPaperInfo(pmPaper: paper))
////              }
////              d["paperList"] = paperArray
////          }
//
//          return d
//      }
}
