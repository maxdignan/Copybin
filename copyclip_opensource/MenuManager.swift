import Cocoa

class MenuManager: NSObject {
    private let statusBar = NSStatusBar.system
    private var statusBarItem: NSStatusItem
    private let menu = NSMenu()
    private var copiedTexts: [String] = []
    private let maxItems = 1000
    private let searchField = NSSearchField()
    private var filteredTexts: [String] = []
    private var currentClipboardItem: String?
    
    override init() {
        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.menu = menu
        statusBarItem.button?.title = "Copybin"
        
        super.init()
        
        // Load saved history
        copiedTexts = ClipboardHistory.shared.loadHistory()
        
        // Set up search field
        searchField.placeholderString = "Search clipboard history..."
        searchField.target = self
        searchField.action = #selector(searchFieldChanged)
        searchField.setAccessibilityLabel("Search clipboard history")
        
        rebuildMenu()
    }
    
    func addItem(_ text: String) {
        ClipboardHistory.shared.addItem(text, to: &copiedTexts)
        currentClipboardItem = text
        rebuildMenu()
    }
    
    func clearItems() {
        copiedTexts.removeAll()
        currentClipboardItem = nil
        ClipboardHistory.shared.clearHistory()
        rebuildMenu()
    }
    
    private func rebuildMenu() {
        menu.removeAllItems()
        
        // Add search field
        let searchItem = NSMenuItem()
        searchItem.view = searchField
        menu.addItem(searchItem)
        
        // Add clear option
        let clearItem = NSMenuItem(title: "Clear History", action: #selector(clearHistory), keyEquivalent: "c")
        clearItem.keyEquivalentModifierMask = [.command]
        clearItem.target = self
        clearItem.setAccessibilityLabel("Clear clipboard history")
        menu.addItem(clearItem)
        
        // Add separator
        menu.addItem(NSMenuItem.separator())
        
        // Add clipboard items
        let itemsToShow = filteredTexts.isEmpty ? copiedTexts : filteredTexts
        itemsToShow.enumerated().forEach { index, text in
            let menuItem = NSMenuItem()
            menuItem.title = truncateText(text)
            menuItem.action = #selector(menuItemSelected(sender:))
            menuItem.target = self
            
            // Add keyboard shortcuts (1-9)
            if index < 9 {
                menuItem.keyEquivalent = String(index + 1)
            }
            
            // Add visual indication for current clipboard item
            if text == currentClipboardItem {
                menuItem.state = .on
            }
            
            // Add accessibility support
            menuItem.setAccessibilityLabel("Clipboard item \(index + 1)")
            menuItem.setAccessibilityLabel(text)
            menuItem.setAccessibilityHelp("Press to copy this item to clipboard")
            
            menu.addItem(menuItem)
        }
        
        // Add error message if no items
        if itemsToShow.isEmpty {
            let noItemsItem = NSMenuItem(title: "No items in clipboard history", action: nil, keyEquivalent: "")
            noItemsItem.isEnabled = false
            noItemsItem.setAccessibilityLabel("No items in clipboard history")
            menu.addItem(noItemsItem)
        }
    }
    
    private func truncateText(_ text: String) -> String {
        let maxLength = 50
        if text.count > maxLength {
            return text.prefix(maxLength) + "..."
        }
        return text
    }
    
    @objc private func clearHistory() {
        clearItems()
    }
    
    @objc private func menuItemSelected(sender: AnyObject) {
        if let menuItem = sender as? NSMenuItem {
            let selectedText = menuItem.title
            if ClipboardManager.shared.setClipboard(text: selectedText) {
                currentClipboardItem = selectedText
                rebuildMenu()
            } else {
                showError("Failed to copy item to clipboard")
            }
        }
    }
    
    @objc private func searchFieldChanged() {
        let searchText = searchField.stringValue.lowercased()
        if searchText.isEmpty {
            filteredTexts = []
        } else {
            filteredTexts = copiedTexts.filter { $0.lowercased().contains(searchText) }
        }
        rebuildMenu()
    }
    
    private func showError(_ message: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.runModal()
    }
} 
