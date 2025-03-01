import UIKit

class WeightInputManager: NSObject {
    private var pickerView: UIPickerView
    private var backgroundView: UIView
    private var pickerContainerView: UIView
    private weak var parentViewController: UIViewController?
    private var completion: ((Double) -> Void)?

    private var selectedWhole = 75
    private var selectedDecimal = 0.0

    private let wholeNumbers = Array(50...150)
    private let decimalParts = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]

    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.pickerView = UIPickerView()
        self.backgroundView = UIView(frame: UIScreen.main.bounds)
        self.pickerContainerView = UIView()
        super.init()
        configurePickerView()
        configureBackgroundView()
    }

    private func configurePickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func configureBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPicker)))
    }

    private func setupPickerContainerView() {
        pickerContainerView.backgroundColor = .white
        pickerContainerView.layer.cornerRadius = 12
        pickerContainerView.clipsToBounds = true

        let toolbar = UIView()
        toolbar.backgroundColor = UIColor.systemGray6

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Скасувати", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        cancelButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)

        toolbar.addSubview(cancelButton)
        toolbar.addSubview(doneButton)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        pickerContainerView.addSubview(toolbar)
        pickerContainerView.addSubview(pickerView)

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: pickerContainerView.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),

            cancelButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            doneButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -16),
            doneButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
    }

    func showWeightPicker(startWeight: Double, completion: @escaping (Double) -> Void) {
        selectedWhole = Int(startWeight)
        selectedDecimal = startWeight - Double(selectedWhole)
        self.completion = completion

        setupPickerContainerView()

        pickerView.selectRow(wholeNumbers.firstIndex(of: selectedWhole) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(decimalParts.firstIndex(of: selectedDecimal) ?? 0, inComponent: 1, animated: false)

        guard let parentView = parentViewController?.view else { return }

        backgroundView.alpha = 0
        pickerContainerView.frame = CGRect(
            x: 0,
            y: parentView.frame.height,
            width: parentView.frame.width,
            height: 300
        )

        parentView.addSubview(backgroundView)
        parentView.addSubview(pickerContainerView)

        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.pickerContainerView.frame.origin.y = parentView.frame.height - 300
        }
    }

    @objc private func donePressed() {
        completion?(Double(selectedWhole) + selectedDecimal)
        dismissPicker()
    }

    @objc private func dismissPicker() {
        guard let parentView = parentViewController?.view else { return }

        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.pickerContainerView.frame.origin.y = parentView.frame.height
        }) { _ in
            self.backgroundView.removeFromSuperview()
            self.pickerContainerView.removeFromSuperview()
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension WeightInputManager: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? wholeNumbers.count : decimalParts.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(wholeNumbers[row])" : String(format: "%.1f", decimalParts[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedWhole = wholeNumbers[row]
        } else {
            selectedDecimal = decimalParts[row]
        }
    }
}

