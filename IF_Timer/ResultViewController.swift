//
//  ResaltViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 24.01.2025.
//

import UIKit

class ResultViewController: UIViewController {
    
    //var parentviewController: ViewController? // Ссылка на первый контроллер
    //var someProperty: String?

    
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    
    @IBOutlet weak var titleMainContainerLabel: UILabel!
    @IBOutlet weak var timeMainContainerLabel: UILabel!
    @IBOutlet weak var planMainContainerLabel: UILabel!
    @IBOutlet weak var startMainContainerLabel: UILabel!
    @IBOutlet weak var finishMainContainerLabel: UILabel!
    
    @IBOutlet weak var secondContainerLabel: UILabel!
    
    @IBOutlet weak var startMainContainerButton: UIButton!
    @IBOutlet weak var planMainContainerButton: UIButton!
    @IBOutlet weak var finishMainContainerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
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
        
    }

    
}
