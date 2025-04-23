import Cocoa

class ClipboardManager {
    static let shared = ClipboardManager()
    private let pasteboard = NSPasteboard.general
    private let queue = DispatchQueue(label: "com.dignan.copyclip.clipboard")
    private var lastChangeCount: Int = 0
    
    private init() {
        lastChangeCount = pasteboard.changeCount
    }
    
    func getCurrentCopy() -> String? {
        return pasteboard.string(forType: .string)
    }
    
    func setClipboard(text: String) -> Bool {
        pasteboard.clearContents()
        return pasteboard.setString(text, forType: .string)
    }
    
    func hasChanged() -> Bool {
        let currentChangeCount = pasteboard.changeCount
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            return true
        }
        return false
    }
} 
