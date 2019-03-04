import Foundation

protocol Weakifiable: class {}

extension Weakifiable {
    func weak<T>(_ closure: @escaping (Self) -> (T) -> Void) -> (T) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            return closure(self)($0)
        }
    }
    
    func weak<T, U>(_ closure: @escaping (Self) -> (T, U) -> Void) -> (T, U) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            return closure(self)($0, $1)
        }
    }
    
    func weak<T, U, V, W>(_ closure: @escaping (Self) -> (T, U, V, W) -> Void, _ argument1: U, _ argument2: V, _ argument3: W) -> (T) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            return closure(self)($0, argument1, argument2, argument3)
        }
    }
}
