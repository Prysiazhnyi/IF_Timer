//
//  AlertViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 18.01.2025.
//

import UIKit

protocol CustomAlertDelegate: AnyObject {
    func didTapYesButton()   // func didTapNoButton()
}

class CustomAlertViewController: UIViewController {
    
    var parentviewController: ViewController? // Ссылка на первый контроллер
    var resultViewController: ResultViewController? 
    weak var delegate: CustomAlertDelegate?
    
    var isCustomAlertShownMainOrResult = true // true при прек4ращение цикоа на главной, false - при подтверждении удаления данных
    var isStarvationTimeExpiredAlert = false
    
    func showCustomAlert(_ isCustomAlertShownMainOrResult : Bool) {
        //print("isStarvationTimeExpiredAlert - \(isStarvationTimeExpiredAlert)")
        self.isCustomAlertShownMainOrResult = isCustomAlertShownMainOrResult
        
        // Создаем затемнение для фона
        let overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.tag = 999 // Используем тег, чтобы можно было найти и удалить
        self.view.addSubview(overlayView)
        
        // Основной контейнер для алерта
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 15
        alertView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(alertView)
        
        // Заголовок алерта
        let titleLabel = UILabel()
        titleLabel.text = isCustomAlertShownMainOrResult ? "Перервати інтервал голоду?" : "Увага!!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        
        // Сообщение алерта
        let messageLabel = UILabel()
        let tempTextToMain = isStarvationTimeExpiredAlert ? "Ви дійсно хочете перервати інтервал голоду?" : "Ви ще не досягли мети. Ви дійсно\nхочете перервати інтервал голоду?"
        messageLabel.text = isCustomAlertShownMainOrResult ? tempTextToMain : "Запис вашого інтервалу не буде\nзбережено. Ви впевнені, що хочете\nвидалити дані?"
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(messageLabel)
        
        // Кнопка "ТАК"
        let yesButton = UIButton(type: .system)
        yesButton.setTitle("ТАК", for: .normal)
        yesButton.backgroundColor = UIColor(red: 208/255, green: 231/255, blue: 249/255, alpha: 1)
        yesButton.setTitleColor(.black, for: .normal)
        yesButton.layer.cornerRadius = 8
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        alertView.addSubview(yesButton)
        
        // Кнопка "НІ"
        let noButton = UIButton(type: .system)
        noButton.setTitle("НІ", for: .normal)
        noButton.backgroundColor = UIColor(red: 223/255, green: 242/255, blue: 216/255, alpha: 1)
        noButton.setTitleColor(.black, for: .normal)
        noButton.layer.cornerRadius = 8
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        alertView.addSubview(noButton)
        
        // Установка констрейнтов
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            yesButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            yesButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            yesButton.heightAnchor.constraint(equalToConstant: 40),
            
            noButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            noButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 20),
            noButton.widthAnchor.constraint(equalTo: yesButton.widthAnchor),
            noButton.heightAnchor.constraint(equalToConstant: 40),
            noButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20)
        ])
        
    }

    @objc private func yesButtonTapped() {
        print("Нажата кнопка ТАК")
        
        dismissAlert()
        self.dismiss(animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if isCustomAlertShownMainOrResult {
            delegate?.didTapYesButton()
            // Открываем ResultViewController
            if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                resultVC.modalPresentationStyle = .overFullScreen
                resultVC.viewController = parentviewController
                resultVC.timeForStartButton = parentviewController?.tempStartDateForResult
                resultVC.timeForFinishButton = parentviewController?.tempFinishDateForResult
                parentviewController?.present(resultVC, animated: true, completion: nil)
            }
        } else {
            // Открываем основной ViewController
            self.resultViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func noButtonTapped() {
        print("Нажата кнопка НІ")
        dismissAlert()
        // Если нужно просто закрыть алерт, то достаточно его убрать
        self.dismiss(animated: true, completion: nil)
    }
    
    private func dismissAlert() {
        if let overlayView = self.view.viewWithTag(999) {
            overlayView.removeFromSuperview()
        }
    }
    
//MARK: CustomerAllert для отложенного напоминания
    
    static func showAlert(on viewController: UIViewController, message: String) {
            // Создаем контейнер для аллерта
            let alertView = UIView()
            let backgroundTab = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
            alertView.backgroundColor = backgroundTab.withAlphaComponent(0.9)
            alertView.layer.cornerRadius = 10
            alertView.translatesAutoresizingMaskIntoConstraints = false
            
            // Создаем метку с текстом
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.font = UIFont.systemFont(ofSize: 25)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            alertView.addSubview(messageLabel)
//            viewController.view.addSubview(alertView)
            
        // Добавляем алерт на главное окно, а не на текущий viewController
                guard let window = viewController.view.window else { return }
                window.addSubview(alertView)
        
        // Размещаем алерт в центре экрана
                NSLayoutConstraint.activate([
                    alertView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: -50),
                    alertView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                    alertView.widthAnchor.constraint(equalTo: window.widthAnchor, multiplier: 0.8),
                    alertView.heightAnchor.constraint(equalToConstant: 80),  // 150 — это фиксированная высота

                    
                    messageLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
                    messageLabel.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10),
                    messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 10),
                    messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10)
                ])
            
            // Анимация появления
            alertView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                alertView.alpha = 1
            }
            
            // Через 3 секунды скрываем алерт
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                UIView.animate(withDuration: 0.3, animations: {
                    alertView.alpha = 0
                }) { _ in
                    alertView.removeFromSuperview()
                }
            }
        }
}
