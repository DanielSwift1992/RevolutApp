import Foundation

final class CurrencyPresenter: Weakifiable {
    weak var view: CurrencyViewBehavior!
    private var router: CurrencyRouterProtocol
    private var rateService: RateServiceProtocol
    private var ratesUpdater: RatesUpdatable
    private weak var rateEditing: Rate?
    private var isRequestInProcess = false
    
    init(view: CurrencyViewBehavior,
         router: CurrencyRouterProtocol,
         rateService: RateServiceProtocol,
         ratesUpdater: RatesUpdatable) {
        self.view = view
        self.router = router
        self.rateService = rateService
        self.ratesUpdater = ratesUpdater
    }
    
    private func requestRateWithLoader() {
        view.showLoader()
        requestRate()
    }
    
    private func requestRate() {
        guard isRequestInProcess == false else { return }
        isRequestInProcess = true
        rateService.getRates(onSuccess: weak(self|.rateLoadOnSucess),
                                onError: weak(self|.rateLoadOnError))
    }
    
    private func rateLoadOnSucess(_ rates: [Rate]) {
        view.hideLoader()
        isRequestInProcess = false
        
        if view.items.isEmpty {
            view.set(rates: rates)
        } else {
            ratesUpdater.update(items: view.items, with: rates)
            view.batchUpdate(remove: ratesUpdater.pathsToRemove,
                             insert: ratesUpdater.pathsToInsert,
                             items: ratesUpdater.rates)
        }
    }
    
    private func rateLoadOnError(_ error: Error) {
        view.hideLoader()
        isRequestInProcess = false
        router.showAlert(title: error.localizedDescription)
    }
    
    private func updateRates(_ timer: Timer) {
        guard let base = view.items.first?.name,
            isRequestInProcess == false
            else {
                requestRate()
                return
        }
        isRequestInProcess = true
        rateService.getRates(base: base,
                                onSuccess: weak(self|.rateLoadOnSucess),
                                onError: weak(self|.rateLoadOnError))
    }
    
    private func disableRateEditing() {
        rateEditing?.isEditing = false
        rateEditing = nil
        view.finishEditing()
    }
    
    private func changeRateEditing(for rate: Rate) {
        rateEditing?.isEditing = false
        rate.isEditing = true
        rateEditing = rate
    }
    
    private func changePosition(_ rate: Rate) -> IndexPath? {
        guard let rateIndex = view.items.firstIndex(of: rate) else { return nil }
        view.changePosition(from: rateIndex, to: 0)
        setupNewBaseRate()
        return IndexPath(row: rateIndex, section: 0)
    }
    
    private func setupNewBaseRate() {
        guard let baseRate = view.items.first else { return }
        let newValue = baseRate.resultValue
        baseRate.multiplier = 1
        baseRate.value = newValue
    }
}

extension CurrencyPresenter: CurrencyEventHandler {
    func didLoad() {
        requestRateWithLoader()
    }
    
    func setupUpdater(interval: TimeInterval) {
        let updateHandler = weak(self|.updateRates)
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: updateHandler)
    }
    
    func didScroll() {
        guard rateEditing != nil else { return }
        disableRateEditing()
    }
    
    func didSelectItem(at index: Int) {
        let rate = view.items[index]
        guard rate != rateEditing else {
            disableRateEditing()
            return
        }
        
        changeRateEditing(for: rate)
        
        if let rowToMove = changePosition(rate) {
            view.moveToTop(row: rowToMove)
        }
    }
    
    func baseRateDidChange(value: Double) {
        view.items.first?.value = value
        ratesUpdater.updateMultiplier()
    }
}
