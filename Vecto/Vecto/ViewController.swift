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
    var prefix = 1
    override func keyDown(with event: NSEvent) {
        print(event)
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [] where event.characters == "j":
//            print("command-l or command-shift-l")
//            view.scroll(<#T##point: NSPoint##NSPoint#>)
            for _ in 1...4 {
                pdfView.scrollLineUp(pdfView)
            }
        case [] where event.characters == "k":
            for _ in 1...4 {
                pdfView.scrollLineDown(pdfView)
            }
            
        case [] where event.characters == "g":
            pdfView.scrollToBeginningOfDocument(pdfView)
        case [.shift ] where event.characters == "G":
            pdfView.scrollToEndOfDocument(pdfView)
        case [.shift ] where event.characters == "H":
            pdfView.scrollPageUp(pdfView)
        case [.shift ] where event.characters == "L":
            pdfView.scrollPageDown(pdfView)
        case [] where event.keyCode == 53:
            prefix = 0
        case [] where event.keyCode >= 18 && event.keyCode <= 29:
            prefix = Int(String(prefix) + String(Int(event.characters!) ?? 0)) ?? 0
//                Int(event.characters!) ?? 0
            print(prefix)
            
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let betterBounds = (0, 0, 1480, 1270)
////        self.view.setBoundsSize(n)
//        let pdfView = PDFView(frame: self.view.bounds)
//        print(self.view.bounds)
////            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            self.view.addSubview(pdfView)
//
//            // Fit content in PDFView.
//            pdfView.autoScales = true
//
//            // Load Sample.pdf file from app bundle.
////            let fileURL = Bundle.main.url(forResource: "Sample", withExtension: "pdf")
////            pdfView.document = PDFDocument(url: fileURL!)
//        pdfView.document = PDFDocument(url: URL(string: "~/Desktop/here.pdf")!)

        
        
//        pdfView.curr
//        view.backgroundColor
//        self.view.backgroundColor = .clear
//        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
    
//        var backgroundColor: NSColor { get set }
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        let filters = [
            CIFilter(name: "CIColorInvert")!,
            CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.85,
//                                                           "inputSaturation": 500
                                                           ])!,
            CIFilter(name: "CISharpenLuminance", parameters: ["inputSharpness": 1.5])!,
            CIFilter(name: "CIGammaAdjust", parameters: ["inputPower": 2])!,
//            CIFilter(name: "CIWhitePointAdjust")!
            
        ]
        pdfView.scrollLineDown([])
        pdfView.autoScales = true
        pdfView.backgroundColor = .clear
        pdfView.displaysPageBreaks = true
        pdfView.contentFilters = filters
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        guard let path = Bundle.main.url(forResource: "here1", withExtension: "pdf") else { return }
//        let path = URL(string: "~/Desktop/here.pdf")!

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

