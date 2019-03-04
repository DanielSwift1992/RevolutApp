import UIKit

protocol CurrencyViewBehavior: class {
    func showLoader()
    func hideLoader()
    func set(rates: [Rate])
    func batchUpdate(remove: [IndexPath], insert: [IndexPath], items: [Rate])
    func changePosition(from: Int, to: Int)
    func moveToTop(row: IndexPath)
    func finishEditing()
    var items: [Rate] { get }
}

protocol CurrencyEventHandler: RateDelegate {
    func didLoad()
    func setupUpdater(interval: TimeInterval)
    func didScroll()
    func didSelectItem(at index: Int)
}

protocol RateDelegate: class {
    func baseRateDidChange(value: Double)
}
