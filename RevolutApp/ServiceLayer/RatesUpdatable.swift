import Foundation
import DITranquillity

protocol RatesUpdatable {
    var rates: [Rate] { get }
    var pathsToInsert: [IndexPath] { get }
    var pathsToRemove: [IndexPath] { get }
    func update(items: [Rate], with: [Rate])
    func updateMultiplier()
}

class RatesUpdater: RatesUpdatable {
    private(set) var rates: [Rate] = []
    private(set) var pathsToInsert: [IndexPath] = []
    private(set) var pathsToRemove: [IndexPath] = []
    
    func update(items: [Rate], with: [Rate]) {
        prepareForUpdate(items)
    
        removeItemsIfNeeded(items: with)
        updateItemsIfNeeded(items: with)
        insertItemsIfNeeded(items: with)
        updateMultiplier()
    }
    
    private func prepareForUpdate(_ items: [Rate]) {
        rates = items
        pathsToInsert.removeAll()
        pathsToRemove.removeAll()
    }
    
    private func removeItemsIfNeeded(items: [Rate]) {
        guard rates.isEmpty == false else { return }
        for i in 0...rates.count - 1 {
            let rate = rates[i]
            guard items.first(where: { $0.name == rate.name }) == nil else { continue }
            let index = IndexPath(row: i, section: 0)
            pathsToRemove.append(index)
        }
        
        pathsToRemove.sorted(by: { $0.row > $1.row }).forEach { rates.remove(at: $0.row) }
    }
    
    private func updateItemsIfNeeded(items: [Rate]) {
        guard let base = rates.first else { return }
        rates.forEach { item in
            guard let updatedItem = items.first(where: {
                $0.name == item.name
            }),
                item.value != updatedItem.value,
                item != base
                else { return }
            
            item.value = updatedItem.value
        }
    }
    
    private func insertItemsIfNeeded(items: [Rate]) {
        items.forEach { item in
            guard rates.first(where: {
                $0.name == item.name
            }) == nil
                else { return }
            
            rates.append(item)
            let indexToInsert = IndexPath(row: rates.count - 1, section: 0)
            pathsToInsert.append(indexToInsert)
        }
    }
    
    func updateMultiplier() {
        guard let baseRate = rates.first else { return }
        rates.forEach { $0.multiplier = baseRate.value }
        baseRate.multiplier = 1
    }
}

// Mark: - Assembly

final class RatesUpdatablePart: DIPart {
    static func load(container: DIContainer) {
        container.register(RatesUpdater.init)
            .as(RatesUpdatable.self)
            .lifetime(.prototype)
    }
}
