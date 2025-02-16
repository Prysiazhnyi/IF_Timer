//
//  MinutesPickerManager.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 15.02.2025.
//

import UIKit

class MinutesPickerManager: NSObject {
    private var pickerView: UIPickerView
    private var backgroundView: UIView
    private var pickerContainerView: UIView
    private weak var parentViewController: UIViewController?
    private var completion: ((Int) -> Void)?
    private var isStarvation: Bool

    private let minutesArray = Array(1...240) // Минуты от 1 до 240

    init(parentViewController: UIViewController, isStarvation: Bool) {
        self.parentViewController = parentViewController
        self.isStarvation = isStarvation
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

    func showPicker(completion: @escaping (Int) -> Void) {
        self.completion = completion

        setupPickerContainerView()

        guard let parentView = parentViewController?.view else { return }

        backgroundView.alpha = 0
        pickerContainerView.frame = CGRect(x: 0, y: parentView.frame.height, width: parentView.frame.width, height: 300)

        parentView.addSubview(backgroundView)
        parentView.addSubview(pickerContainerView)

        // Настройка начальной позиции pickerView
        pickerView.selectRow(29, inComponent: 0, animated: false)

        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.pickerContainerView.frame.origin.y = parentView.frame.height - 300
        }
    }

    @objc private func donePressed() {
        let selectedMinutes = minutesArray[pickerView.selectedRow(inComponent: 0)]
        completion?(selectedMinutes * 60) // Преобразуем в секунды
        let selectSecond = selectedMinutes * 60
        NotificationManager.shared.scheduleNotificationReminde(selectSecond, isStarvation)
        
        if let parentVC = parentViewController as? ViewController {
            parentVC.shouldHideRemindeButton = true
        }
        
        // Показать кастомный алерт
        CustomAlertViewController.showAlert(on: parentViewController!, message: "Час відкладено на \(selectedMinutes) хв.")
        
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

extension MinutesPickerManager: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutesArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(minutesArray[row]) хв"
    }

    // Метод для обеспечения начальной позиции (первая минута вверху)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Дополнительные действия при изменении значения можно добавить здесь
    }
}

