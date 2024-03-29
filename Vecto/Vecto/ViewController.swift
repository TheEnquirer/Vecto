//
//  ViewController.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa
import PDFKit


//import Foundation

class ViewController: NSViewController {
    
    /*##################################*/
    /*        MARK: - initialize        */
    /*##################################*/
    
    //var test = ViewController()

    
    
    let pdfView = PDFView()
    let label = NSTextField()
    let searcher = NSTextField()
    
    var windowurl: URL?
    var prefix = 0
    var prevChar = ""
    var dark = true
    
        
    var actionList = [PDFPage]()
    
    /*##############################*/
    /*        MARK: - colors        */
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
    
    var FiLight = true
    
    var lightFilters = [
//        CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.85])!
        CIFilter(name: "CISharpenLuminance", parameters: ["inputSharpness": 1.5])!,
        CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.55])!
    ]

//    let lightFilters = [CIFilter]()
    
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
        
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        
        /*#####################*/
        /*     MARK: - nav     */
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
                actionList.append(pdfView.currentPage!)
                
                pdfView.scrollToBeginningOfDocument(pdfView)
                for _ in 0...prefix {
                    pdfView.goToNextPage(pdfView)
                }
                if (prefix < pdfView.document!.pageCount) {
                    pdfView.goToPreviousPage(pdfView)
                    pdfView.goToPreviousPage(pdfView)
                }
                
                //TODO: lmao
                
                prefix = 0
                prevChar = ""
            } else {
                prevChar = "g"
            }
            
        case [.shift ] where event.characters == "G":
            actionList.append(pdfView.currentPage!)
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
            
        case [.control ] where event.characters == "\u{0F}":
            for _ in 1...1 + max(0, prefix-1) {
                if actionList.count > 0 {
                    let page = actionList.popLast()
                    pdfView.go(to: page!)
                }
            }
            prefix = 0
            
        case [.option, .shift] where event.characters == "Ò":
            dark.toggle()
            refreshView()
//            /Users/huxmarv/Downloads/10-18-20, 8_49 PM Office Lens.pdf
//            Users/huxmarv/Downloads/10-18-20, 208_49 20PM 20Office 20Lens.pdf
        case [] where event.characters == "y":
//            print(self.windowurl!)
            NSWorkspace.shared.activateFileViewerSelecting([self.windowurl!])
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString("\(self.windowurl!)".replacingOccurrences(of: "file://", with: "")
                                    .replacingOccurrences(of: "%20", with: " ")
                                 , forType: .string)

        case [.shift] where event.characters == "C":
            if (FiLight == true) {
                lightFilters = [
            //        CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.85])!
                    CIFilter(name: "CISharpenLuminance", parameters: ["inputSharpness": 1.5])!,
                    CIFilter(name: "CIColorControls", parameters: ["inputContrast": 0.55])!
                ]
            } else {
                lightFilters = [CIFilter]()
            }
            FiLight.toggle()
            refreshView()
            
        case [.command, .shift] where event.characters == "h":
            label.isHidden.toggle()
            
        case [.shift] where event.characters == "?":
            let helpText =
                """
                j/k: scroll
                1-9: prefix
                gg: jump to top + prefix
                G: jump to bottom
                H: jump high
                L: jump low
                y: show in finder and copy path
                C: toggle filter clear
                <C-o>: jump back
                /: search
                n/N: next/previous hit
                cmd-H: toggle clean mode
                opt-L:: toggle theme
                cmd-o: open file
                cmd-n: new window
                cmd-N: duplicate window
                ?: toggle help
                """
            
            if label.stringValue == helpText {
                refreshPageCount()
            } else {
                label.stringValue = helpText
                label.font = .systemFont(ofSize: 20)
            }

        /*########################*/
        /*     MARK: - search     */
        /*########################*/
        
        case [] where event.characters == "/", [.command ] where event.characters == "f":
            handleSearchShow()
            
        case [] where event.characters == "n":
            actionList.append(pdfView.currentPage!)
            handleNext()
            
        case [.shift] where event.characters == "N":
            actionList.append(pdfView.currentPage!)
            handlePrev()
        
        case [.shift, .command] where event.characters == "n":
            NotificationCenter.default.post(name: Notification.Name("createWindow"), object: self, userInfo: ["epic": self.windowurl])

            
        case [.command] where event.characters == "o":
            openFile()
        
            
        /*########################*/
        /*     MARK: - helper     */
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
    /*        MARK: - main        */
    /*############################*/
    override func loadView() {
      self.view = NSView()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(initialFile: URL) {
        self.init()
        pdfView.document = PDFDocument(url: initialFile)
        self.windowurl = initialFile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openFile() {

        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["pdf"]
        let i = openPanel.runModal()
        if (i == NSApplication.ModalResponse.OK) {
            print(openPanel.url!)
            path = openPanel.url!
//            return openPanel.url!
//            windows[0]!.window.path = openPanel.url!
//            path = openPanel.url!
            if let document = PDFDocument(url: path!) {
                pdfView.document = document
                self.windowurl = path
            }
        } else {
           if (path == nil) {
               openFile()
           }
       }
    }
    
    var path : (URL?) = nil
//    guard var path = openFile() else { return }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*#########################*/
        /*     MARK: - pdfView     */
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
        /*     MARK: - label     */
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
        /*     MARK: - searcher     */
        /*##########################*/
        
        view.addSubview(searcher)
        searcher.translatesAutoresizingMaskIntoConstraints = false
        searcher.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor, constant: 50).isActive = true
        // TODO: i mean, eh, i dont wanna do this :(


        
        searcher.frame = CGRect(origin: .zero, size: CGSize(width: 150, height: 44))
        searcher.stringValue = "Search..."
        
        searcher.isBezeled = false
        searcher.textColor = darkColors["countText"]!
        searcher.isEditable = true
        searcher.isHidden = true
        searcher.sizeToFit()
        searcher.shadow = shadow
        searcher.backgroundColor = darkColors["pageCount"]!
        searcher.drawsBackground = true
        
        /*#######################*/
        /*     MARK: - files     */
        /*#######################*/
        
        
        /*##########################*/
        /*     MARK: - starters     */
        /*##########################*/
        
        refreshView()
        refreshPageCount()
        
        /*########################*/
        /*    MARK: - notifs      */
        /*########################*/
        
        
        NotificationCenter.default.addObserver (self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearch), name: Notification.Name.PDFDocumentDidFindMatch, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearchBegin), name: Notification.Name.PDFDocumentDidBeginFind, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSearchEnd), name: Notification.Name.PDFDocumentDidEndFind, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleEdit), name: NSText.didChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver (self, selector: #selector(handleSubmit), name: NSText.didEndEditingNotification, object: nil)

    }
    
    
    
    
    /*#################################*/
    /*         MARK: - handelers       */
    /*#################################*/
    
    
    
        /*########################*/
        /*     MARK: - search     */
        /*########################*/
    
    var matches = [PDFSelection]()
    var inMatches = 0
    var matchLen = -1
    
   
    
    @objc func handleEdit(_ notification: NSNotification){
        pdfView.document?.cancelFindString()
        _ = pdfView.document?.beginFindString(searcher.stringValue, withOptions: [.caseInsensitive, .regularExpression])
        searcher.sizeToFit()
    }
    
    @objc func handleSubmit(_ notification: NSNotification){
        // JUST PRESS TAB.

        searcher.isHidden = true
        searcher.isEditable = false
        
        refreshPageCount()
        
    }

    @objc func handleSearch(_ notification: NSNotification){
        if ((notification.object as! PDFDocument) == pdfView.document) {
            let page = notification.userInfo!["PDFDocumentFoundSelection"]! as! PDFSelection
            matches.append(page)
        }
    }
    
    @objc func handleSearchBegin(){
        inMatches = -1
        matches = []
    }
    
    @objc func handleSearchEnd(){
        matchLen = matches.count - 1
    }
    
    func handleNext(){
        if inMatches >= matchLen { inMatches = 0 } else { inMatches += 1 }
        if matchLen > 0 { searchnavHelper() } else {print("nogud")}
    }
    
    func handleSearchShow() {
        searcher.isHidden = false
        searcher.isEditable = true
        searcher.becomeFirstResponder()
        
        let curPage = pdfView.currentPage?.label ?? "0"
        label.stringValue = String(curPage) + "/" + String(pdfView.document!.pageCount)
    }
    
    func handlePrev(){
        if inMatches <= 0 { inMatches = matchLen } else { inMatches -= 1 }
        if matchLen > 0 { searchnavHelper() } else {print("noguud")}
//        pdfView.selectLine(matches[inMatches])
    }
    
    func searchnavHelper(){
        pdfView.go(to: matches[inMatches])
        pdfView.setCurrentSelection(matches[inMatches], animate: true)
        for _ in 1...16  {
            pdfView.scrollLineDown(pdfView)
        }
    }
    
        /*############################*/
        /*    MARK: - refreshers      */
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
            
            searcher.backgroundColor = darkColors["pageCount"]!
            searcher.textColor = darkColors["countText"]!
            
        } else {
            pdfView.contentFilters = lightFilters
            
            label.backgroundColor = lightColors["pageCount"]!
            label.textColor = lightColors["countText"]!
            
            searcher.backgroundColor = lightColors["pageCount"]!
            searcher.textColor = lightColors["countText"]!
        }
    }
    
    func refreshPageCount() {
        label.font = .systemFont(ofSize: 12)
        var matchD = ""
        if matches.count > 0 {
            matchD = ", " + String(matches.count)
        }
        
        let curPage = pdfView.currentPage?.label ?? "0"
        label.stringValue = String(curPage) + "/" + String(pdfView.document!.pageCount) + matchD
    }
}
