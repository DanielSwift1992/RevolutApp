import UIKit

protocol DecimalMaskDelegate: class {
    func valueDidChange(value: NSNumber)
}

class DecimalMask: NSObject {
    weak var delegate: DecimalMaskDelegate?
    private var decimalFormater: DecimalFormatting = DecimalFormatter()
    private var lastText: String?
    
    func becomeDelegate(for field: UITextField) {
        field.delegate = self
        field.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func toString(number: NSNumber) -> String? {
        return decimalFormater.formatter.string(from: number)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        textField.text = decimalFormater.toValidString(string: textField.text)
        nootifyDelegateIfCan(text: textField.text)
    }
    
    private func nootifyDelegateIfCan(text: String?) {
        let value = decimalFormater.convertToNumber(string: text)
        delegate?.valueDidChange(value: value)
    }
}

extension DecimalMask: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return decimalFormater.isValid(string: string, in: textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let number = decimalFormater.convertToNumber(string: textField.text)
        textField.text = toString(number: number)
    }
}
