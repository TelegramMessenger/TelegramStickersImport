import Foundation
import UIKit

/// A sticker set
public class StickerSet {
    /// A String value that specifies an identifier of the app using the importing library
    public let software: String
    
    public enum StickerSetType {
        case image
        case animation
        case video
        
        func validateStickerDataType(_ data: Sticker.StickerData) -> Bool {
            switch self {
                case .image:
                    if case .image = data {
                        return true
                    } else {
                        return false
                    }
                case .animation:
                    if case .animation = data {
                        return true
                    } else {
                        return false
                    }
                case .video:
                    if case .video = data {
                        return true
                    } else {
                        return false
                    }
            }
        }
    }
    /// A Boolean value that determines whether the sticker set consists of animated stickers
    public let type: StickerSetType
    
    /// The thumbnail of the sticker set
    public private(set) var thumbnail: Sticker.StickerData?
    
    /// The array of stickers
    public private(set) var stickers: [Sticker]
    
    /**
        Initializes a new sticker set with provided software identificator and type.

        - Parameters:
            - software: Identificator of sticker-generator software
            - type: Type of the sticker set

        - Returns: A sticker set.
        */
    public init(software: String, type: StickerSetType) {
        self.software = software
        self.type = type
        self.stickers = []
    }
    
    private func validateData(_ data: Sticker.StickerData) throws -> Bool {
        switch data {
            case let .image(imageData):
                if imageData.count == 0 {
                    throw StickersError.fileIsEmpty
                }
                if imageData.count > Limits.staticStickerMaxSize {
                    throw StickersError.fileTooBig
                }
                if let image = UIImage(data: imageData) {
                    var dimensionsValid = false
                    if Int(image.size.width) == Limits.stickerDimensionsSide {
                        if Int(image.size.height) > 0 && Int(image.size.height) <= Limits.stickerDimensionsSide {
                            dimensionsValid = true
                        }
                    } else if Int(image.size.height) == Limits.stickerDimensionsSide {
                        if Int(image.size.width) > 0 && Int(image.size.width) <= Limits.stickerDimensionsSide {
                            dimensionsValid = true
                        }
                    }
                    if !dimensionsValid {
                        throw StickersError.invalidDimensions
                    }
                }
            case let .animation(animationData):
                if animationData.count == 0 {
                    throw StickersError.fileIsEmpty
                }
                if animationData.count > Limits.animatedStickerMaxSize {
                    throw StickersError.fileTooBig
                }
            case let .video(videoData):
                if videoData.count == 0 {
                    throw StickersError.fileIsEmpty
                }
                if videoData.count > Limits.videoStickerMaxSize {
                    throw StickersError.fileTooBig
                }
        }
        return true
    }
    
    /**
        Adds a new sticker to the sticker set using the provided data and associated emojis.

        - Parameters:
            - data: Data of the sticker
            - emojis: Associated emojis of the sticker
     
        - Throws:
            `StickersError.countLimitExceeded`
                if `stickers` have already reached the maximum number of items (120).
     
            `StickersError.dataTypeMismatch`
                if `data` is of an animated sticker while the sticker set is not animated and vice versa.
     
            `StickersError.fileTooBig`
                if `data` exceeds the maximum file size for a sticker (PNG: 512Kb, TGS: 64Kb).
     
            `StickersError.invalidDimensions`
                if the sticker has invalid dimensions
        */
    public func addSticker(data: Sticker.StickerData, emojis: [String]) throws {
        if self.stickers.count == Limits.stickerSetStickerMaxCount {
            throw StickersError.countLimitExceeded
        }
        if !self.type.validateStickerDataType(data) {
            throw StickersError.dataTypeMismatch
        }
        if emojis.isEmpty {
            throw StickersError.emojiIsEmpty
        }
        if try self.validateData(data) {
            self.stickers.append(Sticker(data: data, emojis: emojis))
        }
    }
    
    /**
        Sets a thumbnail of the sticker set using the provided data.

        - Parameters:
            - data: Data of the sticker set thumbnail
     
        - Throws:
            `StickersError.dataTypeMismatch`
                if `data` is of an animated sticker when the sticker set is not animated and vice versa.

            `StickersError.fileTooBig`
                if `data` exceeds the maximum file size for a sticker (PNG: 512Kb, TGS: 64Kb).

            `StickersError.invalidDimensions`
                if the sticker has invalid dimensions
        */
    public func setThumbnail(data: Sticker.StickerData) throws {
        if !self.type.validateStickerDataType(data) {
            throw StickersError.dataTypeMismatch
        }
        if try self.validateData(data) {
            self.thumbnail = data
        }
    }
    
    /**
        Initiates an import request for the sticker set
     
        - Throws:
            `StickersError.setIsEmpty`
                if `stickers` is empty.
     
            `StickersError.telegramNotInstalled`
                if Telegram Messenger for iOS is not installed on user's device.
        */
    public func `import`() throws {
        guard TelegramApp.isInstalled() else {
            throw StickersError.telegramNotInstalled
        }
        guard !self.stickers.isEmpty else {
            throw StickersError.setIsEmpty
        }

        var result: [String: Any] = [:]
        result["software"] = self.software
        result["thumbnail"] = self.thumbnail?.data.base64EncodedString()
        result["isAnimated"] = self.type == .animation
        result["isVideo"] = self.type == .video
        
        var stickers: [[String: Any]] = []
        for sticker in self.stickers {
            var stickerDictionary: [String: Any] = [:]
            stickerDictionary["data"] = sticker.data.data.base64EncodedString()
            stickerDictionary["mimeType"] = sticker.data.mimeType
            stickerDictionary["emojis"] = sticker.emojis
            stickers.append(stickerDictionary)
        }
        result["stickers"] = stickers
        
        TelegramApp.send(json: result)
    }
}
