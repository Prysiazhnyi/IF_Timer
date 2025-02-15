//
//  SelectPlanView.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 16.01.2025.
//

import UIKit

class SelectPlanView: UIViewController {
    
    var parentviewController: ViewController? // Ссылка на первый контроллер
    
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
    var selectedButtonTag = 2 // дефолтный план 16-8
    let labelLayer = UILabel()
    var buttonSelectTempButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("selectedButtonTag - \(selectedButtonTag)")
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
        
        // Восстанавливаем выбранную кнопку по tag
        if let selectedButtonTempTag = UserDefaults.standard.value(forKey: "selectedButtonTag") as? Int {
            selectedButtonTag = selectedButtonTempTag
        }
        for button in selectsButtons {
            if button.tag == selectedButtonTag {
                buttonSelectTempButton = button
                selectPlanView(button)
                print("загрузка button.tag")
                
            }
        }
        
    }
    
    private func setupButton() {
        for button in selectsButtons {
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.clear.cgColor
            button.titleLabel?.numberOfLines = 2
            button.backgroundColor = .clear // Убедитесь, что фон прозрачный
            button.setTitle("", for: .normal)
            button.clipsToBounds = true
            button.imageView?.contentMode = .scaleToFill // Изображение масштабируется
        }
        
        // Устанавливаем изображение
        if let image = UIImage(named: "myPlans") {
            let resizedImage = image.resized(to: CGSize(width: 340, height: 140))
            myPlanButton.setImage(resizedImage, for: .normal)
        }
        if let image = UIImage(named: "16-8") {
            let resizedImage = image.resized(to: CGSize(width: 340, height: 140))
            basicButton.setImage(resizedImage, for: .normal)
        }
        if let image = UIImage(named: "12-12") {
            let resizedImage = image.resized(to: CGSize(width: 340, height: 140))
            startButton.setImage(resizedImage, for: .normal)
        }
        if let image = UIImage(named: "14-10") {
            let resizedImage = image.resized(to: CGSize(width: 340, height: 140))
            startPlusButton.setImage(resizedImage, for: .normal)
        }
        if let image = UIImage(named: "18-6") {
            let resizedImage = image.resized(to: CGSize(width: 340, height: 140))
            strongButton.setImage(resizedImage, for: .normal)
        }
        if let image = UIImage(named: "20-4") {
            let resizedImage = image.resized(to: CGSize(width: 340, height: 140))
            strongPlusButton.setImage(resizedImage, for: .normal)
        }
        
        myPlanButton.tag = 1
        basicButton.tag = 2
        startButton.tag = 3
        startPlusButton.tag = 4
        strongButton.tag = 5
        strongPlusButton.tag = 6
        
        startPlusLabel.isHidden = true
        strongPlusLabel.isHidden = true
        
        myPlanButton.isHidden = true
        myPlanLabel.isHidden = true
    }
    
    @IBAction func myPlanButtonTapped(_ sender: UIButton) {
        //        if buttonSelectTempButton == sender {
        //            deleteSelectPlanView()
        //        } else {
        //            deleteSelectPlanView()
        //            selectPlanView(sender)
        //        }
        deleteSelectPlanView()
        selectPlanView(sender)
        //parentviewController?.updatePlan(timeResting: 8 * 3600, timeFasting: 16 * 3600, selectedPlan: .myPlan, selectedButtonTag : 1)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func basicButtonTapped(_ sender: UIButton) {
        deleteSelectPlanView()
        selectPlanView(sender)
        
        parentviewController?.updatePlan(timeResting: 8 * 3600, timeFasting: 16 * 3600, selectedPlan: .basic, selectedButtonTag : 2)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        deleteSelectPlanView()
        selectPlanView(sender)
        
        parentviewController?.updatePlan(timeResting: 12 * 3600, timeFasting: 12 * 3600, selectedPlan: .start, selectedButtonTag : 3)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startPlusButtonTapped(_ sender: UIButton) {
        deleteSelectPlanView()
        selectPlanView(sender)
        
        parentviewController?.updatePlan(timeResting: 10 * 3600, timeFasting: 14 * 3600, selectedPlan: .startPlus, selectedButtonTag : 4)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func strongButtonTapped(_ sender: UIButton) {
        deleteSelectPlanView()
        selectPlanView(sender)
        
        parentviewController?.updatePlan(timeResting: 6 * 3600, timeFasting: 18 * 3600, selectedPlan: .strong, selectedButtonTag : 5)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func strongPlusButtonTapped(_ sender: UIButton) {
        deleteSelectPlanView()
        selectPlanView(sender)
        
        parentviewController?.updatePlan(timeResting: 4 * 3600, timeFasting: 20 * 3600, selectedPlan: .strongPlus, selectedButtonTag : 6)
        navigationController?.popViewController(animated: true)
    }
    
    
    func selectPlanView(_ button: UIButton) {
        // Сохранение тега выбранной кнопки
        UserDefaults.standard.set(button.tag, forKey: "selectedButtonTag")
        
        buttonSelectTempButton = button
        button.layer.borderColor = UIColor.green.cgColor // Зелёная обводка
        button.layer.borderWidth = 6
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
            labelLayer.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 12), // Привязка к верхней границе кнопки с небольшим смещением
            labelLayer.widthAnchor.constraint(greaterThanOrEqualToConstant: 100), // Минимальная ширина метки
            labelLayer.heightAnchor.constraint(equalToConstant: 24) // Высота метки
        ])
    }
    
    func deleteSelectPlanView() {
        if let buttonSelect = buttonSelectTempButton {
            buttonSelect.layer.borderColor = UIColor.clear.cgColor
            labelLayer.removeFromSuperview()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(buttonSelectTempButton.tag, forKey: "selectedButtonTag")
    }
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
