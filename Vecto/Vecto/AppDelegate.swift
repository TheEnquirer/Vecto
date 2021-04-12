//
//  AppDelegate.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa

// TODO move this to another file


class MyNewWindow: NSWindowController {
    /*
    convenience init() {
        self.init(windowNibName: "MyNewWindow")
    }
    */
    override func windowDidLoad() {
        super.windowDidLoad()
    }

}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let NewWindowController = MyNewWindow()
    var myName: String = "AppDelegate"
    var windowController: NSWindowController!
    var windows: [NSWindowController?] = []

    @IBAction func onClick(_ sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.runModal()
    }
    
    func createWindowPlease() -> NSWindowController {
        let window = NSWindow()
        window.styleMask = NSWindow.StyleMask(rawValue: 0xf)
//        window.backingType = .buffered
        window.contentViewController = ViewController()
        window.setFrame(NSRect(x: 700, y: 200, width: 500, height: 500), display: false)
        window.titleVisibility = NSWindow.TitleVisibility.hidden;
       
        window.titlebarAppearsTransparent = true;
//        window.styleMask.insert(.fullSizeContentView)
        window.styleMask.insert(.fullSizeContentView)


       // window.styleMask = NSWindow.StyleMask(rawValue: NSFullSizeContentViewWindowMask.rawValue);
        //window.titleVisibility = NSWindow.titleHidden;
//        window.titlebarAppearsTransparent = true;
        //window.styleMask = NSWindow.StyleMask(rawValue: NSFullSizeContentViewWindowMask.rawValue);
        windowController = NSWindowController()
        windowController.contentViewController = window.contentViewController
        windowController.window = window
        windowController.showWindow(self)
        

        
        return windowController
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        windows.append(createWindowPlease())
        windows.append(createWindowPlease())
        
//        window = NSWindow()
//        window.styleMask = NSWindow.StyleMask(rawValue: 0xf)
//        window.backingType = .buffered
//        window.contentViewController = ViewController()
//        window.setFrame(NSRect(x: 700, y: 200, width: 500, height: 500), display: false)
//        windowController = NSWindowController()
//        windowController.contentViewController = window.contentViewController
//        windowController.window = window
//        windowController.showWindow(self)
        /*NewWindowController.contentViewController = window.contentViewController
        NewWindowController.window = window
        NewWindowController.showWindow(nil)*/
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
//        openPanel.runModal()
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
//let storyboard = NSStoryboard(name: "Main", bundle: nil)
////let vc1 = storyboard.instantiateViewControllerWithIdentifier("WebViewController")
////let vc2 = storyboard.instantiateViewControllerWithIdentifier("WebViewController")
//let tester = storyboard.instantiateController(identifier: "test")
