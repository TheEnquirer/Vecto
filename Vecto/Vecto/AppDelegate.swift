//
//  AppDelegate.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func onClick(_ sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.runModal()
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
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
