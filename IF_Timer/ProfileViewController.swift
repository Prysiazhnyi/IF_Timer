//
//  ProfileViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 25.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var viewTab: UIView!
    
    let backgroundTab = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light  // не змінювати тему на чорну
        viewTab.backgroundColor = .clear
        
        title = "Профіль"
        self.view.backgroundColor = backgroundTab
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysOriginal), // SF Symbol с заливкой
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        // Устанавливаем оранжевый цвет
        settingsButton.tintColor = .orange
        navigationItem.rightBarButtonItem = settingsButton
        
        // Создаем объект UINavigationBarAppearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Убираем прозрачность
        appearance.backgroundColor = backgroundTab //  цвет фона экрана
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Цвет текста заголовка
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // Цвет текста большого заголовка
        appearance.shadowColor = nil // Убираем разделительную полосу
        // Применяем настройки
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    
    
    
    
    @objc func openSettings() {
        //        let settingsVC = SettingsViewController() // Замените на ваш класс настроек
        //        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
