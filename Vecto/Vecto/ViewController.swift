//
//  ViewController.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa
import PDFKit

class ViewController: NSViewController {
    let pdfView = PDFView()
//    let pageView = NSTextView()
    var prefix = 0
    var prevChar = ""
    let darkFilters = [
        CIFilter(name: "CIColorInvert")!,
        CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.85,
//                                                           "inputSaturation": 500
                                                       ])!,
        CIFilter(name: "CISharpenLuminance", parameters: ["inputSharpness": 1.5])!,
        CIFilter(name: "CIGammaAdjust", parameters: ["inputPower": 2])!,
        
//            CIFilter(name: "CIWhitePointAdjust")!
        
    ]
    let lightFilters = [
//        CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.85])!
        CIFilter(name: "CISharpenLuminance", parameters: ["inputSharpness": 1.5])!,
        CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.55])!


    ]
    var dark = true
    override func keyDown(with event: NSEvent) {
//        let curPage = pdfView.currentPage?.label ?? "0"
//        print(curPage)
//            + "/" + String(pdfView.document!.pageCount)
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [] where event.characters == "j":

            for _ in 1...4 + (4 * prefix-1) {
                pdfView.scrollLineUp(pdfView)
                prefix = 0
            }
        case [] where event.characters == "k":
            for _ in 1...4 + (4 * prefix-1) {
                pdfView.scrollLineDown(pdfView)
                prefix = 0
            }
            
        case [] where event.characters == "g":
            if prevChar == "g" {
                pdfView.scrollToBeginningOfDocument(pdfView)
                for _ in 0...prefix {
                    pdfView.scrollPageUp(pdfView)
                }
                pdfView.scrollPageDown(pdfView)
                prefix = 0
                prevChar = ""
            } else {
                prevChar = "g"
            }
            
        case [.shift ] where event.characters == "G":
            pdfView.scrollToEndOfDocument(pdfView)
            
        case [.shift ] where event.characters == "L":
            for _ in 1...1 + prefix {
                pdfView.scrollPageUp(pdfView)
                prefix = 0
            }
            
        case [.shift ] where event.characters == "H":
            for _ in 1...1 + prefix {
                pdfView.scrollPageDown(pdfView)
                prefix = 0
            }
        case [.command, .shift] where event.characters == "l":
            dark.toggle()
            refreshView()
            
        case [] where event.keyCode == 53:
            prefix = 0
            prevChar = ""
            
        case [] where event.keyCode >= 18 && event.keyCode <= 29:
            prefix = Int(String(prefix) + String(Int(event.characters!) ?? 0)) ?? 0
//                Int(event.characters!) ?? 0
            
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
//        pageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
//        pdfView.addSubview(pageView)
        
        
        pdfView.autoScales = true
        pdfView.backgroundColor = .clear
        pdfView.displaysPageBreaks = true
        pdfView.pageBreakMargins = NSEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
        if dark == true {
            pdfView.contentFilters = darkFilters
        } else {
            pdfView.contentFilters = lightFilters
        }
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        pageView.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor).isActive = true
//        pageView.topAnchor.constraint(equalTo: pdfView.topAnchor).isActive = true
        
//        pageView.insertText("here", replacementRange: NSMakeRange(0, 100))
        
        let label = NSTextField()
        label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        label.stringValue = "My awesome label"
        label.backgroundColor = .white
        label.isBezeled = false
        label.isEditable = false
        label.sizeToFit()
        label.backgroundColor = .red
        label.drawsBackground = true
        view.addSubview(label)
        
        
        guard let path = Bundle.main.url(forResource: "here3", withExtension: "pdf") else { return }
//        let path = URL(string: "~/Desktop/here.pdf")!

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
        refreshView()

        // Do any additional setup after loading the view.
    }
    func refreshView()
    {
        if dark == true {
            pdfView.contentFilters = darkFilters
        } else {
            pdfView.contentFilters = lightFilters
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

