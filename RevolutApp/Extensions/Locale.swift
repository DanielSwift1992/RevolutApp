import Foundation

extension Locale {
    static func currencySymbolFromCode(code: String) -> String? {
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : code])
        let locale = Locale(identifier: localeIdentifier)
        return locale.currencySymbol
    }
}
