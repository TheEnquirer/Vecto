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
    let label = NSTextField()
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
    
    
    var darkColors =
        [
            "pageCount": NSColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1),
            "countText": .white
        ]
    
    var lightColors =
        [
            "pageCount": NSColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1),
            "countText": .darkGray
        ]
    
    
    var dark = true
    
    
    
    
   
//    item = "p"
    
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
            
        case [.command, .shift] where event.characters == "h":
            label.isHidden.toggle()
//            refreshView()
        
        case [] where event.characters == "/":
//            print("here")
            var arr = pdfView.document?.beginFindString("and")
//            print(arr)
            
        case [] where event.keyCode == 53:
            prefix = 0
            prevChar = ""
            
        case [] where event.keyCode >= 18 && event.keyCode <= 29:
            prefix = Int(String(prefix) + String(Int(event.characters!) ?? 0)) ?? 0
//                Int(event.characters!) ?? 0
            
        default:
            break
        }
//        refreshPageCount()
    }
    
//    override func scrollWheel(with event: NSEvent) {
//        print("scrolling")
//    }
    
   

          
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
//        pageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
//        titleVisibility = .hidden
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
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        label.stringValue = "Loading..."
//        label.backgroundColor = .white
        label.isBezeled = false
        label.textColor = darkColors["countText"]!
        label.isEditable = false
        label.sizeToFit()
        let shadow = NSShadow()
        shadow.shadowColor = nil
        shadow.shadowBlurRadius = 0
        label.shadow = shadow
//        print(darkColors["pageCount"], "hii")
        label.backgroundColor = darkColors["pageCount"]!
//        label.backgroundColor = NSColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1)
        
        
        label.drawsBackground = true
        view.addSubview(label)
        
        
        guard let path = Bundle.main.url(forResource: "here3", withExtension: "pdf") else { return }
//        let path = URL(string: "~/Desktop/here.pdf")!

        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
        refreshView()
        refreshPageCount()
//        var observer:NSKeyValueObservation?
//        // then assign the return value of "observe" to it
//        observer = pdfView.currentPage?.observe(\.label, changeHandler: { (label, change) in
//            // text has changed,
//            print("yes")
//            self.refreshPageCount()
//        })

        // Do any additional setup after loading the view.
//        var pageChange = &pdfView.currentPage!.label!{
//            didSet { //called when item changes
//                print("changed")
//            }
//            willSet {
//                print("about to change")
//            }
//        }
//        pageTrig = &pdfView.currentPage!.label!
        /* notification */
        
        
        NotificationCenter.default.addObserver (self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearch), name: Notification.Name.PDFDocumentDidFindMatch, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearch), name: Notification.Name.PDFDocumentDidBeginFind, object: nil)
    }
    
    @objc func handleSearch(){
        print("hsfs")
    }
    
    @objc func handleSearchBegin(){
        print("hsfs")
    }
    
    @objc func handlePageChange() {
            refreshPageCount()
    }
    
    var pageTrig = "0"
    
    
    
    
    func refreshView()
    {
        if dark == true {
            pdfView.contentFilters = darkFilters
            label.backgroundColor = darkColors["pageCount"]!
            label.textColor = darkColors["countText"]!
        } else {
            pdfView.contentFilters = lightFilters
            label.backgroundColor = lightColors["pageCount"]!
            label.textColor = lightColors["countText"]!
        }
    }
    
    
    func refreshPageCount() {
        let curPage = pdfView.currentPage?.label ?? "0"
        label.stringValue = String(curPage) + "/" + String(pdfView.document!.pageCount)
//        pdfView.change
    }

//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
   
    
//    NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)

//    @objc private func handlePageChange(notification: Notification)
//    {
//        print("Page changed")
//    }


}

