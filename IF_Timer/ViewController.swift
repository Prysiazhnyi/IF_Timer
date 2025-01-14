//
//  ViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 14.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIView!

    // Ссылка на круговой прогресс
    var circularProgressView: CircularProgressView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.backgroundColor = .clear
        
        setupCircularProgress()
    }

    private func setupCircularProgress() {
        // Создаем экземпляр CircularProgressView
        circularProgressView = CircularProgressView(frame: progressBar.bounds)
        
        // Убедимся, что прогресс-бар существует
        guard let circularProgressView = circularProgressView else { return }
        
        // Добавляем его в progressBar
        progressBar.addSubview(circularProgressView)
        
        // Устанавливаем прогресс (например, 30%)
        circularProgressView.progress = 0.3
    }
    
    func updateProgress(value: CGFloat) {
        circularProgressView?.progress = value
    }

    
}

