//
//  SelectPlanView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 16.01.2025.
//

import UIKit

class SelectPlanView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        view.backgroundColor = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
        
        // Создаем UILabel
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2 // Две строки
        titleLabel.textAlignment = .center // Выравнивание по центру
        titleLabel.textColor = .black // Цвет текста (можно изменить)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18) // Увеличиваем шрифт и делаем его жирным
        titleLabel.text = "Виберіть рівень для запуску\n інтервалу голодування"
        // Устанавливаем UILabel как titleView
        navigationItem.titleView = titleLabel

    }
    
    
}
