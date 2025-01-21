//
//  SetupTimer.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 20.01.2025.
//

import Foundation
import UIKit

class SetupTimer: UIViewController {
    
    weak var vc: ViewController?
    var circularProgressView: CircularProgressView?

    // Таймер
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 2 * 3600 // Оставшееся время в секундах
    let currentTime = Date()
    
    func startTimer() {
        guard let vc = vc else {
               print("Ошибка: vc не инициализирован")
               return
           }
        // Останавливаем предыдущий таймер, если он существует
        countdownTimer?.invalidate()
        
        // Если таймер запущен (не голодание)
        if vc.isStarvation {
            
            // Вычисляем оставшееся время
            remainingTime = Double(vc.timeResting) - currentTime.timeIntervalSince(vc.startDate)
            
            // Создаем новый таймер
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateCountdown()
            }
            vc.titleProgressLabel.text = "Залишилось часу"
        } else {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
            vc.percentProgressLabel.text = ""
            vc.titleProgressLabel.text = "Поточний час"
        }
    }
    
    @objc private func updateCurrentTime() {
        guard let vc = vc else {
               print("Ошибка: vc не инициализирован")
               return
           }
        
        // Получаем текущее время
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let formattedTime = dateFormatter.string(from: Date())  // Используем Date() для текущего времени
        
        // Обновляем метку с текущим временем
        vc.timerProgressLabel.text = formattedTime
    }
    
    private func updateCountdown() {
        guard let vc = vc else {
               print("Ошибка: vc не инициализирован")
               return
           }
        remainingTime -= 1
        updateTimerLabel()
        
        // Обновляем прогресс (например, по пропорции)
        vc.valueProgress = CGFloat(1 - remainingTime / TimeInterval(vc.timeResting))
    }
    
    private func updateTimerLabel() {
        guard let vc = vc else {
               print("Ошибка: vc не инициализирован")
               return
           }
        
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
        vc.timerProgressLabel.text = String(format: "%@%02d:%02d:%02d", sign, hours, minutes, seconds)
    }
    
    func callChangeColorFunction(isColorChanged: Bool) {
            vc?.circularProgressView?.changeColorProgressView(isColorChanged)
        }
}
