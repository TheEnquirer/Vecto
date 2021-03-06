//
//  ViewController.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa
import PDFKit

class ViewController: NSViewController {
    
    /*##################################*/
    /*            initialize            */
    /*##################################*/
    
    let pdfView = PDFView()
    let label = NSTextField()
    let searcher = NSTextField()
    var prefix = 0
    var prevChar = ""
    var dark = true
    
    /*##############################*/
    /*            colors            */
    /*##############################*/
    
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
   
    
    override func keyDown(with event: NSEvent) {
        print(view.frame.size.width)
//        searcher.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor, constant: view.frame.size.width).isActive = true


        
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        
        /*#####################*/
        /*         nav         */
        /*#####################*/
        
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
        
        /*########################*/
        /*         search         */
        /*########################*/
        
        case [] where event.characters == "/":
//            print("here")
            _ = pdfView.document?.beginFindString("agitation")
            
        case [] where event.characters == "n":
            handleNext()
            
        case [.shift] where event.characters == "N":
            handlePrev()
            
        /*########################*/
        /*         helper         */
        /*########################*/
        
        case [] where event.keyCode == 53:
            prefix = 0
            prevChar = ""
            
        case [] where event.keyCode >= 18 && event.keyCode <= 29:
            prefix = Int(String(prefix) + String(Int(event.characters!) ?? 0)) ?? 0
            
        default:
            break
        }
    }
    
    /*############################*/
    /*            main            */
    /*############################*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*#########################*/
        /*         pdfView         */
        /*#########################*/
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
//        titleVisibility = .hidden
        
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
        
        /*#######################*/
        /*         label         */
        /*#######################*/
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        label.stringValue = "Loading..."
        label.isBezeled = false
        label.textColor = darkColors["countText"]!
        label.isEditable = false
        label.sizeToFit()
        let shadow = NSShadow()
        shadow.shadowColor = nil
        shadow.shadowBlurRadius = 0
        label.shadow = shadow
        label.backgroundColor = darkColors["pageCount"]!
        label.drawsBackground = true
        view.addSubview(label)
        
        
        /*##########################*/
        /*         searcher         */
        /*##########################*/
        
        view.addSubview(searcher)
        searcher.translatesAutoresizingMaskIntoConstraints = false
        
//        searcher.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor).isActive = true
//        searcher.trailingAnchor.constraint(equalTo: pdfView.leadingAnchor).isActive = true
//        searcher.trailingAnchor.constraint(equalTo: pdfView.trailingAnchor).isActive = true
        searcher.topAnchor.constraint(equalTo: pdfView.topAnchor).isActive = true
        searcher.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor, constant: view.frame.size.width).isActive = true


//        searcher.trailingAnchor.constraint(equalTo: pdfView.leadingAnchor).isActive = true



        
        searcher.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        searcher.stringValue = "Loading..."
        searcher.isBezeled = false
        searcher.textColor = darkColors["countText"]!
        searcher.isEditable = true
        searcher.sizeToFit()
        searcher.shadow = shadow
        searcher.backgroundColor = darkColors["pageCount"]!
        searcher.drawsBackground = true
        
        
        /*#######################*/
        /*         files         */
        /*#######################*/
        
        guard let path = Bundle.main.url(forResource: "here3", withExtension: "pdf") else { return }
//        let path = URL(string: "~/Desktop/here.pdf")!
        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
        
        /*##########################*/
        /*         starters         */
        /*##########################*/
        
        refreshView()
        refreshPageCount()
        
        /*########################*/
        /*         notifs         */
        /*########################*/
        
        NotificationCenter.default.addObserver (self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearch), name: Notification.Name.PDFDocumentDidFindMatch, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearchBegin), name: Notification.Name.PDFDocumentDidBeginFind, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearchEnd), name: Notification.Name.PDFDocumentDidEndFind, object: nil)
    }
    
    /*#################################*/
    /*            handelers            */
    /*#################################*/
    
        /*########################*/
        /*         search         */
        /*########################*/
    
    var matches = [PDFSelection]()
    var inMatches = 0
    var matchLen = -1
    @objc func handleSearch(_ notification: NSNotification){
        let page = notification.userInfo!["PDFDocumentFoundSelection"]! as! PDFSelection
        matches.append(page)
    }
    
    @objc func handleSearchBegin(){
        inMatches = -1
        matches = []
    }
    
    @objc func handleSearchEnd(){
        matchLen = matches.count - 1
        print("end")
    }
    
    func handleNext(){
        if inMatches >= matchLen { inMatches = 0 } else { inMatches += 1 }
        if matchLen > 0 { pdfView.go(to: matches[inMatches]) } else {print("nogud")}
    }
    
    func handlePrev(){
        if inMatches <= 0 { inMatches = matchLen } else { inMatches -= 1 }
        if matchLen > 0 { pdfView.go(to: matches[inMatches]) } else {print("nogud")}
    }
    
        /*############################*/
        /*         refreshers         */
        /*############################*/
    
    @objc func handlePageChange() {
        refreshPageCount()
    }
    
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
    }
}
