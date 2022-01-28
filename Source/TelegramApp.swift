import Foundation
import UIKit

public struct TelegramApp {
    private static let URLScheme = "tg"
    private static let DataType = "org.telegram.third-party.stickerset"
    private static let ImportURL = URL(string: "tg://importStickers")!
    private static let ExpirationInterval = TimeInterval(60)
    
    public static func isInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "\(URLScheme)://")!)
    }

    static func send(json: [String: Any]) {
        guard let finalData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return
        }
                
        let pasteboard = UIPasteboard.general
        if #available(iOS 10.0, *) {
            pasteboard.setItems([[DataType: finalData]], options: [UIPasteboard.OptionsKey.localOnly: true, UIPasteboard.OptionsKey.expirationDate: NSDate(timeIntervalSinceNow: ExpirationInterval)])
        } else {
            pasteboard.setData(finalData, forPasteboardType: DataType)
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(ImportURL)
        } else {
            UIApplication.shared.openURL(ImportURL)
        }
    }
}
