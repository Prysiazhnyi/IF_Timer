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
    
    // Функция для отображения кастомного алерта
    func showCustomAlert() {
        
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
        titleLabel.text = "Перервати інтервал голоду?"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        
        // Сообщение алерта
        let messageLabel = UILabel()
        messageLabel.text = "Ви дійсно хочете перервати інтервал голоду?"
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
        delegate?.didTapYesButton()
        dismissAlert()
        // Если нужно просто закрыть алерт, то достаточно его убрать
        self.dismiss(animated: true, completion: nil)
        
        // Инициализируем ResultViewController из Storyboard
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
        //let resultVC = ResultViewController(viewController: parentviewController!)
               resultVC.modalPresentationStyle = .fullScreen
               resultVC.viewController = parentviewController!
               parentviewController?.present(resultVC, animated: true, completion: nil)
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
}
