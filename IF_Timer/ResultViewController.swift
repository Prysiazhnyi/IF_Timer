//
//  ResaltViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 24.01.2025.
//

import UIKit

class ResultViewController: UIViewController {
    
    //var parentviewController: ViewController! // Ссылка на первый контроллер
    //var someProperty: String?
    var viewController: ViewController?
    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    
    @IBOutlet weak var titleMainContainerLabel: UILabel!
    @IBOutlet weak var timeMainContainerLabel: UILabel!
    @IBOutlet weak var planMainContainerLabel: UILabel!
    @IBOutlet weak var startMainContainerLabel: UILabel!
    @IBOutlet weak var finishMainContainerLabel: UILabel!
    
    @IBOutlet weak var secondContainerLabel: UILabel!
    
    @IBOutlet weak var planMainContainerButton: UIButton!
    @IBOutlet weak var startMainContainerButton: UIButton!
    @IBOutlet weak var finishMainContainerButton: UIButton!
    
    var imageView: UIImageView!
    
    // Переопределите инициализатор, чтобы он принимал ViewController
//    init(viewController: ViewController) {
//        self.viewController = viewController
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButtonsInfo()
    }
    
    func setupView() {
        
        // Установка фона экрана
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.94, blue: 0.91, alpha: 1.0)
        
        // Настройка контейнера с информацией
        mainContainerView.backgroundColor = UIColor.white
        mainContainerView.layer.cornerRadius = 25
        mainContainerView.layer.shadowColor = UIColor.black.cgColor
        mainContainerView.layer.shadowOpacity = 0.1
        mainContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainContainerView.layer.shadowRadius = 8
        mainContainerView.layer.masksToBounds = false
        
        // Настройка блока с цитатой
        secondContainerView.backgroundColor = UIColor.white
        secondContainerView.layer.cornerRadius = 25
        
        secondContainerLabel.layer.cornerRadius = 20
        secondContainerLabel.layer.masksToBounds = true
        
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
                imageView = UIImageView(image: UIImage(named: "icon-pencil"))
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
      
    }
    
    

    
}
