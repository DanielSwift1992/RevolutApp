import Foundation
import DITranquillity

protocol DecimalFormatting {
    var formatter: NumberFormatter { get }
    func isValid(string: String, in text: String?) -> Bool
    func convertToNumber(string: String?) -> NSNumber
    func toValidString(string: String?) -> String?
}

class DecimalFormatter: DecimalFormatting {
    let formatter = NumberFormatter().apply {
        $0.numberStyle = .decimal
        $0.usesGroupingSeparator = false
        $0.locale = Locale.current
    }
    
    func isValid(string: String, in text: String?) -> Bool {
        var string = string
        changeSeparatorIfNeeded(&string)
        
        if let text = text,
            string.contains(formatter.decimalSeparator),
            text.contains(formatter.decimalSeparator) {
            return false
        }
        
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil,
            string.isEmpty == false,
            string != formatter.decimalSeparator {
            return false
        }
        
        return true
    }
    
    // BUG-FIX for: Decimal Separator of Decimal Pad differs from Locale.current.decimalSeparator
    private func changeSeparatorIfNeeded(_ string: inout String) {
        let coma = ","
        let point = "."
        
        guard string.contains(coma) || string.contains(point) else {
            return
        }
        
        let diffSeparator = formatter.decimalSeparator == coma ? point : coma
        string = string.replacingOccurrences(of: diffSeparator, with: formatter.decimalSeparator)
    }
    
    func convertToNumber(string: String?) -> NSNumber {
        guard var string = string else { return 0 }
        changeSeparatorIfNeeded(&string)
        removeSeparatorIfLast(&string)
        
        guard string.isEmpty == false,
            let number = formatter.number(from: string) else { return 0 }
        
        return number
    }
    
    private func removeSeparatorIfLast(_ string: inout String) {
        if let lastCharacter = string.last,
            String(lastCharacter) == Locale.current.decimalSeparator {
            string.removeLast()
        }
    }
    
    func toValidString(string: String?) -> String? {
        guard var string = string else { return nil }
        changeSeparatorIfNeeded(&string)
        adjustIfDecimalIsFirst(&string)
        
        if isContainsOnlyNumbers(string) == false { return nil }
        return string
    }
    
    private func adjustIfDecimalIsFirst(_ string: inout String) {
        guard string == formatter.decimalSeparator else { return }
        let startIndex = string.startIndex
        let zeroCharacter = Character(String(0))
        string.insert(zeroCharacter, at: startIndex)
    }
    
    private func isContainsOnlyNumbers(_ string: String) -> Bool {
        let string = string.replacingOccurrences(of: formatter.decimalSeparator, with: String())
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
}
