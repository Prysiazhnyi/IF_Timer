//
//  ResaltViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 24.01.2025.
//

import UIKit

class ResultViewController: UIViewController {
    
    var viewController: ViewController?
    let chartView = FastingChartView()
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var thirdContainerView: UIView!
    
    @IBOutlet weak var titleMainContainerLabel: UILabel!
    @IBOutlet weak var timeMainContainerLabel: UILabel!
    @IBOutlet weak var planMainContainerLabel: UILabel!
    @IBOutlet weak var startMainContainerLabel: UILabel!
    @IBOutlet weak var finishMainContainerLabel: UILabel!
    
    @IBOutlet weak var secondContainerLabel: UILabel!
    
    @IBOutlet weak var planMainContainerButton: UIButton!
    @IBOutlet weak var startMainContainerButton: UIButton!
    @IBOutlet weak var finishMainContainerButton: UIButton!
    
    @IBOutlet weak var saveResultButton: UIButton!
    @IBOutlet weak var cancellResultButton: UIButton!
    
    var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButtonsInfo()
        
        secondContainerLabel.layer.cornerRadius = 20
        secondContainerLabel.layer.masksToBounds = true
        
        //thirdContainerView.backgroundColor = .clear
        // Пример данных
        chartView.data = [
            ("14 С", 6),
            ("15 С", 2),
            ("16 С", 12),
            ("17 С", 0),
            ("18 С", 8),
            ("19 С", 4),
            ("20 С", 10),
            ("21 С", 1),
            ("22 С", 18),
            ("23 С", 2)
        ]
        
        //chartView.backgroundColor = .red
        
        
        thirdContainerView.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        thirdContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true // Задай нужную высоту
        
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: thirdContainerView.leadingAnchor, constant: 10),
            chartView.trailingAnchor.constraint(equalTo: thirdContainerView.trailingAnchor, constant: -10),
            chartView.topAnchor.constraint(equalTo: thirdContainerView.topAnchor, constant: 10),
            chartView.bottomAnchor.constraint(equalTo: thirdContainerView.bottomAnchor, constant: -10)
        ])
        
    }
    
    func setupView() {
        
        // Установка фона экрана
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.94, blue: 0.91, alpha: 1.0)
        
        let arrayViews: [UIView] = [mainContainerView, secondContainerView, thirdContainerView]
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
    
    func setupButtonsInfo() {
        
        //finishMainContainerButton.isUserInteractionEnabled = false
        
        planMainContainerButton.backgroundColor = UIColor(red: 180/255, green: 235/255, blue: 250/255, alpha: 0.6)
        startMainContainerButton.backgroundColor = UIColor(red: 186/255, green: 217/255, blue: 181/255, alpha: 0.6)
        finishMainContainerButton.backgroundColor = UIColor(red: 250/255, green: 245/255, blue: 228/255, alpha: 0.6)
        
        let buttonsInfo: [UIButton] = [planMainContainerButton, startMainContainerButton, finishMainContainerButton]
        
        for button in buttonsInfo {
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true
            // Задаем ширину кнопок
            //button.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
            //button.widthAnchor.constraint(equalToConstant: CGFloat(equalToConstant)).isActive = true
            
            if button !== planMainContainerButton {
                
                let originalImage = UIImage(named: "iconPencil")
                let newSize = CGSize(width: 16, height: 16) // Новый размер изображения
                
                // Создаем уменьшенное изображение
                let resizedImage = UIGraphicsImageRenderer(size: newSize).image { _ in
                    originalImage?.draw(in: CGRect(origin: .zero, size: newSize))
                }
                
                // Присваиваем уменьшенное изображение в ImageView
                imageView = UIImageView(image: resizedImage)
                imageView.contentMode = .center // Центрируем изображение внутри UIImageView
                
                imageView.backgroundColor = UIColor(white: 0.8, alpha: 0.8)
                
                imageView.layer.cornerRadius = 10
                imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner] // Верхний левый и нижний правый углы
                imageView.layer.masksToBounds = true
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                // Добавляем UIImageView в кнопку
                button.addSubview(imageView)
                
                // Настроим Auto Layout для изображения
                NSLayoutConstraint.activate([
                    imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 0),
                    imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0),
                    imageView.widthAnchor.constraint(equalToConstant: 24),
                    imageView.heightAnchor.constraint(equalToConstant: 24)
                ])
            }
        }
        planMainContainerButton.setTitleColor(.black, for: .normal)
        planMainContainerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        planMainContainerButton.setTitle(viewController?.selectedPlan.selectedMyPlan, for: .normal)
        
        saveResultButton.layer.cornerRadius = 30
        saveResultButton.layer.masksToBounds = true
        
        cancellResultButton.layer.cornerRadius = 30
        cancellResultButton.layer.masksToBounds = true
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("Тап на кнопку сохранить")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancellButtonTapped(_ sender: UIButton) {
        print("Тап на кнопку отмена")
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
