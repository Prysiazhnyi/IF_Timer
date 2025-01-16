//
//  SelectPlanView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 16.01.2025.
//

import UIKit

class SelectPlanView: UIViewController {
    
    @IBOutlet weak var viewTab: UIView!
    
    let backgroundColor: UIColor = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        view.backgroundColor = backgroundColor
        viewTab.backgroundColor = backgroundColor
        // Создаем объект UINavigationBarAppearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Убираем прозрачность
        appearance.backgroundColor = backgroundColor // Ваш цвет фона
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Цвет текста заголовка
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Цвет текста большого заголовка
        // Убираем разделительную полосу
        appearance.shadowColor = nil
        // Применяем настройки
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
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
