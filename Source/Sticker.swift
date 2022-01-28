import Foundation
import UIKit

/// A sticker
public class Sticker {
    /// Underlying sticker data
    public enum StickerData {
        /// Static sticker PNG data
        case image(Data)
        
        /// Animated sticker TGS data
        case animation(Data)
        
        /// Video sticker WebM VP9 data
        case video(Data)
        
        /// A Boolean value that determines whether the sticker data contains animation
        var isAnimated: Bool {
            switch self {
                case .image, .video:
                    return false
                case .animation:
                    return true
            }
        }
        
        /// A Boolean value that determines whether the sticker data is video
        var isVideo: Bool {
            switch self {
                case .image, .animation:
                    return false
                case .video:
                    return true
            }
        }
        
        /// Mime-type of sticker data
        var mimeType: String {
            switch self {
                case .image:
                    return "image/png"
                case .animation:
                    return "application/x-tgsticker"
                case .video:
                    return "video/webm"
            }
        }
        
        /// Sticker data
        var data: Data {
            switch self {
                case let .image(data), let .animation(data), let .video(data):
                    return data
            }
        }
    }
    
    /// The data of the sticker
    let data: StickerData
    
    /// Associated emojis of the sticker
    let emojis: [String]
    
    /**
        Initializes a new sticker with the provided data and associated emojis.

        - Parameters:
            - data: Data of the sticker
            - emojis: Associated emojis of the sticker

        - Returns: A sticker.
        */
    init(data: StickerData, emojis: [String]) {
        self.data = data
        self.emojis = emojis
    }
}
