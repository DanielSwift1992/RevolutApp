import Foundation

public class Rate: NSObject {
    var name: String
    var symbol: String?
    var multiplier: Double = 1 {
        didSet { resultValue = value * multiplier }
    }
    var value: Double {
        didSet { resultValue = value * multiplier }
    }
    @objc dynamic var resultValue: Double = 0
    @objc dynamic var isEditing: Bool = false
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
        self.resultValue = value
    }
}
