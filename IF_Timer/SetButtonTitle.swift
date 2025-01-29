//
//  SetButtonTitle.swift
//  IF_Timer
//
//  Created by Serhii Prysiazhnyi on 28.01.2025.
//

import Foundation
import UIKit

class SetButtonTitle: NSObject, UIAppearanceContainer {
    
    func setButtonTitle(for button: UIButton, date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let selectedDate = calendar.startOfDay(for: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "uk_UA") // Украинская локализация
        
        // Форматируем дату и время
        var dateString: String
        
        if selectedDate == today {
            dateString = "Сьогодні"
        } else if selectedDate == tomorrow {
            dateString = "Завтра"
        } else {
            dateFormatter.dateFormat = "dd MMM"
            dateString = dateFormatter.string(from: date)
        }
        
        // Форматируем время
        
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: date)
        
        // Настроим отступ между строками
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // Увеличиваем межстрочный интервал (в точках)
        paragraphStyle.alignment = .center // Центрируем текст
        
        // Создаем атрибутированный текст для первой строки (жирный шрифт)
        let dateAttributedString = NSMutableAttributedString(
            string: "\(dateString)\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 17), // Жирный шрифт для первой строки
                .foregroundColor: UIColor.darkGray, // Черный цвет текста
                .paragraphStyle: paragraphStyle // Применяем межстрочный стиль
            ]
        )
        
        // Создаем атрибутированный текст для второй строки (обычный шрифт)
        let timeAttributedString = NSAttributedString(
            string: timeString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17), // Обычный шрифт для второй строки
                .foregroundColor: UIColor.darkGray, // Черный цвет текста
                .paragraphStyle: paragraphStyle // Применяем тот же межстрочный стиль для выравнивания
            ]
        )
        
        // Добавляем вторую строку к первой
        dateAttributedString.append(timeAttributedString)
        
        // Устанавливаем атрибутированный текст для кнопки
        button.setAttributedTitle(dateAttributedString, for: .normal)
        
        // Включаем многострочный текст и выравнивание
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center // Выравниваем по центру
        
        //print("button.setAttributedTitle - \(button.titleLabel)")
    }
    
}
