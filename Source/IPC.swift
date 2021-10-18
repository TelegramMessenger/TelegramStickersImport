import Foundation
import UIKit

struct IPC {
    private static let DataType = "org.telegram.third-party.stickerset"
    private static let ImportURL = URL(string: "tg://importStickers")!
    private static let ExpirationInterval = TimeInterval(60)
    
    static func canSend() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tg://")!)
    }
    
    static func send(json: [String: Any]) -> Bool {
        let pasteboard = UIPasteboard.general
        
        guard let finalData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return false
        }
        
        if #available(iOS 10.0, *) {
            pasteboard.setItems([[DataType: finalData]], options: [UIPasteboard.OptionsKey.localOnly: true, UIPasteboard.OptionsKey.expirationDate: NSDate(timeIntervalSinceNow: ExpirationInterval)])
        } else {
            pasteboard.setData(finalData, forPasteboardType: DataType)
        }
        
        if canSend() {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(ImportURL)
            } else {
                UIApplication.shared.openURL(ImportURL)
            }
        } else {
            return false
        }
        
        return true
    }
}
