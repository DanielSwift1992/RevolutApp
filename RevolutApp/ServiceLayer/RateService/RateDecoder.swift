import Foundation

final class RateDecoder: DataDecodable {
    typealias T = [Rate]
    
    static func decode(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let resultData = try decoder.decode(RateContainer.self, from: data)
        
        return convertToRates(resultData)
    }
    
    private static func convertToRates(_ container: RateContainer) -> T {
        var rates = container.rates.map { Rate(name: $0.key, value: $0.value) }
        addBase(rates: &rates, base: container.base)
        addCurrencySymbol(rates: &rates)
        return rates
    }
    
    private static func addBase(rates: inout [Rate], base: String) {
        guard rates.firstIndex(where: { $0.name == base }) == nil else { return }
        let baseRate = Rate(name: base, value: 1)
        rates.insert(baseRate, at: 0)
    }
    
    private static func addCurrencySymbol(rates: inout [Rate]) {
        rates.forEach {
            $0.symbol = Locale.currencySymbolFromCode(code: $0.name)
        }
    }
}

final private class RateContainer: Decodable {
    var base: String
    var rates: [String : Double]
}

