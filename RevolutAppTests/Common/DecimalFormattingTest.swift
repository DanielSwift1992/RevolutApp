import XCTest
@testable import RevolutApp

class DecimalMaskFormatterTest: XCTestCase {
    var decimalFormatter: DecimalFormatting!
    var separator: String! { return decimalFormatter.formatter.decimalSeparator }
    
    override func setUp() {
        decimalFormatter = DecimalFormatter()
    }

    override func tearDown() {
        decimalFormatter = nil
    }

    func testConvertToNumber() {
        let isZero = decimalFormatter.convertToNumber(string: "0") == 0
        let isDecimal = decimalFormatter.convertToNumber(string: "1.1") == 1.1
        
        XCTAssert(isZero && isDecimal)
    }
    
    func testIsValidString() {
        var isValid = decimalFormatter.isValid(string: separator, in: "1" + separator)
        XCTAssertFalse(isValid)
        
        isValid = decimalFormatter.isValid(string: "1", in: "1" + separator)
        XCTAssert(isValid)
        
        isValid = decimalFormatter.isValid(string: "s", in: "")
        XCTAssertFalse(isValid)
    }
    
    func testToValidString() {
        var isValid = decimalFormatter.toValidString(string: nil) == nil
        XCTAssert(isValid)
        
        isValid = decimalFormatter.toValidString(string: "") == ""
        XCTAssert(isValid)
        
        isValid = decimalFormatter.toValidString(string: "0" + separator) == "0" + separator
        XCTAssert(isValid)
        
        isValid = decimalFormatter.toValidString(string: "1.") == "1" + separator
        XCTAssert(isValid)
        
        isValid = decimalFormatter.toValidString(string: "1,") == "1" + separator
        XCTAssert(isValid)
        
        isValid = decimalFormatter.toValidString(string: "1.s") == nil
        XCTAssert(isValid)
        
        isValid = decimalFormatter.toValidString(string: "1" + separator + "01") == "1" + separator + "01"
        XCTAssert(isValid)
    }
}
