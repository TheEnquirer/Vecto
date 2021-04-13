//
//  AppDelegate.swift
//  Vecto
//
//  Created by Huxley Marvit on 2/11/21.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    //var windowController: NSWindowController!
    var windows: [NSWindowController?] = []


    @IBAction func onClick(_ sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["pdf"]
        let i = openPanel.runModal()
        if (i == NSApplication.ModalResponse.OK) {
            print(openPanel.url!)
            print(sender.parent!)
            windows.append(createWindowPlease(filePath: openPanel.url!))

//            path = openPanel.url!
        }
    }
    
    func createWindowPlease(filePath: URL) -> NSWindowController {
        let window = NSWindow()
        window.styleMask = NSWindow.StyleMask(rawValue: 0xf)
//        window.backingType = .buffered
        window.contentViewController = ViewController(initialFile: filePath)
        window.setFrame(NSRect(x: 0, y: 0, width: 500, height: 500), display: false)
        window.titleVisibility = NSWindow.TitleVisibility.hidden;
       
        window.titlebarAppearsTransparent = true;
//        window.styleMask.insert(.fullSizeContentView)
        window.styleMask.insert(.fullSizeContentView)


       // window.styleMask = NSWindow.StyleMask(rawValue: NSFullSizeContentViewWindowMask.rawValue);
        //window.titleVisibility = NSWindow.titleHidden;
//        window.titlebarAppearsTransparent = true;
        //window.styleMask = NSWindow.StyleMask(rawValue: NSFullSizeContentViewWindowMask.rawValue);
        let windowController = NSWindowController()
        windowController.contentViewController = window.contentViewController
        windowController.window = window
        windowController.showWindow(self)
        
        
        return windowController
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["pdf"]
        if (aNotification.userInfo!["NSApplicationLaunchIsDefaultLaunchKey"]! as! Int == 1) {
            let i = openPanel.runModal()
            if (i == NSApplication.ModalResponse.OK) {
                windows.append(createWindowPlease(filePath: openPanel.url!))
            } else {
                NSApplication.shared.terminate(self)
            }
        }

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
        /*
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true*/
//        openPanel.runModal()
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        print(urls, "running")
        for i in urls {
            windows.append(createWindowPlease(filePath: i))
        }
    }

}
