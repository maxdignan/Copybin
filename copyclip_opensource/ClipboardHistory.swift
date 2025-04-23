import Foundation

class ClipboardHistory {
    static let shared = ClipboardHistory()
    private let userDefaults = UserDefaults.standard
    private let historyKey = "clipboardHistory"
    private let maxItems = 1000
    
    private init() {}
    
    func loadHistory() -> [String] {
        return userDefaults.stringArray(forKey: historyKey) ?? []
    }
    
    func saveHistory(_ items: [String]) {
        userDefaults.set(items, forKey: historyKey)
    }
    
    func addItem(_ text: String, to items: inout [String]) {
        if items.first != text {
            items.insert(text, at: 0)
            if items.count > maxItems {
                items.removeLast()
            }
            saveHistory(items)
        }
    }
    
    func clearHistory() {
        userDefaults.removeObject(forKey: historyKey)
    }
} 