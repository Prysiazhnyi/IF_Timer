// WeightInputManager.swift
import UIKit

class WeightInputManager: NSObject {
    private var selectedWhole = 75
    private var selectedDecimal = 0.0

    func showWeightInputAlert(from viewController: UIViewController, completion: @escaping (Double) -> Void) {
        let alert = UIAlertController(title: "Введіть вагу", message: "Виберіть вашу вагу (кг)", preferredStyle: .alert)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        alert.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor, constant: -20),
            pickerView.widthAnchor.constraint(equalToConstant: 200),
            pickerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let wholeNumbers = Array(50...150)
        let decimalParts = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        
        pickerView.selectRow(wholeNumbers.firstIndex(of: selectedWhole) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(decimalParts.firstIndex(of: selectedDecimal) ?? 0, inComponent: 1, animated: false)
        
        let okAction = UIAlertAction(title: "Зберегти", style: .default) { _ in
            let weight = Double(self.selectedWhole) + self.selectedDecimal
            completion(weight)
        }
        
        let cancelAction = UIAlertAction(title: "Скасувати", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil) // Проверяем, что viewController — это UIViewController
    }
}

// Расширение для UIPickerViewDelegate и UIPickerViewDataSource
extension WeightInputManager: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? Array(50...150).count : [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        component == 0 ? "\(Array(50...150)[row])" : String(format: "%.1f", [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9][row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedWhole = Array(50...150)[row]
        } else {
            selectedDecimal = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9][row]
        }
    }
}
