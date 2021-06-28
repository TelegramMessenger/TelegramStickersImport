import Foundation
import UIKit

/// A sticker set
public class StickerSet {
    /// A String value that specifies an identifier of the app using the importing library
    public let software: String
    
    /// A Boolean value that determines whether the sticker set consists of animated stickers
    public let isAnimated: Bool
    
    /// The thumbnail of the sticker set
    public private(set) var thumbnail: Sticker.StickerData?
    
    /// The array of stickers
    public private(set) var stickers: [Sticker]
    
    /**
        Initializes a new sticker with the provided data and associated emojis.

        - Parameters:
            - software: Data of the sticker
            - isAnimated: Whether the sticker set consists of animated stickers

        - Returns: A sticker set.
        */
    public init(software: String, isAnimated: Bool) {
        self.software = software
        self.isAnimated = isAnimated
        self.stickers = []
    }
    
    private func validateData(_ data: Sticker.StickerData) throws -> Bool {
        switch data {
            case let .image(imageData):
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
                if animationData.count > Limits.animatedStickerMaxSize {
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
        if data.isAnimated != self.isAnimated {
            throw StickersError.dataTypeMismatch
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
        if data.isAnimated != self.isAnimated {
            throw StickersError.dataTypeMismatch
        }
        if try self.validateData(data) {
            self.thumbnail = data
        }
    }
    
    /**
        Initiates an import request for the sticker set
     
        - Throws: `StickersError.setIsEmpty`
                    if `stickers` is empty.
        */
    public func `import`() throws {
        if self.stickers.isEmpty {
            throw StickersError.setIsEmpty
        }
        
        var result: [String: Any] = [:]
        result["software"] = self.software
        result["thumbnail"] = self.thumbnail?.data.base64EncodedString()
        result["isAnimated"] = self.isAnimated
        
        var stickers: [[String: Any]] = []
        for sticker in self.stickers {
            var stickerDictionary: [String: Any] = [:]
            stickerDictionary["data"] = sticker.data.data.base64EncodedString()
            stickerDictionary["mimeType"] = sticker.data.mimeType
            stickerDictionary["emojis"] = sticker.emojis
            stickers.append(stickerDictionary)
        }
        result["stickers"] = stickers
        
        let _ = IPC.send(json: result)
    }
}
