import UIKit

class WeightInputManager: NSObject {
    private var pickerView: UIPickerView
    private var backgroundView: UIView
    private var pickerContainerView: UIView
    private weak var parentViewController: UIViewController?
    private var completion: ((Double, Date) -> Void)? // Обновлено для возврата веса и даты

    private var selectedWhole = 75
    private var selectedDecimal = 0.0
    private var selectedDate: Date = Date() // Новая переменная для хранения даты
    private var datePicker: UIDatePicker?
    private var datePickerContainerView: UIView?

    private let wholeNumbers = Array(30...180)
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
        cancelButton.setTitleColor(.darkGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)

        let changeDateButton = UIButton(type: .system)
        changeDateButton.setTitle("Змінити дату", for: .normal)
        changeDateButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        changeDateButton.setTitleColor(.darkGray, for: .normal)
        changeDateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        doneButton.setTitleColor(.darkGray, for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)

        toolbar.addSubview(cancelButton)
        toolbar.addSubview(changeDateButton)
        toolbar.addSubview(doneButton)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        changeDateButton.translatesAutoresizingMaskIntoConstraints = false
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

            changeDateButton.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            changeDateButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            doneButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -16),
            doneButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor, constant: 120), // Добавляем отступ для центра
            pickerView.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor, constant: -120), // Добавляем отступ для центра
            pickerView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
    }

    func showWeightPicker(startWeight: Double, completion: @escaping (Double, Date) -> Void) {
        selectedWhole = Int(startWeight)
        selectedDecimal = startWeight - Double(selectedWhole)
        selectedDate = Date() // Устанавливаем текущую дату по умолчанию
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

    @objc private func showDatePicker() {
        guard let parentView = parentViewController?.view else { return }

        // Создаем контейнер для datePicker
        datePickerContainerView = UIView(frame: CGRect(x: 0, y: parentView.frame.height, width: parentView.frame.width, height: 300))
        datePickerContainerView?.backgroundColor = .white
        datePickerContainerView?.layer.cornerRadius = 12
        datePickerContainerView?.clipsToBounds = true

        // Создаем toolbar для datePicker
        let dateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: parentView.frame.width, height: 44))
        dateToolbar.barStyle = .default
        dateToolbar.isTranslucent = true

        let cancelDateButton = UIBarButtonItem(title: "Скасувати", style: .plain, target: self, action: #selector(dismissDatePicker))
        cancelDateButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 19), .foregroundColor: UIColor.darkGray], for: .normal)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneDateButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(saveDate))
        doneDateButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 19), .foregroundColor: UIColor.darkGray], for: .normal)
        
        dateToolbar.items = [cancelDateButton, flexibleSpace, doneDateButton]

        // Создаем и настраиваем datePicker
        datePicker = UIDatePicker()
        datePicker?.date = selectedDate
        datePicker?.datePickerMode = .dateAndTime // Режим для выбора даты и времени
        datePicker?.preferredDatePickerStyle = .wheels // Используем колесики для выбора
        datePicker?.locale = Locale(identifier: "uk_UA") // Устанавливаем украинский локаль для месяцев
        datePicker?.timeZone = TimeZone.current // Устанавливаем текущую временную зону
        datePicker?.translatesAutoresizingMaskIntoConstraints = false

        datePickerContainerView?.addSubview(datePicker!)
        datePickerContainerView?.addSubview(dateToolbar)

        dateToolbar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateToolbar.topAnchor.constraint(equalTo: datePickerContainerView!.topAnchor),
            dateToolbar.leadingAnchor.constraint(equalTo: datePickerContainerView!.leadingAnchor),
            dateToolbar.trailingAnchor.constraint(equalTo: datePickerContainerView!.trailingAnchor),
            dateToolbar.heightAnchor.constraint(equalToConstant: 44),

            datePicker!.topAnchor.constraint(equalTo: dateToolbar.bottomAnchor),
            datePicker!.leadingAnchor.constraint(equalTo: datePickerContainerView!.leadingAnchor),
            datePicker!.trailingAnchor.constraint(equalTo: datePickerContainerView!.trailingAnchor),
            datePicker!.bottomAnchor.constraint(equalTo: datePickerContainerView!.bottomAnchor)
        ])

        parentView.addSubview(datePickerContainerView!)

        UIView.animate(withDuration: 0.3) {
            self.datePickerContainerView?.frame.origin.y = parentView.frame.height - 300
        }
    }

    @objc private func dismissDatePicker() {
        guard let parentView = parentViewController?.view, let datePickerContainer = datePickerContainerView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            datePickerContainer.frame.origin.y = parentView.frame.height
        }) { _ in
            datePickerContainer.removeFromSuperview()
            self.datePickerContainerView = nil
            self.datePicker = nil
        }
    }

    @objc private func saveDate() {
        if let newDate = datePicker?.date {
            selectedDate = newDate
        }
        dismissDatePicker()
    }

    @objc private func donePressed() {
        completion?(Double(selectedWhole) + selectedDecimal, selectedDate)
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? wholeNumbers.count : decimalParts.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(wholeNumbers[row])" // Показываем только целое число
        } else {
            // Для десятичных частей убираем ведущий 0
            let decimalString = String(format: "%.1f", decimalParts[row])
            return decimalString.hasPrefix("0") ? String(decimalString.dropFirst()) : decimalString
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedWhole = wholeNumbers[row]
        } else {
            selectedDecimal = decimalParts[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let reusedLabel = view as? UILabel {
            label = reusedLabel
        } else {
            label = UILabel()
        }

        if component == 0 { // Левый барабан (целые числа)
            label.font = UIFont.systemFont(ofSize: 27, weight: .regular) // Увеличиваем шрифт
            label.textAlignment = .right // Выравниваем текст вправо, чтобы "прижать" к правой стороне компонента
        } else { // Правый барабан (десятичные части)
            label.font = UIFont.systemFont(ofSize: 27, weight: .regular) // Стандартный или меньший шрифт
            label.textAlignment = .left // Выравниваем текст влево, чтобы "прижать" к левой стороне компонента
        }

        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        label.textColor = .black
        return label
    }
}
