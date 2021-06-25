import Foundation

public extension Sticker.StickerData {
    init?(image: UIImage) {
        if let data = image.pngData() {
            self = .image(data)
        } else {
            return nil
        }
    }
}
