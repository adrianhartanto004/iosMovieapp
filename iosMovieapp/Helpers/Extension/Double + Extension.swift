import Foundation

extension Double {
    func toDecimals() -> String {
        return String(format: "%0.2f", self)
    }
}
