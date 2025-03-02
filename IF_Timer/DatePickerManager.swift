//
//  DatePickerManager.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 15.01.2025.
//

import UIKit

class DatePickerManager: NSObject {
    private var datePicker: UIDatePicker
    private var backgroundView: UIView
    private var pickerContainerView: UIView
    private weak var parentViewController: UIViewController?
    private var completion: ((Date) -> Void)?

    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.datePicker = UIDatePicker()
        self.backgroundView = UIView(frame: UIScreen.main.bounds)
        self.pickerContainerView = UIView()
        super.init()
        configureDatePicker()
        configureBackgroundView()
    }

    private func configureDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "uk_UA")
    }

    private func configureBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPicker)))
    }

    private func setupPickerContainerView() {
        pickerContainerView.backgroundColor = .white
        pickerContainerView.layer.cornerRadius = 12
        pickerContainerView.clipsToBounds = true

        // Верхняя панель с кнопками
        let toolbar = UIView()
        toolbar.backgroundColor = UIColor.systemGray6

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Скасувати", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        cancelButton.setTitleColor(.darkGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        doneButton.setTitleColor(.darkGray, for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)

        toolbar.addSubview(cancelButton)
        toolbar.addSubview(doneButton)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        pickerContainerView.addSubview(toolbar)
        pickerContainerView.addSubview(datePicker)

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Настройка панели с кнопками
            toolbar.topAnchor.constraint(equalTo: pickerContainerView.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),

            cancelButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            doneButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -16),
            doneButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),

            // Настройка UIDatePicker
            datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
    }

    func showDatePicker(mode: UIDatePicker.Mode, startFromDate: Date, completion: @escaping (Date) -> Void) {
        //datePicker.date = Date() // всегда старты с текущей даты
        datePicker.datePickerMode = mode // последняя сохраненная
        datePicker.date = startFromDate // Устанавливаем стартовую дату
        self.completion = completion

        setupPickerContainerView()

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

        // Анимация появления
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.pickerContainerView.frame.origin.y = parentView.frame.height - 300
        }
    }

    @objc private func donePressed() {
        completion?(datePicker.date)
        dismissPicker()
    }

    @objc private func dismissPicker() {
        guard let parentView = parentViewController?.view else { return }

        // Анимация скрытия
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.pickerContainerView.frame.origin.y = parentView.frame.height
        }) { _ in
            self.backgroundView.removeFromSuperview()
            self.pickerContainerView.removeFromSuperview()
        }
    }
}

