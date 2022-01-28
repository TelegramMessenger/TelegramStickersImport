import Foundation

public enum StickersError: Error {
    case fileIsEmpty
    case fileTooBig
    case invalidDimensions
    case countLimitExceeded
    case dataTypeMismatch
    case setIsEmpty
    case emojiIsEmpty
    case telegramNotInstalled
}
