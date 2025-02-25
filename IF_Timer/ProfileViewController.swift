//
//  ProfileViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 25.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let fastingTracker = FastingTracker()
    let chartView = FastingChartView()
    
    @IBOutlet weak var viewTab: UIView!
    
    @IBOutlet weak var achievementsView: UIView!
    @IBOutlet weak var fastingTrackerView: UIView!
    @IBOutlet weak var statisticsFastingView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var imtView: UIView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var mainAchievementLabel: UILabel!
    @IBOutlet weak var firstLabelAchievementLabel: UILabel!
    @IBOutlet weak var firstValueAchievementLabel: UILabel!
    @IBOutlet weak var secondLabelAchievementLabel: UILabel!
    @IBOutlet weak var secondValueAchievementLabel: UILabel!
    @IBOutlet weak var thirdLabelAchievementLabel: UILabel!
    @IBOutlet weak var thirdValueAchievementLabel: UILabel!
    @IBOutlet weak var fourthLabelAchievementLabel: UILabel!
    @IBOutlet weak var fourthValueAchievementLabel: UILabel!
    @IBOutlet weak var fifthLabelAchievementLabel: UILabel!
    @IBOutlet weak var fifthValueAchievementLabel: UILabel!
    @IBOutlet weak var sixthLabelAchievementLabel: UILabel!
    @IBOutlet weak var sixthValueAchievementLabel: UILabel!
    
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
        
        setupView()
        setupSettingsButton()
        
        setupFastingTrackerView()
    }
    
    func setupView() {
        let arrayViews: [UIView] = [achievementsView, fastingTrackerView, statisticsFastingView, weightView, imtView]
        for view in arrayViews {
            view.translatesAutoresizingMaskIntoConstraints = false
            // Настройка контейнера с информацией
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 25
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.1
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 8
            view.layer.masksToBounds = false
            view.layer.masksToBounds = true
        }
    }
    
    func setupSettingsButton() {
        settingsButton.backgroundColor = UIColor.white
        settingsButton.layer.cornerRadius = 15
        settingsButton.layer.masksToBounds = true
        settingsButton.setTitleColor(.darkGray, for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        // Устанавливаем изображение шестеренки перед текстом
        let gearImage = UIImage(systemName: "gearshape.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.darkGray)
        settingsButton.setImage(gearImage, for: .normal)
        
        // Устанавливаем текст кнопки
        settingsButton.setTitle(NSLocalizedString("   Налаштування", comment: ""), for: .normal)
        
        // Настроим отступы между изображением и текстом
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)  // отступ для изображения
        settingsButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)  // отступ для текста
        
    }
    
    func setupFastingTrackerView() {
        chartView.data = fastingTracker.getFastingData().map { ($0.date, $0.hours) }
        
        if fastingTracker.fastingData.isEmpty {
            let emptyImageView = UIImageView(image: UIImage(named: "AppIconFasting"))
            emptyImageView.contentMode = .scaleAspectFit
            emptyImageView.translatesAutoresizingMaskIntoConstraints = false
            fastingTrackerView.addSubview(emptyImageView)
            fastingTrackerView.backgroundColor = UIColor(red: 0.89, green: 0.94, blue: 0.91, alpha: 1.0)
            
            NSLayoutConstraint.activate([
                emptyImageView.centerXAnchor.constraint(equalTo: fastingTrackerView.centerXAnchor),
                emptyImageView.centerYAnchor.constraint(equalTo: fastingTrackerView.centerYAnchor),
                emptyImageView.widthAnchor.constraint(equalTo: fastingTrackerView.heightAnchor, multiplier: 1),
                emptyImageView.heightAnchor.constraint(equalTo: fastingTrackerView.heightAnchor, multiplier: 0.99)
            ])
        } else {
            fastingTrackerView.addSubview(chartView)
            chartView.translatesAutoresizingMaskIntoConstraints = false
            fastingTrackerView.heightAnchor.constraint(equalToConstant: 200).isActive = true // Задай нужную высоту
            
            
            NSLayoutConstraint.activate([
                chartView.leadingAnchor.constraint(equalTo: fastingTrackerView.leadingAnchor, constant: 10),
                chartView.trailingAnchor.constraint(equalTo: fastingTrackerView.trailingAnchor, constant: -10),
                chartView.topAnchor.constraint(equalTo: fastingTrackerView.topAnchor, constant: 10),
                chartView.bottomAnchor.constraint(equalTo: fastingTrackerView.bottomAnchor, constant: -10)
            ])
        }
    }
    
    
    
    @objc func openSettings() {
        //        let settingsVC = SettingsViewController() // Замените на ваш класс настроек
        //        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
