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
    var window: NSWindow!

    @IBAction func onClick(_ sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.runModal()
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        window = NSWindow()
        window.styleMask = NSWindow.StyleMask(rawValue: 0xf)
        window.backingType = .buffered
        window.contentViewController = ViewController()
        window.setFrame(NSRect(x: 700, y: 200, width: 500, height: 500), display: false)
        windowController = NSWindowController()
        windowController.contentViewController = window.contentViewController
        windowController.window = window
        windowController.showWindow(self)
        /*NewWindowController.contentViewController = window.contentViewController
        NewWindowController.window = window
        NewWindowController.showWindow(nil)*/
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.runModal()
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
