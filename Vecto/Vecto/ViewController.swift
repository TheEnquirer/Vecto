//
//  ViewController.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa
import PDFKit

class ViewController: NSViewController {

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

        
        let pdfView = PDFView()
    
//        var backgroundColor: NSColor { get set }
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        let filters = [CIFilter(name: "CIColorInvert")!]
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

