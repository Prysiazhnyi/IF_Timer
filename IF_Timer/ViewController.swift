//
//  ViewController.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 14.01.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var titleProgressLabel: UILabel!
    @IBOutlet weak var timerProgressLabel: UILabel!
    @IBOutlet weak var percentProgressLabel: UILabel!
    
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    
    
    var imageView: UIImageView!
    // Ссылка на круговой прогресс
    var circularProgressView: CircularProgressView?
    var valueProgress: CGFloat = 0.0 {
        didSet {
            updateProgress(valueProgress)
            percentProgressLabel.text = "━━━━\n\(Int(valueProgress * 100))%"
        }
    }
    
    // Таймер
       private var countdownTimer: Timer?
       private var remainingTime: TimeInterval = 2 * 3600 // Оставшееся время в секундах
    
    var timeResting = 8 * 3600 // время голодания
    var timeFasting = 16 * 3600 // время приёма пищи
    var timeWait = 16 * 3600 // стартовое время таймера

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.backgroundColor = .clear
        percentProgressLabel.text = "━━\n\(Int(valueProgress * 100)) %"
        setupCircularProgress()
        
//        startLabel.isHidden = true
//        startButton.isHidden = true
        
        
        finishButton.backgroundColor = .blue
                
                // Создаем UIImageView для изображения
                imageView = UIImageView(image: UIImage(named: "icon-pencil"))
                imageView.backgroundColor = UIColor.lightGray
        
                imageView.layer.cornerRadius = 10
                imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner] // Верхний левый и нижний правый углы
                imageView.layer.masksToBounds = true

                
                // Добавляем UIImageView в кнопку
                finishButton.addSubview(imageView)
                
                // Настроим Auto Layout для изображения
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.bottomAnchor.constraint(equalTo: finishButton.bottomAnchor, constant: 0),
                    imageView.trailingAnchor.constraint(equalTo: finishButton.trailingAnchor, constant: 0),
                    imageView.widthAnchor.constraint(equalToConstant: 22),
                    imageView.heightAnchor.constraint(equalToConstant: 22)
                ])
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProgress(valueProgress)
        startTimer()
    }

    //MARK: Progress Bar
    
    private func setupCircularProgress() {
        // Создаем экземпляр CircularProgressView
        circularProgressView = CircularProgressView(frame: progressBar.bounds)
        
        // Убедимся, что прогресс-бар существует
        guard let circularProgressView = circularProgressView else { return }
        
        // Добавляем его в progressBar
        progressBar.addSubview(circularProgressView)
        
        // Устанавливаем прогресс (например, 30%)
        //circularProgressView.progress = 0.3
    }
    
    func updateProgress(_ value: CGFloat) {
        circularProgressView?.progress = value
    }
    
//    func setupProgress() {
//        titleProgressLabel.text = "Залишилось часу"
//        
//    }
    
    //MARK: Timer
    
    private func startTimer() {
            // Останавливаем предыдущий таймер, если он существует
            countdownTimer?.invalidate()
            
            // Создаем новый таймер
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateCountdown()
            }
        }
    private func updateCountdown() {
            // Уменьшаем оставшееся время
            if remainingTime > 0 {
                remainingTime -= 1
                updateTimerLabel()
                
                // Обновляем прогресс (например, по пропорции)
                valueProgress = CGFloat(1 - remainingTime / TimeInterval(timeWait))
            } else {
                // Останавливаем таймер, если время истекло
                countdownTimer?.invalidate()
                countdownTimer = nil
                timerProgressLabel.text = "00:00:00"
            }
        }
    private func updateTimerLabel() {
            // Форматируем оставшееся время в HH:MM:SS
            let hours = Int(remainingTime) / 3600
            let minutes = (Int(remainingTime) % 3600) / 60
            let seconds = Int(remainingTime) % 60
            timerProgressLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }

    // MARK:
    
    
    
}

