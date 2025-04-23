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
    var timer : Timer = Timer()
    
    private var menuManager: MenuManager!
    private var clipboardManager: ClipboardManager!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize managers
        menuManager = MenuManager()
        clipboardManager = ClipboardManager.shared
        
        // Get most recent copy and apply to list if not on top of list - every second
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkClipboard), userInfo: nil, repeats: true)        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer.invalidate()
    }
    
    @objc private func checkClipboard() {
        if clipboardManager.hasChanged() {
            if let currentText = clipboardManager.getCurrentCopy() {
                menuManager.addItem(currentText)
            }
        }
    }
}
