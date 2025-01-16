//
//  SelectPlanView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 16.01.2025.
//

import UIKit

class SelectPlanView: UIViewController {
    
    @IBOutlet weak var viewTab: UIView!
    
    @IBOutlet weak var myPlanLabel: UILabel!
    @IBOutlet weak var basicLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startPlusLabel: UILabel!
    @IBOutlet weak var strongLabel: UILabel!
    @IBOutlet weak var strongPlusLabel: UILabel!
    
    @IBOutlet weak var myPlanButton: UIButton!
    @IBOutlet weak var basicButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startPlusButton: UIButton!
    @IBOutlet weak var strongButton: UIButton!
    @IBOutlet weak var strongPlusButton: UIButton!
    
    var selectsButtons: [UIButton] = []
    let backgroundColor: UIColor = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
    // Переменная для отслеживания состояния выбора
    var isSelectedMode: Bool = false
    let labelLayer = UILabel()
    var buttonSelectTempButton: UIButton!
    
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
        
        selectsButtons = [myPlanButton, basicButton, startButton, startPlusButton, strongButton, strongPlusButton]
        
        setupButton()
    }
    
    private func setupButton() {
        
        for button in selectsButtons {
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.clear.cgColor // Без обводки по умолчанию
            button.titleLabel?.numberOfLines = 2
            button.backgroundColor = UIColor.white
        }
    }
    
    private func setupButton2() {
        basicButton.layer.cornerRadius = 25
        basicButton.layer.borderWidth = 2
        basicButton.layer.borderColor = UIColor.clear.cgColor // Без обводки по умолчанию
        basicButton.setTitle("16-8\n⚡⚡⚡", for: .normal)
        basicButton.titleLabel?.numberOfLines = 2
        basicButton.titleLabel?.textAlignment = .left // Текст слева
        basicButton.backgroundColor = UIColor.white
        
        
    }
    
    @IBAction func myPlanButtonTapped(_ sender: UIButton) {
        
        deleteSelectPlanView()
        selectPlanView(sender)
    }
    
    @IBAction func basicButtonTapped(_ sender: UIButton) {
        
        deleteSelectPlanView()
        selectPlanView(sender)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        deleteSelectPlanView()
        selectPlanView(sender)
    }
    
    @IBAction func startPlusButtonTapped(_ sender: UIButton) {
        
        deleteSelectPlanView()
        selectPlanView(sender)
    }
    
    @IBAction func strongButtonTapped(_ sender: UIButton) {
        
        deleteSelectPlanView()
        selectPlanView(sender)
    }
    
    @IBAction func strongPlusButtonTapped(_ sender: UIButton) {
        
        deleteSelectPlanView()
        selectPlanView(sender)
    }
    
    
    func selectPlanView(_ button: UIButton) {
        
        buttonSelectTempButton = button
        button.layer.borderColor = UIColor.systemGreen.cgColor // Зелёная обводка
        
        // Создание метки
        
        labelLayer.text = "Вибраний"
        labelLayer.textColor = .black
        labelLayer.layer.cornerRadius = 10 // Устанавливаем радиус скругления
        labelLayer.clipsToBounds = true   // Включаем обрезку содержимого для применения скругления
        labelLayer.font = UIFont.boldSystemFont(ofSize: 14)
        labelLayer.textAlignment = .center
        labelLayer.backgroundColor = .green
        labelLayer.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавление метки на главный view
        view.addSubview(labelLayer)
        
        // Настройка Auto Layout для метки
        NSLayoutConstraint.activate([
            labelLayer.centerXAnchor.constraint(equalTo: button.centerXAnchor), // Центрировать по горизонтали относительно кнопки
            labelLayer.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 15), // Привязка к верхней границе кнопки с небольшим смещением
            labelLayer.widthAnchor.constraint(greaterThanOrEqualToConstant: 100), // Минимальная ширина метки
            labelLayer.heightAnchor.constraint(equalToConstant: 30) // Высота метки
        ])
    }
    
    func deleteSelectPlanView() {
        if let buttonselect = buttonSelectTempButton {
            buttonselect.layer.borderColor = UIColor.clear.cgColor
            labelLayer.removeFromSuperview()
        }
    }
    
}
