//
//  SetupTimer.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 20.01.2025.
//

import Foundation
import UIKit

class SetupTimer: UIViewController {
    
    var viewController: ViewController!
    var circularProgressView: CircularProgressView?

    // Таймер
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 2 * 3600 // Оставшееся время в секундах
    let currentTime = Date()
    
    func startTimer() {
        
        // Останавливаем предыдущий таймер, если он существует
        countdownTimer?.invalidate()
        
        // Если таймер запущен (не голодание)
        if viewController.isStarvation {
            
            // Вычисляем оставшееся время
            remainingTime = Double(viewController.timeFasting) - currentTime.timeIntervalSince(viewController.startDate)
            
            // Создаем новый таймер
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateCountdown()
            }
            viewController.titleProgressLabel.text = "Залишилось часу"
        } else {
            
            remainingTime = Double(viewController.timeResting) - currentTime.timeIntervalSince(viewController.startDate)
            print("remainingTime - \(remainingTime)")
            // Создаем новый таймер
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateCountdown()
            }
                viewController.percentProgressLabel.text = ""
                viewController.titleProgressLabel.text = "До наступного\n інтервального голодування"
                
            //countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
            //viewController.titleProgressLabel.text = "Поточний час"
           
        }
    }
    
//    @objc private func updateCurrentTime() {
//        
//        // Получаем текущее время
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        let formattedTime = dateFormatter.string(from: Date())  // Используем Date() для текущего времени
//        
//        // Обновляем метку с текущим временем
//        viewController.timerProgressLabel.text = formattedTime
//    }
    
    private func updateCountdown() {
     
        remainingTime -= 1
        updateTimerLabel()
        
        // Обновляем прогресс (например, по пропорции)
        viewController.valueProgress = CGFloat(1 - remainingTime / TimeInterval(viewController.timeFasting))
    }
    
    private func updateTimerLabel() {
        
        let validRemainingTime = abs(remainingTime)
        // Форматируем оставшееся время в HH:MM:SS
        let hours = Int(validRemainingTime) / 3600
        let minutes = (Int(validRemainingTime) % 3600) / 60
        let seconds = Int(validRemainingTime) % 60
        
        var  sign = ""
        if  Int(remainingTime) / 3600 < 0 || Int(remainingTime) % 3600 / 60 < 0 || Int(remainingTime) % 60 < 0 {
            sign = "+"
            callChangeColorFunction(isColorChanged: false)
        } else {
            callChangeColorFunction(isColorChanged: true)
        }
        viewController.timerProgressLabel.text = String(format: "%@%02d:%02d:%02d", sign, hours, minutes, seconds)
    }
    
    func callChangeColorFunction(isColorChanged: Bool) {
            viewController?.circularProgressView?.changeColorProgressView(isColorChanged)
        }
}
