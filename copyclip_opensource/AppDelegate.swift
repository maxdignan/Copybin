//
//  AppDelegate.swift
//  copyclip_opensource
//
//  Created by Max Dignan on 9/14/19.
//  Copyright © 2019 Max Dignan. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let MAX_NUMBER_OF_COPIED_TEXTS = 1000

    let statusBar = NSStatusBar.system
    var statusBarItem : NSStatusItem = NSStatusItem()
    let menu = NSMenu()
    var copiedTexts : [Data] = []
    var timer : Timer = Timer()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // https://johnmullins.co/blog/2014/08/08/menubar-app/
        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.menu = menu
        statusBarItem.button?.title = "Copybin"
        
        // Get most recent copy and apply to list if not on top of list - every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.grabCopyApplyOnlyIfNotOnTop), userInfo: nil, repeats: true)        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
    func shell(_ command: String) -> Data {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return data
    }
    
    func getCurrentCopy() -> Data {
        return shell("pbpaste")
    }
    
    func applyStringToSystemPasteQueue(text: String) {
        let executionString = "printf \"\(text)\" | pbcopy"
        let _ = shell(executionString)
    }
    
    @objc func grabCopyApplyOnlyIfNotOnTop() {
        let currentCopiedText = self.getCurrentCopy()
        self.applyToCopiedTextsIfNotOnTop(data: currentCopiedText)
    }
    
    func buildMenu() {
        menu.removeAllItems()
        
        while self.copiedTexts.count > MAX_NUMBER_OF_COPIED_TEXTS {
            self.copiedTexts.remove(at: self.copiedTexts.count - 1)
        }
        
        self.copiedTexts.forEach({ data in
            // Make its new menu item
            let menuItem = NSMenuItem()
            do {
                menuItem.title = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            } catch {
                menuItem.title = "Error writing this copy to string" + data.base64EncodedString()
            }
            menuItem.action = #selector(self.menuItemSelected(sender:))
            menuItem.keyEquivalent = ""
            menu.addItem(menuItem)
        })
    }
    
    func applyToCopiedTextsIfNotOnTop(data: Data) {
        if self.copiedTexts.first != data {
            self.copiedTexts.insert(data, at: 0)
            
            self.buildMenu()
        }
    }
    
    @objc func menuItemSelected(sender: AnyObject) {
        let selectedText  = (sender as! NSMenuItem).title

        print(selectedText)
        applyStringToSystemPasteQueue(text: selectedText)
    }
}

