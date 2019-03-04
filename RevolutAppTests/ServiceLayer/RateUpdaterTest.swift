import XCTest
@testable import RevolutApp

class RateUpdaterTest: XCTestCase {
    var rateUpdater: RatesUpdatable!
    
    override func setUp() {
        rateUpdater = RatesUpdater()
    }

    override func tearDown() {
        rateUpdater = nil
    }
    
    func testUpdateData() {
        let rates = [
            Rate(name: "EUR", value: 1.0),
            Rate(name: "NOK", value: 1.0),
            Rate(name: "CAD", value: 1.0),
        ]
        
        let updatedRates = [
            Rate(name: "EUR", value: 2.0),
            Rate(name: "PHP", value: 1.0),
            Rate(name: "NOK", value: 2.1),
        ]
        
        rateUpdater.update(items: rates, with: updatedRates)
        
        let isInsertedCorrectly = rateUpdater.pathsToInsert == [IndexPath(row: 2, section: 0)]
        XCTAssert(isInsertedCorrectly)
        
        let isRemovedCorrectly = rateUpdater.pathsToRemove == [IndexPath(row: 2, section: 0)]
        XCTAssert(isRemovedCorrectly)
        
        let isUpdatedCorrectly = rates[1].value == 2.1 && rates.first?.value == 1.0
        XCTAssert(isUpdatedCorrectly)
    }
}
