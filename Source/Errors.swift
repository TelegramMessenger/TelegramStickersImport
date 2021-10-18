import Foundation

public enum StickersError: Error {
    case fileTooBig
    case invalidDimensions
    case countLimitExceeded
    case dataTypeMismatch
    case setIsEmpty
    case telegramNotInstalled
}
