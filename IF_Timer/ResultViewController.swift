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

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var quoteView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка фона экрана
        self.view.backgroundColor = UIColor(red: 0.89, green: 0.94, blue: 0.91, alpha: 1.0)
        
        // Настройка контейнера с информацией
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.masksToBounds = false
        
        // Настройка блока с цитатой
        quoteView.backgroundColor = UIColor.white
        quoteView.layer.cornerRadius = 12
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
