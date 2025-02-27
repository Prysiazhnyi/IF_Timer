//
//  SetupTimer.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 20.01.2025.
//

import Foundation
import UIKit

class SetupTimer: UIViewController {
    
    var viewController: ViewController
    var circularProgressView: CircularProgressView
    
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 2 * 3600 // Оставшееся время в секундах
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid

    init(viewController: ViewController, circularProgressView: CircularProgressView) {
        self.viewController = viewController
        self.circularProgressView = circularProgressView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрируем наблюдателей для перехода приложения в фон и обратно
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // Старт таймера
    func startTimer(_ currentTime: Date) {
        let currentTime = currentTime
        
        // Останавливаем предыдущий таймер, если он существует
        countdownTimer?.invalidate()

        // Сохраняем время старта в UserDefaults перед переходом в фон
        UserDefaults.standard.set(currentTime, forKey: "startTime")

        // Запускаем фоновую задачу для продолжения таймера в фоновом режиме
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
            self.backgroundTaskIdentifier = .invalid
        }
        
        // Если таймер запущен (не голодание)
        if viewController.isStarvation {
            remainingTime = Double(viewController.timeFasting) - currentTime.timeIntervalSince(viewController.startDate)
        } else {
            remainingTime = Double(viewController.timeResting) - currentTime.timeIntervalSince(viewController.startDate)
        }

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
        
        viewController.setupTitleProgressLabel()
    }
    
    private func updateCountdown() {
        remainingTime -= 1
        updateTimerLabel()
        
        // Обновляем прогресс
        if viewController.isStarvation {
            viewController.valueProgress = CGFloat(1 - remainingTime / TimeInterval(viewController.timeFasting))
        } else {
            viewController.valueProgress = CGFloat(1 - remainingTime / TimeInterval(viewController.timeResting))
        }
    }
    
    private func updateTimerLabel() {
        let validRemainingTime = abs(remainingTime)
        let hours = Int(validRemainingTime) / 3600
        let minutes = (Int(validRemainingTime) % 3600) / 60
        let seconds = Int(validRemainingTime) % 60
        
        let sign = Int(remainingTime) < 0 ? "+" : ""
        
        viewController.circularProgressView?.changeColorProgressView()
        viewController.timeIsUp = (sign == "+") ? true : false
        viewController.timerProgressLabel.text = String(format: "%@%02d:%02d:%02d", sign, hours, minutes, seconds)
    }
    
    // При переходе в фон
    @objc func applicationWillResignActive() {
        UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
        countdownTimer?.invalidate()
    }
    
    // При возвращении в активное состояние
    @objc func applicationDidBecomeActive() {
        if let savedTime = UserDefaults.standard.object(forKey: "remainingTime") as? TimeInterval {
            remainingTime = savedTime
            startTimer(Date())
        }
    }
}
