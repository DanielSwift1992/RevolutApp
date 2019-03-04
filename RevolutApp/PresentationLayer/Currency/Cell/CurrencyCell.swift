import UIKit

final class CurrencyCell: UITableViewCell, NibReusable, Weakifiable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var currencyField: UITextField!
    
    private var observationEditing: NSKeyValueObservation?
    private var observationValue: NSKeyValueObservation?
    
    private weak var delegate: RateDelegate?
    private var decimalFormatter = DecimalMask()
    
    func configure(item: Rate, delegate: RateDelegate? = nil) {
        self.delegate = delegate
        decimalFormatter.becomeDelegate(for: currencyField)
        decimalFormatter.delegate = self
        
        titleLabel.text = item.symbol ?? item.name
        
        setObserver(item)
        changeValue(item)
        setEdinig(item)
    }
    
    private func setObserver(_ item: Rate) {
        let isEditingHandler = weak(self|.setEdinig)
        let resultValueHandler = weak(self|.changeValue)
        
        observationEditing = item.observe(\.isEditing, changeHandler: isEditingHandler)
        observationValue = item.observe(\.resultValue, changeHandler: resultValueHandler)
    }
    
    private func changeValue(_ item: Rate, _ key: Any? = nil) {
        guard currencyField.isFirstResponder == false else { return }
        currencyField.text = decimalFormatter.toString(number: item.resultValue as NSNumber)
    }
    
    private func setEdinig(_ item: Rate, _ key: Any? = nil) {
        item.isEditing
            ? startEdditing()
            : finishEdditing()
    }
    
    private func startEdditing() {
        guard isSelected else { return }
        currencyField.isEnabled = true
        currencyField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) { self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3) }
    }
    
    private func finishEdditing() {
        currencyField.isEnabled = false
        currencyField.endEditing(true)
        UIView.animate(withDuration: 0.3) { self.backgroundColor = .white }
    }
}

extension CurrencyCell: DecimalMaskDelegate {
    func valueDidChange(value: NSNumber) {
        guard isSelected else { return }
        let value = Double(truncating: value)
        delegate?.baseRateDidChange(value: value)
    }
}
