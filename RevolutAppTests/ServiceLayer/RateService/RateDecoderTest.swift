import XCTest
@testable import RevolutApp

class RateDecoderTest: XCTestCase {
    let data =  """
    {"base":"CHF","date":"2018-09-06","rates":{"AUD":1.4353,"BGN":1.7366,"BRL":4.2548,"CAD":1.3619,"CNY":7.0546,"CZK":22.833,"DKK":6.621,"GBP":0.79757,"HKD":8.1089,"HRK":6.6009,"HUF":289.9,"IDR":15382.0,"ILS":3.7032,"INR":74.335,"ISK":113.48,"JPY":115.03,"KRW":1158.5,"MXN":19.859,"MYR":4.2727,"NOK":8.6804,"NZD":1.5656,"PHP":55.577,"PLN":3.8344,"RON":4.1186,"RUB":70.656,"SEK":9.4034,"SGD":1.4207,"THB":33.857,"TRY":6.7733,"USD":1.033,"ZAR":15.826,"EUR":0.88793}}
    """.data(using: .utf8)
    
    func testLoadRates() {
        let result = try! RateDecoder.decode(data!)
        XCTAssert(result.count > 0)
    }
    
}
